//
//  LoginViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/21.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        
        guard let userName = userNameField.text else {
            return
        }
        guard let password = passwordField.text else {
            return
        }
        
        let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
        
        let params = [
            "username" : userName,
            "password" : password
        ]

        let request = AF.request("http://54.180.153.44:3003/auth/login", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)

        request.responseJSON { (response: DataResponse) in
            switch(response.result)
            {
            case .success(let value):
                guard let json = value as? [String: Any],
                      let data = json["data"] as? [String: Any],
                      let memberIdx = data["member_idx"] as? Int
                else {
                    self.loginFailAlert()
                    return
                }
                
                UserDefaults.standard.set(memberIdx, forKey: "memberIdx")
                self.moveToMainView()

            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func moveToMainView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }

    func loginFailAlert() {
        let alert = UIAlertController(title: nil, message: "로그인 실패", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
