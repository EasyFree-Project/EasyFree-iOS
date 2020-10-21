//
//  SignupViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/21.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    var isUserNameAvailable: Bool = false
    var availableUserName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func checkUserName(_ sender: Any) {
        let testUserName = "노규명"
        
        guard let userName = userNameField.text else {
            return
        }
        
        if (testUserName != userName) && (userName != "") {
            availableUserNameAlert()
            isUserNameAvailable = true
            availableUserName = userName
        } else {
            notAvailableUserNameAlert()
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        guard let userName = userNameField.text else {
            return
        }
        guard let password = passwordField.text else {
            return
        }
        guard let confirmPassword = confirmPasswordField.text else {
            return
        }
        
        if isUserNameAvailable && (userName == availableUserName) {
            if (password == confirmPassword) && (password != "") {
                signupSuccessAlert()
            } else {
                checkPasswordAlert()
            }
        } else {
            checkUserNameAlert()
        }
    }
    
    func availableUserNameAlert() {
        let alert = UIAlertController(title: nil, message: "사용 가능한 아이디입니다", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func notAvailableUserNameAlert() {
        let alert = UIAlertController(title: nil, message: "사용할 수 없는 아이디입니다", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func signupSuccessAlert() {
        let alert = UIAlertController(title: nil, message: "회원가입 완료", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func checkPasswordAlert() {
        let alert = UIAlertController(title: nil, message: "비밀번호를 확인해주세요", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func checkUserNameAlert() {
        let alert = UIAlertController(title: nil, message: "아이디 중복확인을 해주세요", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
