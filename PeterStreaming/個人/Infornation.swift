//
//  Infornation.swift
//  PeterStreaming
//
//  Created by Class on 2022/3/31.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class Infornation: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameread: UITextField!
    @IBOutlet weak var mailread: UITextField!
    
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
    }
    
    
    //登出
    @IBAction func LogOut(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    

    @IBAction func photoalert(_ sender: Any) {
        //alert
        let alertController = UIAlertController(title: "選擇頭像", message: "請選擇頭像來源", preferredStyle: .actionSheet)
        
        //加入相機
        let photolAction = UIAlertAction(title: "從相機選擇", style: .default) { alertAction in
            //開相機
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }
        alertController.addAction(photolAction)
        
        //加入相簿
        let pictureAction = UIAlertAction(title: "從相簿選擇", style: .default) { alertAction in
            //開相簿
            self.picker.sourceType = .savedPhotosAlbum
            self.picker.allowsEditing = true
            self.present(self.picker, animated: true, completion: nil)
            
        }
        
        alertController.addAction(pictureAction)
        
        //加入取消
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        //呈現
        present(alertController, animated: true, completion: nil)
    }

    
    @IBAction func refresh(_ sender: Any) {
        let user = Auth.auth().currentUser
        if let user = user {
            //獲得email
            let email = user.email
            let emailStr = String(email!)
            mailread.text = "帳號 ：\(emailStr)"
        }
        let reference = Firestore.firestore().collection("users")
        reference.document ("emailStr").getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                if let snapshot = snapshot{
                    let snapshotdata = snapshot.data()?["name"]
                    if let  nameStr = snapshotdata as? String {
                        self.nameread.text = "暱稱 ： \(nameStr)"
                        print("\(nameStr)")
                    }
                }
            }
        }
    }
}



extension Infornation: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let headimage =  info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageView.image = headimage
        
        picker.dismiss(animated: true)
    }
}

extension Infornation: UITextFieldDelegate {
    //當點擊view任何喔一處鍵盤收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
