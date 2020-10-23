//
//  ItemListViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/22.
//

import UIKit

class ProductViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let viewModel = ProductViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfProductInfoList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        
        let info = viewModel.productInfo(at: indexPath.row)
        cell.updateUI(info)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("상품이 선택되었습니다")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let productSpacing: CGFloat = 10
        let textAreaHeight: CGFloat = 30
        
        let width: CGFloat = (collectionView.bounds.width - productSpacing)/2
        let height: CGFloat = width + textAreaHeight
        return CGSize(width: width, height: height)
    }

}

class ProductViewModel {
    let productInfoList: [ProductInfo] = [
        ProductInfo(name: "item", price: 1000),
        ProductInfo(name: "item", price: 2000),
        ProductInfo(name: "item", price: 3000),
        ProductInfo(name: "item", price: 4000),
        ProductInfo(name: "item", price: 5000),
        ProductInfo(name: "item", price: 6000),
        ProductInfo(name: "item", price: 7000),
        ProductInfo(name: "item", price: 8000),
        ProductInfo(name: "item", price: 9000),
        ProductInfo(name: "item", price: 10000)
    ]
    
    var numOfProductInfoList: Int {
        return productInfoList.count
    }
    
    func productInfo(at index: Int) -> ProductInfo {
        return productInfoList[index]
    }
    
}

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func updateUI(_ productInfo: ProductInfo) {
        imgView.image = productInfo.image
        nameLabel.text = productInfo.name
        priceLabel.text = "\(productInfo.price)"
    }
    
}

