//
//  PictureURL+CoreDataProperties.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 12/16/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation
import CoreData


extension PictureURL {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PictureURL> {
        return NSFetchRequest<PictureURL>(entityName: "PictureURL");
    }

    @NSManaged public var url: String?
    @NSManaged public var location: Location?

}
