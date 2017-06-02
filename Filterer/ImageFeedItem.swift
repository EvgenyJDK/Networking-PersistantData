//
//  ImageFeedItem.swift
//  Filterer
//
//  Created by Administrator on 31.05.17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import Foundation

class ImageFeedItem: NSObject {
    
    let title: String
    let imageURL: NSURL

    init(title: String, imageURL: NSURL) {
        self.title = title
        self.imageURL = imageURL
        super.init()
    }
    
    
    
    
}