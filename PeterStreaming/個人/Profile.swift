import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class Profile: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    @IBAction func SendDatabase(_ sender: UIButton) {
        
        let reference = Firestore.firestore()
        if let name = name.text {
            let newdata = ["name":name] as [String : Any]
            reference.collection("users").document ("emailStr").setData (newdata) {(error) in
                if let error = error {
        print(error.localizedDescription)
        }else{
        print ("successfully write in !")
    }

                }
            }
        
           let controller = UIAlertController(title: "已成功變更！", message: "請回到個人頁面點擊更新資訊", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           controller.addAction(okAction)
           present(controller, animated: true, completion: nil)
        
        }
    }

extension Profile: UITextFieldDelegate {
//當點擊view任何喔一處鍵盤收起
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
}
