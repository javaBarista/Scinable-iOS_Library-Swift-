//
//  PushStorageTableViewController.swift
//  PushLib
//
//  Created by 株式会社シナブル on 2019/10/08.
//  Copyright © 2019 株式会社シナブル. All rights reserved.
//
import UIKit
import Alamofire
import AlamofireObjectMapper

@available(iOS 13.0, *)
class PushStorageTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView!
    var tableItem = Array<TableItem>()
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        table.bounces = true
        table.delegate = self
        table.dataSource = self
        
        getPushStorage()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItem.count
    }
           
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PushMessage") as! MyCustomCell
            
            let item = tableItem[indexPath.row]
            
            cell.title.text = item.getTitle()
            cell.body.text = item.getBody()
            cell.date.text = item.getReceivedDate()
        /*
            if(item.getChkread() == "1"){
                cell.chkread.image = UIImage(named: "checkcirclr.png")
            }
            else{
                cell.chkread.image = UIImage(named: "circle.png")
            }
 */
            if(item.getChkread() == "1"){
                cell.chkread.image = UIImage(systemName: "checkmark.circle.fill")
            }
            else{
                cell.chkread.image = UIImage(systemName: "circle")
            }
            
            
            return cell
    }
       
        //사용자가 선택한 아이템을 다이얼 로그에 표시한다.
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let item = tableItem[indexPath.row]
            
            setUpdateChkRead(pushNum: item.getPushNum())
            let selectCell = table.cellForRow(at: indexPath)as! MyCustomCell
                selectCell.chkread.image = UIImage(systemName: "checkmark.circle.fill")
            //selectCell.chkread.image = UIImage(named: "checkcirclr.png")

            
            let alertController = UIAlertController(title: item.getTitle(), message: item.getBody(), preferredStyle: UIAlertController.Style.alert)
            
         
            let eav = ExtendAlertView()
            eav.setUrl(item.getImgUrl())
            eav.setUserUrl(item.getUserUrl())
            eav.setDate(item.getReceivedDate())
            
            let okAction = UIAlertAction(title: "Ok", style: .destructive){ action in }
            
            alertController.addAction(okAction)
            
            alertController.setValue(eav, forKey: "contentViewController")
            
            present(alertController, animated: false){
                
            }
        }
        
        func getPushStorage() {
            //userid를 매핑하여 해당하는 목록 조회
            Alamofire.request("https://nobles1030.cafe24.com/RequestPushStorage.php", method: .post, parameters: ["userID": "Hiro"]).responseArray { (response: DataResponse<[TableItem]>) in
                if let newPosts = response.result.value{
               
                    self.tableItem = newPosts
                    self.table.reloadData()
                    
                }
                
            }
        }
        
        func setUpdateChkRead(pushNum: String){
            Alamofire.request("https://nobles1030.cafe24.com/UpdateRead.php", method: .post, parameters: ["pushNum": pushNum])
            
        }
    }

@available(iOS 13.0, *)
public class ExtendAlertView : UIViewController{
        
        let imageView = UIImageView()
        let button = UIButton()
        let dateText = UILabel();
        var url = String()
        var userUrl = String()
        var date = String()

        func setUserUrl(_ userUrl: String){
            self.userUrl = userUrl
        }
        
        func setUrl(_ url: String){
            self.url = url
        }
        
        func setDate(_ date: String){
            self.date = date
        }
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            
            if let checkedUrl = URL(string: url){
                      imageView.contentMode = .scaleAspectFit
                      downloadImage(url: checkedUrl)
                  }
            
            imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 120)
            
            button.setTitle(userUrl, for: UIControl.State.normal)
            button.setTitleColor(UIColor.orange, for: UIControl.State.normal)
            button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            
            dateText.text = "received: " + date
            dateText.adjustsFontSizeToFitWidth = true
            dateText.font = UIFont(name: "HelveticaNeue-UItraLight", size: 5)
            
            self.view.addSubview(imageView)
            
            self.button.frame = CGRect(x: 0, y: 130, width: 200, height: 9)
            self.view.addSubview(button)
            
            self.dateText.frame = CGRect(x: 70, y: 155, width: 130, height:20)
            self.view.addSubview(dateText)
            self.preferredContentSize = CGSize(width: 200, height: 180)
            
        }
        
        @available(iOS 13.0, *)
        @IBAction func buttonPressed(sender: UIButton){
            if sender.tag == 0 {
                
                let storyboard:UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
                let uvc = storyboard.instantiateViewController(withIdentifier: "WebViewController")
                
                //sharedpreference를 이용한 url전달
                let spref = UserDefaults.standard
                spref.setValue(userUrl, forKey: "userUrl")
                
                self.present(uvc, animated:true, completion: nil)
            }
            else if sender.tag == 1 {
                
            }
        }
        
        
        //비동기로 URL로 부터 이미지를 읽어 업로드 하는 작업
        func getDataFromUrl(url: URL, completion: @escaping(_ data: Data?,_ response: URLResponse?,_ error: Error?) -> Void) {
              URLSession.shared.dataTask(with: url){
                  (data, response, error) in
                  completion(data, response, error)
              }.resume()
        }
          
        func downloadImage(url: URL){
              getDataFromUrl(url: url) {(data, response, error) in
                  guard let data = data, error == nil else { return }
                  DispatchQueue.main.async(){() -> Void in
                    self.imageView.image = UIImage(data: data)
        
                  }
                  
              }
        }
        
    }
