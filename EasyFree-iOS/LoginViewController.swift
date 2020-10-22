//
//  LoginViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/21.
//

import UIKit

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
        
        if isValidUserName(userName: userName) && isValidPassword(password: password) {
            moveToMainView()
        } else {
            loginFailAlert()
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
    
    func isValidUserName(userName: String) -> Bool {
        let testUserName = "o"
        
        if userName == testUserName {
            return true
        } else {
            return false
        }
    }
    
    func isValidPassword(password: String) -> Bool {
        let testPassword = "o"
        
        if password == testPassword {
            return true
        } else {
            return false
        }
    }
    
}
