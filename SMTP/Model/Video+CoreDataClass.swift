//
//  Video+CoreDataClass.swift
//  SMTP
//
//  Created by Dipak on 07/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import Foundation
import CoreData

@objc(Video)
public class Video: NSManagedObject {

    static var ENTITY_NAME: String = "Video"

    class func getAllRecord(_ predicate:[NSPredicate]?=nil) -> [Video] {
        
        let db = CoreDataHelper.getContext(Video.ENTITY_NAME, inBackground: false)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Video.ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: "originalFileName", ascending: true)]
       
        if predicate != nil && !predicate!.isEmpty{
            let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates:predicate!)
            request.predicate = predicate;
        }
        var results: [Video] = [Video]()
        
        do {
            try results = db.context.fetch(request) as! [Video]
        } catch let error as NSError {
            //print(error.localizedDescription)
        }
        
        return results;
    }
    
    
    class func getDataModel() -> Video{
    
        let db = CoreDataHelper.getContext(Video.ENTITY_NAME, inBackground: false)
        return Video(entity: db.entity, insertInto: db.context);
    }
    
    func videoURL() -> String {
        return UrlConstants.VIDEO_URL + self.originalFileName!.encodeURL()!
    }
    
    func saveContext(){
        let db = CoreDataHelper.getContext(Video.ENTITY_NAME, inBackground: false);
        db.coreDataHelper.saveContext(db.context);
    }
    
    func deleteRecord(){
        let db = CoreDataHelper.getContext(Video.ENTITY_NAME, inBackground: false);
        db.context.delete(self);
    }
}
