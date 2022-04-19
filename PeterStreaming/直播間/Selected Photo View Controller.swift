
import UIKit
import AVKit

class Selected_Photo_View_Controller: UIViewController,URLSessionWebSocketDelegate {
    
    
    private var webSocket: URLSessionWebSocketTask?
    var looper: AVPlayerLooper?
    var movieController:AVPlayerViewController?
    
    var chatArray = [String]()
    var chatText = [String]()
    var IDname = "訪客"
    
    @IBOutlet weak var chat: UITextField!
    @IBOutlet weak var tabview: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        let url = URL(string: "wss://client-dev.lottcube.asia/ws/chat/chat:app_test?nickname=peter")
        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
        
        tabview.transform = CGAffineTransform(rotationAngle: .pi)
        tabview.delegate = self
        tabview.dataSource = self
        
    }
    

    
    
    func ping() {
        webSocket?.sendPing { error in
            if let error = error {
                print("Ping error: \(error)")
            }
        }
    }
    
    func close() {
        webSocket?.cancel(with: .goingAway, reason: "Demo ended".data(using: .utf8))
    }
    
//    func send() {
//        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
//            self.send()
//            self.webSocket?.send(.string("Send new message:")) { error in
//                if let error = error {
//                    print("Send error: \(error)")
//                }
//            }
//        }
//    }
    
    func receive() {
        webSocket?.receive{ reslt in
            switch reslt {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got Data: \(data)")
                case .string(let message):
                    print("Got String: \(message)")
                        
                    //建立解碼器
                    let decoder = JSONDecoder()
                    //JSON字串轉Data
                    if let chatData = message.data(using: .utf8) {
                        do {
                            //解析JSON字串
                            let getCodable = try decoder.decode(SendElement.self, from: chatData)
                            
                            guard let myEvent = getCodable.event else{
                                print("event為nil")
                                return
                            }
                            //無效的訊息
                            if myEvent == "undefined"{
                            }
                            //一般發話
                            if myEvent == "default_message" {
                                let myNickName = getCodable.body?.nickname
                                let myText = getCodable.body?.text
                                guard
                                    myNickName != nil,
                                    myText != nil
                                else{
                                    print("default_message中拿到nil值")
                                    return
                                }
                                let newString = "\(myNickName!):\(myText!)"
                                self.chatArray.append(newString)

                                DispatchQueue.main.async {
                                    self.tabview.reloadData()
                                }
                            }else
                            //進出更新通知
                            if myEvent == "sys_updateRoomStatus" {
                                guard
                                    let myUsername = getCodable.body?.entry_notice?.username,
                                    let myEnter = getCodable.body?.entry_notice?.action,
                                    let myLeave = getCodable.body?.entry_notice?.action
                                else {
                                    print("sys_updateRoomStatus中有nil")
                                    return
                                    
                                }
                                let newUpade = "\(myUsername):\(myEnter)"
                                
                                self.chatArray.append(newUpade)
//                                print("charArray的數量：\(self.chatArray.count)")
                                DispatchQueue.main.async {
                                    self.tabview.reloadData()
                                }
                            }else
                            //系統廣播
                            if myEvent == "admin_all_broadcast" {
                                guard
                                let mySender = getCodable.sender_role,
                                let myContent = getCodable.body?.content?.tw
                                else {
                                    print("admin_all_broadcast中有nil")
                                    return
                                }
                                let newBroadcast = "\(mySender):\(myContent)"
                                self.chatArray.append(newBroadcast)
//                                print("charArray的數量：\(self.chatArray.count)")
                                DispatchQueue.main.async {
                                    self.tabview.reloadData()
                                }
                            }
                        }catch{
                            print("解析json時發生錯誤：\(error.localizedDescription)")
                        }
                    }else{print("轉碼失敗")}
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Receive error: \(error)")
            }
            
            self.receive()
        }
    }
    
    @IBAction func sendButton(_ sender: Any) {
        var sendTextButton = chat.text ?? ""
        sendServer(str: sendTextButton)
//        if sendTextButton.trimmingCharacters(in: .whitespaces) == "" {
//            print("empty")
//        }
//        else{
//            chatArray.append(sendTextButton)
//            chatText.append(IDname)
//            chat.text = nil
//            self.tabview.reloadData()
//            print(chatText)
//        }
    }
    
    func sendMessage(_ wSsendText:String) {
        let message = URLSessionWebSocketTask.Message.string("{\"action\":\"N\",\"countent\":\"\(wSsendText)\"}")
        self.webSocket?.send(message) { error in
            if let error = error {
                print(error)
            }
    }
    }
    
    func sendServer(str:String){
        var sendJSONCable: sendCable
        sendJSONCable = sendCable(action: "N", content: str)
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(sendJSONCable)
            let webMessage = URLSessionWebSocketTask.Message.data(jsonData)
            webSocket?.send(webMessage, completionHandler: { err in
                guard err == nil else{
                    print("傳送時發生錯誤")
                    return
                }
                print("送出成功")
            })
        } catch {
            print("編碼時發生錯誤:\(error.localizedDescription)")
        }
        
        
        
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Did connect to socket")
//        ping()
        receive()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Did close connection with reason")
    }
    
    //影片播放
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        setupView()
        setUpVideo()
    }
    func setUpVideo() {
        
        let bundlePath = Bundle.main.path(forResource: "hime3", ofType: "mp4")
        
        let  movieurl = URL(fileURLWithPath: bundlePath!)
        
        let item = AVPlayerItem(url: movieurl)
        let videoPlayer = AVQueuePlayer()
        var videoPlayerLayer:AVPlayerLayer?
        
        looper = AVPlayerLooper(player: videoPlayer, templateItem: item)
        
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        videoPlayer.play()
        
    }
    
    
    @IBAction func leave(_ sender: Any) {
        // 創造一個 UIAlertController
        let alertController = UIAlertController(title: nil, message: "\n\n\n確定離開此聊天室？", preferredStyle: .alert)
        //imageview to alert
        let imgViewTitle = UIImageView(frame: CGRect(x: 100, y: 10, width: 60, height: 60))
        imgViewTitle.image = UIImage(named:"brokenHeart")
        alertController.view.addSubview(imgViewTitle)
        // 加入取消的動作。
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alertController.addAction(cancelAction)
        // 加入確定的動作。
        let yesAction = UIAlertAction(title: "確定", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        alertController.addAction(yesAction)
        // 呈現 alertController。
        present(alertController, animated: true)
    }
    
}

extension Selected_Photo_View_Controller: UITextFieldDelegate {
    //當點擊view任何喔一處鍵盤收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension Selected_Photo_View_Controller: UITableViewDelegate, UITableViewDataSource {
    
    struct sendCable:Codable {
        var action:String
        var content:String
    }
    
    //cell數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    //cell要顯示的內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabview.dequeueReusableCell(withIdentifier: "tabeViewCell") as! TableViewCell
        //轉cell
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        //變更array的順序
        let newIndexPathRow = chatArray.count - 1 - indexPath.row
        let myText = "\(chatArray[newIndexPathRow])"
        print("myText為\(myText)")
        cell.showtext.text = myText
        return cell
    }
}
