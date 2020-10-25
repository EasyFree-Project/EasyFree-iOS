//
//  DetailProductViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/24.
//

import UIKit

class DetailProductViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    let viewModel = DetailProductViewModel()

    override func viewDidLoad() {
        updateUI()
        super.viewDidLoad()
    }
    
    func updateUI() {
        if let productInfo = viewModel.productInfo {
            imgView.image = productInfo.image
            nameLabel.text = productInfo.name
            priceLabel.text = "\(productInfo.price)"
        }
    }
}

class DetailProductViewModel {
    var productInfo: ProductInfo?
    
    func update(model: ProductInfo?) {
        productInfo = model
    }
}
