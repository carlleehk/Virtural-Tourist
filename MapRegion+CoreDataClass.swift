//
//  MapRegion+CoreDataClass.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/14/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation
import CoreData

@objc(MapRegion)
public class MapRegion: NSManagedObject {

    convenience init(centerlat: Double, centerlong: Double, spanlat:Double, spanlong: Double, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "MapRegion", in: context){
            
            self.init(entity: ent, insertInto: context)
            self.spanLat = spanlat
            self.spanLong = spanlong
            self.centerLat = centerlat
            self.centerLong = centerlong
            
        } else{
            fatalError("Unable to find entity name")
        }
    }

    
}
