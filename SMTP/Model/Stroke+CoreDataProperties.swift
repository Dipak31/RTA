//
//  Stroke+CoreDataProperties.swift
//  SMTP
//
//  Created by Dipak on 01/04/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import Foundation
import CoreData


extension Stroke {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stroke> {
        return NSFetchRequest<Stroke>(entityName: "Stroke")
    }

    @NSManaged public var id: Int64
    @NSManaged public var accountTypeId: Int64
    @NSManaged public var image: String?
    @NSManaged public var lockImage: String?
    @NSManaged public var isPurchased: Bool
    @NSManaged public var name: String?
    @NSManaged public var womenImage: String?
    @NSManaged public var menImage: String?
    @NSManaged public var sortName: String?

}
