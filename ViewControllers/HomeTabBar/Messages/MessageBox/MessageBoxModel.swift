//
//  MessageBoxModel.swift
//  DateAfrica
//
//  Created by Apple on 07/01/2021.
//

import Foundation

extension MessageBox {
    struct UserChat {
        var dateandtime = ""
        var from = ""
        var isseen = false
        var msg = ""
        var to = ""
        
        init(data: NSDictionary) {
            dateandtime = data["dateandtime"] as? String ?? ""
            from = String(data["from"] as? Int ?? 0)
            isseen = data["isseen"] as? Bool ?? false
            msg = data["msg"] as? String ?? ""
            to = data["to"] as? String ?? ""
            
            if from == "0" {
                from = String(data["from"] as? String ?? "")
            }
            if to == "" {
                to = String(data["to"] as? Int ?? 0)
            }
        }
    }
}
