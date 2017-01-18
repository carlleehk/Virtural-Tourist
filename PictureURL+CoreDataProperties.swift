//
//  PictureURL+CoreDataProperties.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 1/18/17.
//  Copyright © 2017 Carl Lee. All rights reserved.
//

import Foundation
import CoreData


extension PictureURL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PictureURL> {
        return NSFetchRequest<PictureURL>(entityName: "PictureURL");
    }

    @NSManaged public var url: String?
    @NSManaged public var photoData: NSData?
    @NSManaged public var location: Location?

}
