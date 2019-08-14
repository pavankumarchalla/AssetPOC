//
//  Location+CoreDataProperties.swift
//  AssetsAndLocationPOC
//
//  Created by Pavan Kumar on 13/08/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var locationID: Int64
    @NSManaged public var locationDesc: String?
    @NSManaged public var assets: NSSet?

}

// MARK: Generated accessors for assets
extension Location {

    @objc(addAssetsObject:)
    @NSManaged public func addToAssets(_ value: Asset)

    @objc(removeAssetsObject:)
    @NSManaged public func removeFromAssets(_ value: Asset)

    @objc(addAssets:)
    @NSManaged public func addToAssets(_ values: NSSet)

    @objc(removeAssets:)
    @NSManaged public func removeFromAssets(_ values: NSSet)

}
