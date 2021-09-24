//
//  LikeModels.swift
//  DateAfrica
//
//  Created by Apple on 28/12/2020.
//

import Foundation

extension Like {
    struct UsersLikes {
        let usrid: String
        let usrimg: String
        let usrname: String
        
        init(data: NSDictionary) {
            usrid = data["usrid"] as? String ?? ""
            usrimg = data["usrimg"] as? String ?? ""
            usrname = data["usrname"] as? String ?? ""
        }
    }
    
    struct TopPicks {
        let imgid: String
        let userimages: String
        let offlineonline: String
        let userid: String
        let username: String
        let gender: String
        let aboutuser: String
        let userage: String
        let usrtokn: String
        
        init(data: NSDictionary) {
            imgid = data["imgid"] as? String ?? ""
            userimages = data["userimages"] as? String ?? ""
            offlineonline = data["offlineonline"] as? String ?? ""
            userid = data["userid"] as? String ?? ""
            username = data["username"] as? String ?? ""
            gender = data["gender"] as? String ?? ""
            aboutuser = data["aboutuser"] as? String ?? ""
            userage = data["userage"] as? String ?? ""
            usrtokn = data["usrtokn"] as? String ?? ""
        }
    }
    
    
}
