//
//  HomeModel.swift
//  DateAfrica
//
//  Created by Apple on 24/12/2020.
//

import Foundation

extension Home {
    struct UsersRecord {
        var aboutuser: String
        var gender: String
        var imgid: String
        var offlineonline: String
        var recAct: String
        var userage: String
        var userid: String
        var userimages: String
        var username: String
        var usrtokn: String
        
        init(data: NSDictionary) {
            aboutuser = data["aboutuser"] as? String ?? ""
            gender = data["gender"] as? String ?? ""
            imgid = data["imgid"] as? String ?? ""
            offlineonline = data["offlineonline"] as? String ?? ""
            recAct = data["recAct"] as? String ?? ""
            userage = data["userage"] as? String ?? ""
            userid = data["userid"] as? String ?? ""
            userimages = data["userimages"] as? String ?? ""
            username = data["username"] as? String ?? ""
            usrtokn = data["usrtokn"] as? String ?? ""
        }
    }
    
}
