//
//  PictureData+CoreDataProperties.swift
//  Virtural Tourist
//
//  Created by Carl Lee on 1/19/17.
//  Copyright © 2017 Carl Lee. All rights reserved.
//

import Foundation
import CoreData


extension PictureData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PictureData> {
        return NSFetchRequest<PictureData>(entityName: "PictureData");
    }

    @NSManaged public var photoData: NSData?
    @NSManaged public var picURL: String?
    @NSManaged public var location: Location?

}
