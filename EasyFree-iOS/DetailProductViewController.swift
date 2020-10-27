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
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    let viewModel = DetailProductViewModel()

    override func viewDidLoad() {
        updateUI()
        stepper.wraps = false
        stepper.autorepeat = false
        stepper.maximumValue = 99
        super.viewDidLoad()
    }

    @IBAction func changeValue(_ sender: UIStepper) {
        valueLabel.text = Int(sender.value).description
    }
    
    @IBAction func addToCart(_ sender: Any) {
        if let productInfo = viewModel.productInfo {
            let name = productInfo.name
            let price = productInfo.price
            let count = Int(valueLabel.text!)
            
            let newProduct = CartInfo(name: name, price: price, count: count!)
            CartViewModel.cartInfoList.append(newProduct)
        }
        
        self.navigationController?.popViewController(animated: true)
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
