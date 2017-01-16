//
//  Location+CoreDataProperties.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/16/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location");
    }

    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var url: NSSet?

}

// MARK: Generated accessors for url
extension Location {

    @objc(addUrlObject:)
    @NSManaged public func addToUrl(_ value: PictureURL)

    @objc(removeUrlObject:)
    @NSManaged public func removeFromUrl(_ value: PictureURL)

    @objc(addUrl:)
    @NSManaged public func addToUrl(_ values: NSSet)

    @objc(removeUrl:)
    @NSManaged public func removeFromUrl(_ values: NSSet)

}
