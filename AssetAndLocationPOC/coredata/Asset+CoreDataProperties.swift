//
//  Asset+CoreDataProperties.swift
//  AssetsAndLocationPOC
//
//  Created by Pavan Kumar on 13/08/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Asset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Asset> {
        return NSFetchRequest<Asset>(entityName: "Asset")
    }

    @NSManaged public var assetID: Int64
    @NSManaged public var assetDesc: String?
    @NSManaged public var location: Location?

}
