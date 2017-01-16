//
//  MapRegion+CoreDataProperties.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/14/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation
import CoreData


extension MapRegion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MapRegion> {
        return NSFetchRequest<MapRegion>(entityName: "MapRegion");
    }

    @NSManaged public var centerLat: Double
    @NSManaged public var centerLong: Double
    @NSManaged public var spanLat: Double
    @NSManaged public var spanLong: Double

}
