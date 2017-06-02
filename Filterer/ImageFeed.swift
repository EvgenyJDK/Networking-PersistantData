//
//  ImageFeed.swift
//  Filterer
//
//  Created by Administrator on 31.05.17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import Foundation



class ImageFeed: NSObject {
    
    let items: [ImageFeedItem]
    let sourceURL: NSURL
    
    init(items newItems: [ImageFeedItem], sourceURL newURL: NSURL) {
        self.items = newItems
        self.sourceURL = newURL
        super.init()
    }
    
}