//
//  Stroke+CoreDataClass.swift
//  SMTP
//
//  Created by Dipak on 01/04/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import Foundation
import CoreData

@objc(Stroke)
public class Stroke: NSManagedObject {

    static var ENTITY_NAME: String = "Stroke"
    
    class func getAllRecord(_ predicate:[NSPredicate]?=nil) -> [Stroke] {
        
        let db = CoreDataHelper.getContext(Stroke.ENTITY_NAME, inBackground: false)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Stroke.ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        //request.sortDescriptors = [NSSortDescriptor(key: "originalFileName", ascending: true)]
    
        var results: [Stroke] = [Stroke]()
        
        do {
            try results = db.context.fetch(request) as! [Stroke]
        } catch let error as NSError {
            //print(error.localizedDescription)
        }
        
        return results;
    }
    
    
    class func getDataModel() -> Stroke{
        
        let db = CoreDataHelper.getContext(Stroke.ENTITY_NAME, inBackground: false)
        return Stroke(entity: db.entity, insertInto: db.context);
    }
    
  
    
    func saveContext(){
        let db = CoreDataHelper.getContext(Stroke.ENTITY_NAME, inBackground: false);
        db.coreDataHelper.saveContext(db.context);
    }
    
    func deleteRecord(){
        let db = CoreDataHelper.getContext(Stroke.ENTITY_NAME, inBackground: false);
        db.context.delete(self);
    }

}
