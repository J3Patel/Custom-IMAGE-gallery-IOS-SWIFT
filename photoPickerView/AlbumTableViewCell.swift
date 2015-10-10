//
//  AlbumTableViewCell.swift
//  photoPickerView
//
//  Created by Tudip on 10/10/15.
//  Copyright © 2015 jatin. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var albumCoeverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func cellHeight()-> CGFloat {
        return 88
    }
    
}
