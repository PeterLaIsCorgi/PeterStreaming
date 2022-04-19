import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class JSViewController: UIViewController {
    
    var rooms = [room]()
    
    struct room {
        var roomname: String
        var roomtitle: String
        var roomhastag: String
        var roomimage: String
        var roomnum: Int
        
    }

    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var Homename: UILabel!
    @IBOutlet weak var Homeemail: UILabel!
    @IBOutlet weak var headphoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        CollectionView.delegate = self
        CollectionView.dataSource = self
        
        //建立解碼器
        let decoder = JSONDecoder()
        // String 轉 Data
        if let streamerData = streamerString.data(using: .utf8){
            do {
                // 開始解碼
                let getCodable = try decoder.decode(testCodable.self, from: streamerData)
                //print(getCodable)
                //把 getCodablegetCodable.result.stream_list 的資料取出並放入array
                for i in 0...getCodable.result.stream_list.count - 1 {
                    //取得nickName
                    let myNickName = getCodable.result.stream_list[i].nickname
                    let mytitle = getCodable.result.stream_list[i].stream_title
                    let myhastag = getCodable.result.stream_list[i].tags
                    let myimage = getCodable.result.stream_list[i].head_photo
                    let myonline = getCodable.result.stream_list[i].online_num
                    
                    let myRoom = room(roomname: myNickName, roomtitle: mytitle, roomhastag: myhastag, roomimage: myimage, roomnum: myonline)
                    //放入rooms
                    rooms.append(myRoom)
                    
                    
                }
            } catch {
                print("解碼錯誤")
            }
        }else{
            print("String 轉 Data 失敗")
        }
        
    }
    
    
    
    @IBAction func homerefresh(_ sender: Any) {
        let user = Auth.auth().currentUser
        if let user = user {
            //獲得email
            let email = user.email
            let emailStr = String(email!)
            Homeemail.text = "帳號 ：\(emailStr)"
        }
        let reference = Firestore.firestore().collection("users")
        reference.document ("emailStr").getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                if let snapshot = snapshot{
                    let snapshotdata = snapshot.data()?["name"]
                    if let  nameStr = snapshotdata as? String {
                        self.Homename.text = "暱稱 ： \(nameStr)"
                        print("\(nameStr)")
                    }
                }
            }
        }
    }
    
}




extension JSViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    //cell數量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }
    
    //cell要顯示的內容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! HomeCollectionViewCell
        
        cell.name.text = rooms[indexPath.row].roomname
        cell.title.text = rooms[indexPath.row].roomtitle
        cell.hastag.text = "#\(rooms[indexPath.row].roomhastag)"
        cell.online.text = String(rooms[indexPath.row].roomnum)
    
        let imgURL = NSURL(string: rooms[indexPath.row].roomimage)
        if let imageData = NSData(contentsOf: imgURL! as URL) {
            cell.imageView.image = UIImage(data: imageData as Data)
        }else{
            cell.imageView.image = UIImage(named: "paopao")
        }
        
        return cell
    }
    
}

extension JSViewController: UITextFieldDelegate {
    //當點擊view任何喔一處鍵盤收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
