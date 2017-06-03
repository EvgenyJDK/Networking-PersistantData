//
//  ImageFeedViewController.swift
//  Filterer
//
//  Created by Administrator on 31.05.17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import Foundation
import UIKit

class ImageFeedViewController: UITableViewController {
    
    var imageFeed: ImageFeed? {
        didSet {
            self.tableView.reloadData()
            print("======== \(self.imageFeed?.items.count)")
        }
    }
    
    var urlSession: NSURLSession!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
/* Configuration contains cash settings, description of URL handling*/
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
/* Cancel any outstanding downloads if app closes or you switch app to another story board */
        self.urlSession.invalidateAndCancel()
/* Stop to reuse urlSession */
        self.urlSession = nil
    }
    
    
// MARK : - TableView Datasource Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageFeed?.items.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageFeedItemTableViewCell", forIndexPath: indexPath) as! ImageFeedItemTableViewCell
        
        let item = self.imageFeed!.items[indexPath.row]
        cell.itemTitle.text = item.title
        
        
        let request = NSURLRequest(URL: item.imageURL)
        
        cell.dataTask = self.urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    cell.itemImageView.image = image
                }
            })
        }
        cell.dataTask?.resume()
        return cell
    }
    
/* Cancel image from loading. Avoiding multiple things loading at the same time for cell when it is recycling). */
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? ImageFeedItemTableViewCell {
            cell.dataTask?.cancel()
        }
    }

    
    
}

