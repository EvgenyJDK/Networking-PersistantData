//
//  ImageFeedItem.swift
//  Filterer
//
//  Created by Administrator on 31.05.17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import Foundation

class ImageFeedItem: NSObject, NSCoding {
    
    let title: String
    let imageURL: NSURL

    init(title: String, imageURL: NSURL) {
        self.title = title
        self.imageURL = imageURL
    }

    
// MARK : Methods complying with NSCoding
    
/* Encode itself with all properties */
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "itemTitle")
        aCoder.encodeObject(self.imageURL, forKey: "itemURL")
    }
    
/* Decode ImageFeedItem from file */
    required convenience init?(coder aDecoder: NSCoder) {
        let storedItemTitle = aDecoder.decodeObjectForKey("itemTitle") as? String
        let storedImageURL = aDecoder.decodeObjectForKey("itemURL") as? NSURL
        
        guard storedItemTitle != nil && storedImageURL != nil else {
            return nil
        }
        self.init(title: storedItemTitle!, imageURL: storedImageURL!)
    }

    
    
    
    
}