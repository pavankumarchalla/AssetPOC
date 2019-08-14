//
//  ViewController.swift
//  AssetAndLocationPOC
//
//  Created by Pavan Kumar on 13/08/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
  @IBOutlet var tableView: UITableView!
  
  let coredataManager = CoreDataManager()
  
  var resultSearchController = UISearchController()
  
  fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Asset> = {
    let fetchRequest: NSFetchRequest<Asset> = Asset.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "assetID", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coredataManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    return fetchedResultsController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    
    fetchAndStoreData()
		
    resultSearchController = {
      let controller = UISearchController(searchResultsController: nil)
      controller.searchResultsUpdater = self
      controller.obscuresBackgroundDuringPresentation = false
      controller.hidesNavigationBarDuringPresentation = false
      controller.searchBar.sizeToFit()
      controller.searchBar.showsSearchResultsButton = true
      
      tableView.tableHeaderView = controller.searchBar
      
      return controller
    }()
    
    do {
      try fetchedResultsController.performFetch()
      tableView.reloadData()
    } catch {
      print("fetch failed")
    }
  }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("Memory warning received")
	}
  
  // MARK: - Search delegate
  
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
  
  // MARK: - Tableview
  
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
  
  // Custome methods
  
  func fetchAndStoreData() {
    if let path = Bundle.main.path(forResource: "asset", ofType: "json") {
      let itemData = FileManager.default.contents(atPath: path)
      let decoder = JSONDecoder()
      let response = try! decoder.decode(Response.self, from: itemData!)
      
      importFrom(response: response)
    }
  }
  
  func importFrom(response: Response) {
    let assetsData = response.queryE3MASSETResponse.e3MASSETSet.aSSET
    let moc = CoreDataManager().persistentContainer.newBackgroundContext()
		moc.undoManager = nil
		
		// Process records in batches to avoid a high memory footprint.
		let batchSize = 5000
		let count = assetsData.count
		
		// Determine the total number of batches.
		var numBatches = count / batchSize
		numBatches += count % batchSize > 0 ? 1 : 0
		
		for batchNumber in 0 ..< numBatches {
			
			// Determine the range for this batch.
			let batchStart = batchNumber * batchSize
			let batchEnd = batchStart + min(batchSize, count - batchNumber * batchSize)
			let range = batchStart..<batchEnd
			
			// Create a batch for this range from the decoded JSON.
			let quakesBatch = Array(assetsData[range])
			
			// Stop the entire import if any batch is unsuccessful.
			if !importOneBatch(quakesBatch, taskContext: moc) {
				return
				
			}
		}

  }

	
	private func importOneBatch(_ assetsBatch: [ASSET], taskContext: NSManagedObjectContext) -> Bool {
		
		var success = false
		
		taskContext.performAndWait {
			// Create a new record for each quake in the batch.
			for assetData in assetsBatch {
				guard let assetMdl = NSEntityDescription.insertNewObject(forEntityName: "Asset", into: taskContext) as? Asset else {
					return
				}

				assetMdl.buildFromObject(asset: assetData)
			}
			
			// Save all insertions and deletions from the context to the store.
			if taskContext.hasChanges {
				do {
					try taskContext.save()
				} catch {
					print("Error: \(error)\nCould not save Core Data context.")
					return
				}
				// Reset the taskContext to free the cache and lower the memory footprint.
				taskContext.reset()
			}
			
			success = true
		}
		return success
	}
	
	func deleteAllData(_ entity: String) {
		let moc = CoreDataManager().persistentContainer.viewContext
		
		let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
		request.returnsObjectsAsFaults = false
		
		do {
			let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
			try moc.execute(deleteRequest)
		} catch {
			let fetchError = error as NSError
			print("error fetching data \(fetchError)")
		}
	}
	
}
