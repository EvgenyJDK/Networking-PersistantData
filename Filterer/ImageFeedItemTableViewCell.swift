//
//  ImageFeedItemTableViewCell.swift
//  Filterer
//
//  Created by Administrator on 02.06.17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import Foundation
import UIKit

class ImageFeedItemTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    
    weak var dataTask: NSURLSessionDataTask?
    
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        // Initialization code
    }

    
    
}