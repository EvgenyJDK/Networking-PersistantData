//
//  AppDelegate.swift
//  Filterer
//
//  Created by Administrator on 19.03.17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
       
       NSUserDefaults.standardUserDefaults().registerDefaults(["PhotoFeedURLString": "https://api.flickr.com/services/feeds/photos_public.gne?tags=kitten&format=json&nojsoncallback=1"])
      
        return true
    }

    
    func applicationDidBecomeActive(application: UIApplication) {
        
        let urlString = NSUserDefaults.standardUserDefaults().stringForKey("PhotoFeedURLString")
        print(urlString)
        
        guard let foundURLString = urlString else {
            return
        }
        
        if let url = NSURL(string: foundURLString) {
            self.loadOrUpdateImageFeed(url, completion: { (feed) -> Void in

//                let viewController = application.windows[0].rootViewController as? ImageFeedViewController
/* Instead of getting the root controller, getting the VC from the root controller - we are getting navController + VC from navController */
                let navController = application.windows[0].rootViewController as? UINavigationController
                let viewController = navController?.viewControllers[0] as? ImageFeedViewController

                viewController?.imageFeed = feed
            })
        }
    }

    
    
    func updateImageFeed(url: NSURL, completion: (feed: ImageFeed?) -> Void) {
        
//        let dataFile = NSBundle.mainBundle().URLForResource("photos_public.gne", withExtension: ".html")!
//        let data = NSData(contentsOfURL: dataFile)!
//        let imageFeed = ImageFeed(data: data, sourceURL: url)
//        completion(feed: imageFeed)
        
        let request = NSURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil && data != nil {
/* ImageFeed convinience init */
                let imageFeed = ImageFeed(data: data!, sourceURL: url)
/*Save ImageFeed calling method*/
                if let goodFeed = imageFeed {
                    if self.saveImageFeed(goodFeed) {
                        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "lastUpdate")
                    }
                }
                print("loaded Remote Feed!")
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completion(feed: imageFeed)
                })
            }
        }
        task.resume()
    }

  
    
/* LOAD REMOTELY OR LOCALLY */
    func loadOrUpdateImageFeed(url: NSURL, completion: (feed: ImageFeed?) -> Void) {
        
        let lastUpdateSetting = NSUserDefaults.standardUserDefaults().objectForKey("lastUpdate") as? NSDate
        
        var shouldUpdate = true
        if let lastUpdate = lastUpdateSetting where NSDate().timeIntervalSinceDate(lastUpdate) < 20 {
            shouldUpdate = false
        }
        if shouldUpdate {
/* update from remote */
            self.updateImageFeed(url, completion: completion)
        } else {
/* loading local */
            self.readImageFeed{ (feed) -> Void in
                if let foundSavedFeed = feed where foundSavedFeed.sourceURL.absoluteString == url.absoluteString {
                    print("loaded saved feed!")
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        () -> Void in
                        completion(feed:  foundSavedFeed)
                    })
                } else {
                    self.updateImageFeed(url, completion: completion)
                }
            }
        }
    }

    
    
    
    
    
    
// MARK : NSKeyArchived methods to save and load objects
/* These method have to be implemented in SEPARATE THREAD */
    
    func feedFilePath() -> String {
        
/* NSFileManager to save file in current path */
/* DefaultManager - singletone object */
        let paths = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
/* When getting URLs back - we get an array, so we're just going to take the 1st item out of the array and append a file back */
        let filePath = paths[0].URLByAppendingPathComponent("feedFile.plist")
        return filePath.path!
    }
    
    
/* It is possible to save thousnads of objects */
    func saveImageFeed(feed: ImageFeed) -> Bool {
/* ArchiveRootObject have to be complies with NSCoding Protocol */
        let success = NSKeyedArchiver.archiveRootObject(feed, toFile: feedFilePath())
        assert(success, "failed to write archive")
        return success
    }
    
    
    func readImageFeed(completion: (feed: ImageFeed?) -> Void) {
        let path = feedFilePath()
        let unarchiveObject = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        completion(feed: unarchiveObject as? ImageFeed)
    }

    
    
    
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }


    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}



