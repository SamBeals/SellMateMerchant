//
//  Item.swift
//  SellMateMerchant
//
//  Created by Sam on 5/26/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
