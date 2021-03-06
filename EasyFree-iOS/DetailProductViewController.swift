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
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var nutrientLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
            let name = productInfo.productName
            let price = productInfo.productPrice
            let count = Int(valueLabel.text!)
            let imageURL = productInfo.imageURL
            
            let newProduct = CartInfo(name: name, price: price, count: count!, imageURL: imageURL)
            CartViewModel.cartInfoList.append(newProduct)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateUI() {
        if let productInfo = viewModel.productInfo {
            let url = URL(string: productInfo.imageURL)
            imgView.kf.setImage(with: url)
            nameLabel.text = productInfo.productName
            priceLabel.text = "\(productInfo.productPrice) 원"
            contentLabel.text = productInfo.productContent
            producerLabel.text = "원산지: \(productInfo.producerLocation)"
            capacityLabel.text = "용량: \(productInfo.capacitySize)"
            nutrientLabel.text = "영양성분: \(productInfo.nutrient)"
        }
    }
}

class DetailProductViewModel {
    var productInfo: ProductInfo?
    
    func update(model: ProductInfo?) {
        productInfo = model
    }
}
