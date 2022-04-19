//
//  SignUpViewController.swift
//  PeterStreaming
//
//  Created by Class on 2022/3/30.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var SingUp: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //註冊按鈕圓角
        super.viewDidLoad()
        self.SingUp.layer.cornerRadius = 10
        
    }
    
    @IBAction func SignUp(_ sender: Any) {
        if mailField.text == "" {
               let alertController = UIAlertController(title: "Error！", message: "請輸入電子信箱和密碼！", preferredStyle: .alert)
               
               let defaultAction = UIAlertAction(title: "OK！", style: .cancel, handler: nil)
               alertController.addAction(defaultAction)
               
               present(alertController, animated: true, completion: nil)
           
           } else {
               Auth.auth().createUser(withEmail: mailField.text!, password: passwordField.text!) { (user, error) in
                   
                   if error == nil {
                       //print("已經註冊囉！")
                    
                       self.dismiss(animated: true)
                       
                       
                   } else {
                       let alertController = UIAlertController(title: "Error！", message: error?.localizedDescription, preferredStyle: .alert)
                       
                       let defaultAction = UIAlertAction(title: "OK！", style: .cancel, handler: nil)
                       alertController.addAction(defaultAction)
                       
                       self.present(alertController, animated: true, completion: nil)
                   }
               }
           }
    }
}

extension SignUpViewController: UITextFieldDelegate {
//當點擊view任何喔一處鍵盤收起
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
}
