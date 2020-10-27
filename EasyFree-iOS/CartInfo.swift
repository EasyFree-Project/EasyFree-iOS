//
//  CartInfo.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/26.
//

import UIKit

struct CartInfo {
    let name: String
    let price: Int
    let count: Int
    
    var image: UIImage? {
        return UIImage(named: "EasyFree_Logo.png")
    }
    
    init(name: String, price: Int, count: Int) {
        self.name = name
        self.price = price
        self.count = count
    }
}
