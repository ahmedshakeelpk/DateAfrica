//
//  AppSettingModel.swift
//  DateAfrica
//
//  Created by Apple on 24/12/2020.
//

import Foundation

extension AppSetting {
    struct AppSettingModel {
        var readreceipt: String
        var showprofile: String
        var swipesurge: String
        var recentactive: String
        var emailStatus: String
        var phone: String
        var radius: String
        var agerangeto: String
        var agerangefrom: String
        var chat_email: String
        var email: String
        
        
        init(data: NSDictionary) {
            readreceipt = data["readreceipt"] as? String ?? ""
            showprofile = data["showprofile"] as? String ?? ""
            swipesurge = data["swipesurge"] as? String ?? ""
            recentactive = data["recentactive"] as? String ?? ""
            emailStatus = data["emailStatus"] as? String ?? ""
            phone = data["phone"] as? String ?? ""
            radius = data["radius"] as? String ?? ""
            agerangeto = data["agerangeto"] as? String ?? ""
            agerangefrom = data["agerangefrom"] as? String ?? ""
            chat_email = data["chat_email"] as? String ?? ""
            email = data["email"] as? String ?? ""
        }
    }
}
