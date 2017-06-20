//
//  DataController.swift
//  Filterer
//
//  Created by Administrator on 05.06.17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
/* Keep track of an instance of NSManagedObjectContext */
    let managedObjectContext: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.managedObjectContext = moc
    }

/* Setting up all of the objects in the stacks */
/* Creating the entire core data stack - creating entities, persisting them to the persistent store, searching them */
    convenience init?() {
/* Extension "momd" did received after compiling .xcdatamodel file in app */
        guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd") else {
            return nil
        }
/* Encapsulationg model file */
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            return nil
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let persistantStoreFileURL = urls[0].URLByAppendingPathComponent("Bookmarks.sqlite")
        
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: persistantStoreFileURL, options: nil)
        } catch {
            fatalError("Error adding store.")
        }
        self.init(moc: moc)
    }

    
    
/* Taking imageFeedItem, string for a tag name, and add it to document */
/* Searching - FetchRequest, creating - save, setting properties of the items, setting relationship */
    
    func tagFeedItem(tagTitle: String, feedItem: ImageFeedItem) {

/* Avoiding duplicate tags */
        let tagsFetch = NSFetchRequest(entityName: "Tag")
/* Looking for a title that equals the title that we've requested (Cocoa syntax) */
        tagsFetch.predicate = NSPredicate(format: "tagTitle == %@", tagTitle)
        
        var fetchedTags: [Tag]!
        do {
            fetchedTags = try self.managedObjectContext.executeFetchRequest(tagsFetch) as! [Tag]
        } catch {
            fatalError("fetch failed")
        }

/* Creating new one title, if requested didn't found*/
        var tag: Tag
        if fetchedTags.count == 0 {
            tag = NSEntityDescription.insertNewObjectForEntityForName("Tag", inManagedObjectContext: self.managedObjectContext) as! Tag
            tag.tagTitle = tagTitle
        } else {
            tag = fetchedTags[0]
        }
        
        let newImage = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: self.managedObjectContext) as! Image
        
        newImage.imgTitle = feedItem.title
        newImage.imgURL = feedItem.imageURL.absoluteString
/* Inverse relationship between tags and images */
/* Associated image & the tag together */
        newImage.tag = tag
        
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("couldn't save context")
        }
    }

    
}