//
//  CartViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/22.
//

import UIKit
import Kingfisher

class CartViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var cartTableVeiw: UITableView!
    
    let viewModel = CartViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        cartTableVeiw.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartTableVeiw.dataSource = self
    }
    
    @IBAction func purchase(_ sender: Any) {
        CartViewModel.cartInfoList.removeAll()
        cartTableVeiw.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfCartInfoList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as? CartCell else {
            return UITableViewCell()
        }
        
        let info = viewModel.cartInfo(at: indexPath.row)
        cell.updateUI(info)
        return cell
    }
}

class CartViewModel {
    static var cartInfoList: [CartInfo] = []
    
    var numOfCartInfoList: Int {
        return CartViewModel.cartInfoList.count
    }
    
    func cartInfo(at index: Int) -> CartInfo {
        return CartViewModel.cartInfoList[index]
    }
}

class CartCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    func updateUI(_ cartInfo: CartInfo) {
        let url = URL(string: cartInfo.imageURL)
        imgView.kf.setImage(with: url)
        nameLabel.text = cartInfo.name
        priceLabel.text = "\(cartInfo.price)원"
        countLabel.text = "\(cartInfo.count)개"
    }
}

struct CartInfo {
    let name: String
    let price: Int
    let count: Int
    let imageURL: String

    init(name: String, price: Int, count: Int, imageURL: String) {
        self.name = name
        self.price = price
        self.count = count
        self.imageURL = imageURL
    }
}
