//
//  ItemListViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/22.
//

import UIKit
import Alamofire
import Kingfisher
import Foundation

class ProductViewController: UIViewController {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var productInfoList: [ProductInfo] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailProductViewController
            if let index = sender as? Int {
                let productInfo = productInfoList[index]
                vc?.viewModel.update(model: productInfo)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProduct()
        self.productCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateProduct() {
        let categotyNumber = UserDefaults.standard.value(forKey: "categoryNumber")
        
        SearchProductList.search(categoryNumber: categotyNumber as! Int) { products in
            DispatchQueue.main.async {
                self.productInfoList = products
                self.productCollectionView.reloadData()
            }
        }
    }
}

extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productInfoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        
        let product = productInfoList[indexPath.item]
        let url = URL(string: product.imageURL)
        cell.imgView.kf.setImage(with: url)
        cell.nameLabel.text = product.productName
        cell.priceLabel.text = "\(product.productPrice)원"
        return cell
    }
}

extension ProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetail", sender: indexPath.item)
    }
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let productSpacing: CGFloat = 10
        let textAreaHeight: CGFloat = 30

        let width: CGFloat = (collectionView.bounds.width - productSpacing)/2
        let height: CGFloat = width + textAreaHeight
        return CGSize(width: width, height: height)
    }
}

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}

class SearchProductList {
    static func search(categoryNumber: Int, completion: @escaping ([ProductInfo]) -> Void) {
        
        let session = URLSession(configuration: .default)
        let urlComponents = URLComponents(string: "http://220.87.55.135:3003/product/\(categoryNumber)")!
        
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200..<300
            guard error == nil,
                let statusCode = (response as? HTTPURLResponse)?.statusCode,
                successRange.contains(statusCode) else {
                    completion([])
                    return
            }
            
            guard let resultData = data else {
                completion([])
                return
            }
            
            let products = SearchProductList.parseProducts(resultData)
            completion(products)
        }
        dataTask.resume()
    }
    
    static func parseProducts(_ data: Data) -> [ProductInfo] {
        let decoder = JSONDecoder()

        do {
            let response = try decoder.decode(Response.self, from: data)
            let allItems = response.datas
            let products = allItems.items
            return products
        } catch let error {
            print("--> parsing error: \(error.localizedDescription)")
            return []
        }
    }
}

struct Response: Codable {
    let datas: AllItems
    
    enum CodingKeys: String, CodingKey {
        case datas = "data"
    }
}

struct AllItems: Codable {
    let items: [ProductInfo]
    
    enum CodingKeys: String, CodingKey {
        case items = "item"
    }
}

struct ProductInfo: Codable {
    let productNumber: String
    let productName: String
    let productContent: String
    let producerLocation: String
    let capacitySize: String
    let nutrient: String
    let productPrice: Int
    let averageReview: String
    let reviewCount: Int
    let imageURL: String
    let categoryNumber: String

    enum CodingKeys: String, CodingKey {
        case productNumber = "product_number"
        case productName = "product_name"
        case productContent = "product_content"
        case producerLocation = "producer_location"
        case capacitySize = "capacity_size"
        case nutrient = "nutrient"
        case productPrice = "product_price"
        case averageReview = "avg_review"
        case reviewCount = "review_count"
        case imageURL = "url"
        case categoryNumber = "category_number"
    }
}

