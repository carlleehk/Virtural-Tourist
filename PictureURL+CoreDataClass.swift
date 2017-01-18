//
//  PictureURL+CoreDataClass.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 1/18/17.
//  Copyright © 2017 Carl Lee. All rights reserved.
//

import Foundation
import CoreData

@objc(PictureURL)
public class PictureURL: NSManagedObject {
    
    convenience init(url: String, image: NSData?, context: NSManagedObjectContext){
        
        if let ent = NSEntityDescription.entity(forEntityName: "PictureURL", in: context){
            
            self.init(entity: ent, insertInto: context)
            self.url = url
            self.photoData = image
            
        } else{
            fatalError("Unable to find entity name")
        }
    }


}
