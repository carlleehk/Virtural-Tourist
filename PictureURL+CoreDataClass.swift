//
//  PictureURL+CoreDataClass.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/16/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation
import CoreData

@objc(PictureURL)
public class PictureURL: NSManagedObject {
    
    convenience init(url: String, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "PictureURL", in: context){
            
            self.init(entity: ent, insertInto: context)
            self.url = url
            
        } else{
            fatalError("Unable to find entity name")
        }
    }


}
