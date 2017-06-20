//
//  TagImageViewController.swift
//  Filterer
//
//  Created by Administrator on 20.06.17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import Foundation
import UIKit

class TagImageViewController: UITableViewController {
    
    var imageFeed: ImageFeed?
    var urlSession: NSURLSession!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: configuration)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.urlSession.invalidateAndCancel()
        self.urlSession = nil
    }

    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageFeed?.items.count ?? 0
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var image = UIImage(named: "sample")
        let imageURL = self.imageFeed?.items[indexPath.row].imageURL
        
        let request = NSURLRequest(URL: imageURL!)
        let dataTask = self.urlSession.dataTaskWithRequest(request) { (data, response, error) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if error == nil && data != nil {
                    image = UIImage(data: data!)!
                    return self.performSegueWithIdentifier("showEditor", sender: image)
                }
            })
        }
        dataTask.resume()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showEditor" {
            let filterVC = segue.destinationViewController as! FilterViewController
            print([sender!.row])
            filterVC.image = sender as? UIImage
        }
    }
    
}