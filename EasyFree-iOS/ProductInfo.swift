//
//  ProductInfo.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/23.
//

import UIKit

struct ProductInfo {
    let name: String
    let price: Int
    
    var image: UIImage? {
        return UIImage(named: "EasyFree_Logo.png")
    }
    
    init(name: String, price: Int) {
        self.name = name
        self.price = price
    }
}
