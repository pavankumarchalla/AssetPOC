//
//  ViewController.swift
//  AssetAndLocationPOC
//
//  Created by Pavan Kumar on 13/08/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

	@IBOutlet weak var tableView: UITableView!
	
	let coredataManager = CoreDataManager()
	
	var resultSearchController = UISearchController()
	
	fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Asset> = {
		
		let fetchRequest: NSFetchRequest<Asset> = Asset.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "assetID", ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coredataManager.persistentContainer.viewContext , sectionNameKeyPath: nil, cacheName: nil)
		
		return fetchedResultsController
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.tableFooterView = UIView()
		
		fetchAndStoreData()
		
		resultSearchController = ({
			let controller = UISearchController(searchResultsController: nil)
			controller.searchResultsUpdater = self
			controller.obscuresBackgroundDuringPresentation = false
			controller.hidesNavigationBarDuringPresentation = false
			controller.searchBar.sizeToFit()
			controller.searchBar.showsSearchResultsButton = true
			
			tableView.tableHeaderView = controller.searchBar
			
			return controller
		})()
		
		do {
			try fetchedResultsController.performFetch()
			tableView.reloadData()
		} catch {
			print("fetch failed")
		}
		
	}
	
	//MARK: - Search delegate
	
	func updateSearchResults(for searchController: UISearchController) {
		let searchText = searchController.searchBar.text ?? ""
		var predicate: NSPredicate?
		if searchText.count > 0 {
			predicate = NSPredicate(format: "(assetDesc contains[cd] %@)", searchText)
		} else {
			predicate = nil
		}
		
		fetchedResultsController.fetchRequest.predicate = predicate
		
		do {
			try fetchedResultsController.performFetch()
			tableView.reloadData()
		} catch let err {
			print(err)
		}
	}
	
	//MARK:- Tableview
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let assets = fetchedResultsController.fetchedObjects else { return 0 }
		return assets.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let asset = fetchedResultsController.object(at: indexPath)
		cell.textLabel?.text = asset.assetDesc
		return cell
	}
	
	//Custome methods
	
	func fetchAndStoreData() {
		
		
		if let path = Bundle.main.path(forResource: "asset", ofType: "json") {
			
			var itemData = FileManager.default.contents(atPath: path)
			
			var jsonData = try! JSONSerialization.jsonObject(with: itemData!, options: []) as? [String: Any]
			
			itemData?.removeAll(keepingCapacity: false)
			
			let assetsData = (((jsonData?["QueryE3MASSETResponse"] as? [String: Any])?["E3MASSETSet"] as? [String: Any])?["ASSET"] as? [[String: Any]] ?? [])
				
				let moc = CoreDataManager().persistentContainer.newBackgroundContext()
				
				for json in assetsData {
					let assetMdl = Asset(context: moc)
					assetMdl.buildFromJSON(json: json)
				}
				
				try! moc.save()
				tableView.reloadData()
			
		}
	}
	
	func deleteAllData(_ entity:String) {
		let moc = CoreDataManager().persistentContainer.viewContext
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
		request.returnsObjectsAsFaults = false
		
		do {
			let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
			try moc.execute(deleteRequest)
		}
		catch {
			let fetchError = error as NSError
			print("error fetching data \(fetchError)")
		}
	}
	

}

