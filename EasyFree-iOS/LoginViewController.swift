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
            loginSuccessAlert()
        } else {
            loginFailAlert()
        }
    }
    
    func loginSuccessAlert() {
        let alert = UIAlertController(title: nil, message: "로그인 성공", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loginFailAlert() {
        let alert = UIAlertController(title: nil, message: "로그인 실패", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func isValidUserName(userName: String) -> Bool {
        let testUserName = "노규명"
        
        if userName == testUserName {
            return true
        } else {
            return false
        }
    }
    
    func isValidPassword(password: String) -> Bool {
        let testPassword = "12345"
        
        if password == testPassword {
            return true
        } else {
            return false
        }
    }
    
}
