//
//  EditProfileModel.swift
//  DateAfrica
//
//  Created by Apple on 31/12/2020.
//

import Foundation

extension EditProfile {

    struct UserPicturesModel {
        let imagename: String
        let imgid: String
        
        init(data: NSDictionary) {
            imagename = data["imagename"] as? String ?? ""
            imgid = data["imgid"] as? String ?? ""
        }
    }

}
