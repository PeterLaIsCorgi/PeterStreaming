//
//  LoginViewController.swift
//  PeterStreaming
//
//  Created by Class on 2022/3/30.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var Login: UIButton!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //檢查是否已經登入
        Auth.auth().addStateDidChangeListener { (auth, user) in
                if user != nil {
                    self.performSegue(withIdentifier: "LoginToRestaurant", sender: nil)
                }
            }
        //登入按鈕圓角
        super.viewDidLoad()
        self.Login.layer.cornerRadius = 10
     
    }

    
    @IBAction func Login(_ sender: Any) {
        if self.mailField.text == "" || self.passwordField.text == "" {
                
                // 提示用戶是不是忘記輸入 textfield ？
                
                let alertController = UIAlertController(title: "Error", message: "請輸入電子信箱和密碼！.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            
            } else {
                
                Auth.auth().signIn(withEmail: self.mailField.text!, password: self.passwordField.text!) { (user, error) in
                    
                    if error == nil {
                        
                        // 登入成功，打印 ("You have successfully logged in")
                        
                        //Go to the HomeViewController if the login is sucessful
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                        self.present(vc!, animated: true, completion: nil)
                        
                    } else {
                        
                        // 提示用戶從 firebase 返回了一個錯誤。
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
//當點擊view任何喔一處鍵盤收起
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
}
