//
//  Asset+CoreDataClass.swift
//  AssetsAndLocationPOC
//
//  Created by Pavan Kumar on 13/08/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Asset)
public class Asset: NSManagedObject {

	func buildFromJSON(json: [String: Any]) {
		self.assetID =  json["ASSETUID"] as? Int64 ?? 0
		self.assetDesc = json["DESCRIPTION"] as? String
	}
	
}
