//
//  WTSTableTableViewCell.swift
//  WaitersApp
//
//  Created by Yuriy Sirko on 2/1/16.
//  Copyright © 2016 ThinkMobiles. All rights reserved.
//

import UIKit

let tableTableViewCellIdentifier = "WTSTableTableViewCell"

class WTSTableTableViewCell: UITableViewCell {

    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        backgroundColor = selected ? UIColor.lightBlueApplicationColor() : UIColor.darkGrayApplicationColor()
    }
    
    // MARK: - Private Methods
    
    private func prepareUI() {
        backgroundColor = UIColor.darkGrayApplicationColor()
    }

}
