//
//  Table.swift
//  WaitersApp
//
//  Created by Yuriy Sirko on 2/2/16.
//  Copyright © 2016 ThinkMobiles. All rights reserved.
//

import Foundation

class Table {
    
    var tableNumber: Int
    var ordersNumber: Int
    var orders: [Order]
    
    // MARK: - Initialization
    
    init(tableNumber: Int, ordersNumber: Int, orders: [Order]) {
        self.tableNumber = tableNumber
        self.ordersNumber = ordersNumber
        self.orders = orders
    }
}