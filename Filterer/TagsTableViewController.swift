//
//  TagsTableViewController.swift
//  Filterer
//
//  Created by Administrator on 05.06.17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TagsTableViewController: UITableViewController {
    
    
    var fetchedResultsController: NSFetchedResultsController!
    
    
    override func viewWillAppear(animated: Bool) {
        do {
            /* To make sure that it actually gets objects - used performFetch() */
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("tags fetch failed")
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tagCell", forIndexPath: indexPath)
        let tag = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Tag
        cell.textLabel?.text = tag.tagTitle

        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showImages" {
            let indexPath = self.tableView.indexPathForSelectedRow!
            let destination = segue.destinationViewController as! TagImageViewController
            
            let tag = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Tag
            if let images = tag.images?.allObjects as? [Image] {
                var feedItems = [ImageFeedItem]()
                for image in images {
                    let imageURL = NSURL(string: image.imgURL ?? "") ?? NSURL()
                    let newFeedItem = ImageFeedItem(title: image.imgTitle ?? "(no title)" , imageURL: imageURL)
                    feedItems.append(newFeedItem)
                }
                let feed = ImageFeed(items: feedItems, sourceURL: NSURL())
                destination.imageFeed = feed
            }
        }
    }
    
}