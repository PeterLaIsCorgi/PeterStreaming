import UIKit

class searchJSViewController: UIViewController {
    
    var fullSize: CGSize!
    
    var searcheditem = [room]()
    var popularroom = [room]()
    
    struct room {
        var roomname: String
        var roomtitle: String
        var roomhastag: String
        var roomimage: String
        var roomnum: Int
        
    }


    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var Search: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullSize = UIScreen.main.bounds.size
        
        Search.delegate = self
        CollectionView.delegate = self
        CollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: fullSize.width, height: 40)
        CollectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "Header")
        
        //建立解碼器
        let decoder = JSONDecoder()
        // String 轉 Data
        if let streamerData = streamerString.data(using: .utf8){
            do {
                // 開始解碼
                let getCodable = try decoder.decode(testCodable.self, from: streamerData)
                
                for i in 0...getCodable.result.lightyear_list.count - 1 {
                    let popularmyname = getCodable.result.lightyear_list[i].nickname
                    let popularmytitle = getCodable.result.lightyear_list[i].stream_title
                    let popularmytag = getCodable.result.lightyear_list[i].tags
                    let popularmyimage = getCodable.result.lightyear_list[i].head_photo
                    let popularmyonline = getCodable.result.lightyear_list[i].online_num
                    let popularmyroom = room(roomname: popularmyname, roomtitle: popularmytitle, roomhastag: popularmytag, roomimage: popularmyimage, roomnum: popularmyonline)

                    popularroom.append(popularmyroom)
                }
            } catch {
                print("解碼錯誤")
            }
        }else{
            print("String 轉 Data 失敗")
        }
    }
}

extension searchJSViewController: UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate{
    
    //cell數量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard searcheditem.count != 0 else {
            return popularroom.count
        }
        if section == 0 {
            return searcheditem.count
        }else if section == 1 {
            return popularroom.count
        }else{
            return 0
        }
    }
    //section數量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        switch searcheditem.count {
        case 0:
            return 1
        default:
            return 2
        }
    }

    //cell要顯示的內容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchimagecell", for: indexPath) as! searchCollectionViewCell
        
        //依照section的不同 顯示不同內容
        if searcheditem.count == 0 {
            cell.searchname.text = popularroom[indexPath.row].roomname
            cell.searchtitle.text = popularroom[indexPath.row].roomtitle
            cell.searchhastag.text = "#\(popularroom[indexPath.row].roomhastag)"
            cell.searchonline.text = String(popularroom[indexPath.row].roomnum)
        
            let imgURL = NSURL(string: popularroom[indexPath.row].roomimage)
            if let imageData = NSData(contentsOf: imgURL! as URL) {
                cell.searchimage.image = UIImage(data: imageData as Data)
            }else{
                cell.searchimage.image = UIImage(named: "paopao")
            }
            
        }else{
            if indexPath.section == 0 {
                
                cell.searchname.text = searcheditem[indexPath.row].roomname
                cell.searchtitle.text = searcheditem[indexPath.row].roomtitle
                cell.searchhastag.text = "#\(searcheditem[indexPath.row].roomhastag)"
                cell.searchonline.text = String(searcheditem[indexPath.row].roomnum)
            
                let imgURL = NSURL(string: searcheditem[indexPath.row].roomimage)
                if let imageData = NSData(contentsOf: imgURL! as URL) {
                    cell.searchimage.image = UIImage(data: imageData as Data)
                }else{
                    cell.searchimage.image = UIImage(named: "paopao")
                }
                return cell
                
            }else if indexPath.section == 1 {
                
                cell.searchname.text = popularroom[indexPath.row].roomname
                cell.searchtitle.text = popularroom[indexPath.row].roomtitle
                cell.searchhastag.text = "#\(popularroom[indexPath.row].roomhastag)"
                cell.searchonline.text = String(popularroom[indexPath.row].roomnum)
            
                let imgURL = NSURL(string: popularroom[indexPath.row].roomimage)
                if let imageData = NSData(contentsOf: imgURL! as URL) {
                    cell.searchimage.image = UIImage(data: imageData as Data)
                }else{
                    cell.searchimage.image = UIImage(named: "paopao")
                }
                return cell
        }
    }
        return cell
}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searcheditem.removeAll()
        }else{
            searcheditem.removeAll()
            for i in 0...popularroom.count - 1 {
                let checkname = popularroom[i].roomname.uppercased().contains(searchText.uppercased())
                
                let checktag = popularroom[i].roomhastag.uppercased().contains(searchText.uppercased())
                
                let checktitle = popularroom[i].roomtitle.uppercased().contains(searchText.uppercased())
                
                if (checkname)||(checktag)||(checktitle) {
                    searcheditem.append(popularroom[i])
                }
            }
        }
        CollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView = UICollectionReusableView()
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: fullSize.width, height: 40))
            label.textAlignment = .center
        
        if kind == UICollectionView.elementKindSectionHeader {
              // header
              reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                  withReuseIdentifier: "Header",
                  for: indexPath)
              
              //header content
              reusableView.backgroundColor = UIColor.darkGray
              label.text = "熱門搜尋"
              label.textColor = UIColor.black
        }
        reusableView.addSubview(label)
        return reusableView
    }
}

extension searchJSViewController: UITextFieldDelegate {
//當點擊view任何喔一處鍵盤收起
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
}
