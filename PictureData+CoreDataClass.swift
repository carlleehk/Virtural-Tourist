//
//  PictureData+CoreDataClass.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 1/18/17.
//  Copyright © 2017 Carl Lee. All rights reserved.
//

import Foundation
import CoreData

@objc(PictureData)
public class PictureData: NSManagedObject {
    
    convenience init(image: NSData, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "PictureData", in: context){
            
            self.init(entity: ent, insertInto: context)
            self.photoData = image
            
        } else{
            fatalError("Unable to find entity name")
        }
    }


}
