//
//  SignupViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/21.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if (password == confirmPassword) && (password != "") {
            let headers: HTTPHeaders = [
                    "Content-Type": "application/json"
                ]
            
            let params = [
                "username" : userName,
                "password" : password
            ]

            let request = AF.request("http://54.180.153.44:3003/auth/register", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)

            request.responseJSON { (response: DataResponse) in
                switch(response.result)
                {
                case .success(let value):
                    guard let json = value as? [String: Any],
                          let _ = json["data"] as? [String: Any]
                    else {
                        self.notAvailableUserNameAlert()
                        return
                    }
                    self.signupSuccessAlert()
                    
                case .failure(let error):
                    print(error)
                    break
                }
            }
        } else {
            checkPasswordAlert()
        }
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
}
