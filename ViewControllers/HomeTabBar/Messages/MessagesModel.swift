//
//  MessagesModel.swift
//  DateAfrica
//
//  Created by Apple on 23/12/2020.
//

import Foundation
extension Messages {
    struct ChatUsers {
        var offline_online : String
        var usrid : String
        var usrimg : String
        var usrname : String
        var usrtokn : String

        init(data: NSDictionary) {
            offline_online  = data["offline_online"] as? String ?? ""
            usrid  = data["usrid"] as? String ?? ""
            usrimg  = data["usrimg"] as? String ?? ""
            usrname  = data["usrname"] as? String ?? ""
            usrtokn  = data["usrtokn"] as? String ?? ""
        }
    }
    
    struct MatchUsersRecord {
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

