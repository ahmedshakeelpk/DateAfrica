//
//  PackagePlanModel.swift
//  DateAfrica
//
//  Created by Apple on 23/12/2020.
//

import Foundation

extension PackagePlan {
    
    struct Packages {
        var id: String
        var packgetype: String
        var pckgeduration: String
        var pckgeprice: String
        
        init(data: NSDictionary) {
            id = ""
            if ((data["id"] as? String) != nil) {
                id = data["id"] as? String ?? ""
            }
            else if ((data["id"] as? Int) != nil) {
                id = String((data["id"] as? Int)!)
            }
            packgetype = data["packgetype"] as? String ?? ""
            pckgeduration = data["pckgeduration"] as? String ?? ""
            pckgeprice = data["pckgeprice"] as? String ?? ""
        }
    }
    
    struct PackageCurrent {
        var id: String
        var enddate: String
        var startdate: String
        var packgetype: String
        var pckgeduration: String
        var pckgeprice: String
        
        init(data: NSDictionary) {
            id = ""
            if ((data["id"] as? String) != nil) {
                id = data["id"] as? String ?? ""
            }
            else if ((data["id"] as? Int) != nil) {
                id = String((data["id"] as? Int)!)
            }
            enddate = data["enddate"] as? String ?? ""
            startdate = data["startdate"] as? String ?? ""
            packgetype = data["packgetype"] as? String ?? ""
            pckgeduration = data["pckgeduration"] as? String ?? ""
            pckgeprice = data["pckgeprice"] as? String ?? ""
        }
    }
}
