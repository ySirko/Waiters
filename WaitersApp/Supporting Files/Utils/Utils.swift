//
//  Utils.swift
//  WaitersApp
//
//  Created by Yuriy Sirko on 2/3/16.
//  Copyright © 2016 ThinkMobiles. All rights reserved.
//

import UIKit
import Foundation

class Utils {
    
    class func showAlertWithMessage(message: String) {
        let alertView = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "ok")
        alertView.show()
    }
    
}
