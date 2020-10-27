//
//  ItemListViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/22.
//

import UIKit

class ProductViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let viewModel = ProductViewModel()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailProductViewController
            if let index = sender as? Int {
                let productInfo = viewModel.productInfo(at: index)
                vc?.viewModel.update(model: productInfo)
            }
        }
    }

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
        performSegue(withIdentifier: "showDetail", sender: indexPath.item)
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
        ProductInfo(name: "item1", price: 1000),
        ProductInfo(name: "item2", price: 2000),
        ProductInfo(name: "item3", price: 3000),
        ProductInfo(name: "item4", price: 4000),
        ProductInfo(name: "item5", price: 5000),
        ProductInfo(name: "item6", price: 6000),
        ProductInfo(name: "item7", price: 7000),
        ProductInfo(name: "item8", price: 8000),
        ProductInfo(name: "item9", price: 9000),
        ProductInfo(name: "item10", price: 10000)
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

