//
//  CoreDataHelper.swift
//  SMTP
//
//  Created by Angel Ignatov on 10/26/15.
//  Copyright © 2015 Aggressione. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper: NSObject {
    
    let store: CoreDataStore!
    
    override init(){
        // all CoreDataHelper share one CoreDataStore defined in AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.store = appDelegate.coreDataStore
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CoreDataHelper.contextDidSaveContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // #pragma mark - Core Data stack
    
    // Returns the managed object context for the application.
    // Normally, you can use it to do anything.
    // But for bulk data update, acording to Florian Kugler's blog about core data performance, [Concurrent Core Data Stacks – Performance Shootout](http://floriankugler.com/blog/2013/4/29/concurrent-core-data-stack-performance-shootout) and [Backstage with Nested Managed Object Contexts](http://floriankugler.com/blog/2013/5/11/backstage-with-nested-managed-object-contexts). We should better write data in background context. and read data from main queue context.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    
    // main thread context
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.store.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // Returns the background object context for the application.
    // You can use it to process bulk data update in background.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    
    lazy var backgroundContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.store.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
        }()
    
    
    // save NSManagedObjectContext
    func saveContext (_ context: NSManagedObjectContext) {
        
        if (context.hasChanges) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            do {
                try context.save()
            } catch let error as NSError {
                NSLog("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
            
        }
    }
    
    func saveContext () {
        self.saveContext(self.backgroundContext!)
    }
    
    // call back function by saveContext, support multi-thread
    func contextDidSaveContext(_ notification: Notification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender === self.managedObjectContext {
            //NSLog("******** Saved main Context in this thread")
            self.backgroundContext!.perform {
                self.backgroundContext!.mergeChanges(fromContextDidSave: notification)
            }
        } else if sender === self.backgroundContext {
            //NSLog("******** Saved background Context in this thread")
            self.managedObjectContext!.perform {
                self.managedObjectContext!.mergeChanges(fromContextDidSave: notification)
            }
        } else {
            //NSLog("******** Saved Context in other thread")
            self.backgroundContext!.perform {
                self.backgroundContext!.mergeChanges(fromContextDidSave: notification)
            }
            self.managedObjectContext!.perform {
                self.managedObjectContext!.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
    
    class func getContext(_ entityName: String, inBackground: Bool) -> (coreDataHelper: CoreDataHelper, context: NSManagedObjectContext, entity: NSEntityDescription) {
        
        let coreDataHelper = (UIApplication.shared.delegate as! AppDelegate).coreDataHelper
        
        var context: NSManagedObjectContext!
        
        if (inBackground) {
            context = coreDataHelper.backgroundContext!
        } else {
            context = coreDataHelper.managedObjectContext!
        }
        
        let ent = NSEntityDescription.entity(forEntityName: entityName, in: context)

        return (coreDataHelper, context, ent!)
    }
    
}
