//
//  WTSOrderCollectionViewCell.swift
//  WaitersApp
//
//  Created by Yuriy Sirko on 2/1/16.
//  Copyright © 2016 ThinkMobiles. All rights reserved.
//

import UIKit

let orderCollectionViewCellIdentifier = "WTSOrderCollectionViewCell"

class WTSOrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderCounterLabel: UILabel!
    
    // MARK: -
    override var selected: Bool {
        didSet {
            backgroundColor = selected ? UIColor.lightBlueApplicationColor() : UIColor.whiteColor()
        }
    }
}
