//
//  UserProfileModel.swift
//  DateAfrica
//
//  Created by Apple on 29/12/2020.
//

import Foundation
import UIKit

extension UserProfile {

    struct UserPicturesModel {
        let imagename: String
        let imgid: String
        
        init(data: NSDictionary) {
            imagename = data["imagename"] as? String ?? ""
            imgid = data["imgid"] as? String ?? ""
        }
    }
    struct UserProfileModel {
        let aboutuser: String
        let agerangefrom: String
        let agerangeto: String
        let company: String
        let educationlevel: String
        let emailaddress: String
        let gender: String
        let interestedbodytype: String
        let interestedchildern: String
        let interestedethnicity: String
        let interestedeyecolor: String
        let interestedhaircolor: String
        let interestedindrink: String
        let interestedinexercise: String
        let interestedingrugs: String
        let interestedinlogestrelationship: String
        let interestedinpets: String
        let interestedinpolitics: String
        let interestedinsmoking: String
        let interestedlanguage: String
        let interestedmatritalstatus: String
        let interestedpersonalitytype: String
        let interestedreligion: String
        let interestedsexuality: String
        let interestedstarsign: String
        let intertestedgender: String
        let jobtitle: String
        let livingin: String
        let lookingfor: String
        let phoneno: String
        let school: String
        let userage: String
        let userheight: String
        let userid: String
        let username: String
        let userpasword: String
        let userstatus: String
        
        init(data: NSDictionary) {
            
            aboutuser = data["aboutuser"] as? String ?? ""
            agerangefrom = data["agerangefrom"] as? String ?? ""
            agerangeto = data["agerangeto"] as? String ?? ""
            company = data["company"] as? String ?? ""
            educationlevel = data["educationlevel"] as? String ?? ""
            emailaddress = data["emailaddress"] as? String ?? ""
            gender = data["gender"] as? String ?? ""
            interestedbodytype = data["interestedbodytype"] as? String ?? ""
            interestedchildern = data["interestedchildern"] as? String ?? ""
            interestedethnicity = data["interestedethnicity"] as? String ?? ""
            interestedeyecolor = data["interestedeyecolor"] as? String ?? ""
            interestedhaircolor = data["interestedhaircolor"] as? String ?? ""
            interestedindrink = data["interestedindrink"] as? String ?? ""
            interestedinexercise = data["interestedinexercise"] as? String ?? ""
            interestedingrugs = data["interestedingrugs"] as? String ?? ""
            interestedinlogestrelationship = data["interestedinlogestrelationship"] as? String ?? ""
            interestedinpets = data["interestedinpets"] as? String ?? ""
            interestedinpolitics = data["interestedinpolitics"] as? String ?? ""
            interestedinsmoking = data["interestedinsmoking"] as? String ?? ""
            interestedlanguage = data["interestedlanguage"] as? String ?? ""
            interestedmatritalstatus = data["interestedmatritalstatus"] as? String ?? ""
            interestedpersonalitytype = data["interestedpersonalitytype"] as? String ?? ""
            interestedreligion = data["interestedreligion"] as? String ?? ""
            interestedsexuality = data["interestedsexuality"] as? String ?? ""
            interestedstarsign = data["interestedstarsign"] as? String ?? ""
            intertestedgender = data["intertestedgender"] as? String ?? ""
            jobtitle = data["jobtitle"] as? String ?? ""
            livingin = data["livingin"] as? String ?? ""
            lookingfor = data["lookingfor"] as? String ?? ""
            phoneno = data["phoneno"] as? String ?? ""
            school = data["school"] as? String ?? ""
            userage = data["userage"] as? String ?? ""
            userheight = data["userheight"] as? String ?? ""
            userid = data["userid"] as? String ?? ""
            username = data["username"] as? String ?? ""
            userpasword = data["userpasword"] as? String ?? ""
            userstatus = data["userstatus"] as? String ?? ""
        }
    }
}
