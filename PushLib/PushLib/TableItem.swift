//
//  TableItem.swift
//  PushLib
//
//  Created by 株式会社シナブル on 2019/10/18.
//  Copyright © 2019 株式会社シナブル. All rights reserved.
//

import Foundation
import ObjectMapper

class TableItem: Mappable{
    
    var pushNum: String = ""
    var imgUrl: String = ""
    var title: String = ""
    var body: String = ""
    var receivedDate: String = ""
    var chkread: String = ""
    var userUrl: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        pushNum <- map["pushNum"]
        imgUrl <- map["imgUrl"]
        title <- map["title"]
        body <- map["body"]
        receivedDate <- map["receivedDate"]
        chkread <- map["chkread"]
        userUrl <- map["userUrl"]
    }
    
    func getPushNum() -> String {
        return pushNum
    }
    
    func getImgUrl() -> String {
        return imgUrl
    }
    
    func getTitle() -> String{
        return title
    }
    
    func getBody() -> String{
        return body
    }

    func getReceivedDate() -> String{
        return receivedDate
    }
    
    func getChkread() -> String {
        return chkread
    }

    func getUserUrl() -> String {
        return userUrl
    }
}
