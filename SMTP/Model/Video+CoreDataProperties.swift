//
//  Video+CoreDataProperties.swift
//  SMTP
//
//  Created by Dipak on 07/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video");
    }
    @NSManaged public var status: String?
    @NSManaged public var duration: String?
    @NSManaged public var playerName: String?
    @NSManaged public var strokeImage: String?
    @NSManaged public var upgradeVideo: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var isDownloaded: Bool
    @NSManaged public var isPurchased: Bool
    @NSManaged public var isFavorite: Bool
    @NSManaged public var videoId: Int64
    @NSManaged public var createdDate: String?
    @NSManaged public var playerImages: String?
    @NSManaged public var videoSize: String?
    @NSManaged public var fileName: String?
    @NSManaged public var strokeName: String?
    @NSManaged public var code: String?
    @NSManaged public var accountType: String?
    @NSManaged public var quality: String?
    @NSManaged public var viewId: Int64
    @NSManaged public var viewName: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var strokesId: Int64
    @NSManaged public var originalFileName: String?
    @NSManaged public var favorite: String?
    @NSManaged public var playerId: Int64

    
   
}
