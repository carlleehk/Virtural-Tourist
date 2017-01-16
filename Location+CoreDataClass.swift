//
//  Location+CoreDataClass.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/16/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {
    
    convenience init(lat: Double, long: Double, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "Location", in: context){
            
            self.init(entity: ent, insertInto: context)
            self.lat = lat
            self.long = long
            
        } else{
            fatalError("Unable to find entity name")
        }
    }


}
