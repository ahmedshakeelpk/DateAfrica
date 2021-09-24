//
//  Singleton.swift
//  DateAfrica
//
//  Created by Apple on 09/12/2020.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

let sgMain = UIStoryboard(name: "Main", bundle: nil)
let sbHome = UIStoryboard(name: "Home", bundle: nil)
let sbAppSetting = UIStoryboard(name: "AppSetting", bundle: nil)
let sbMessaging = UIStoryboard(name: "Messaging", bundle: nil)
let tabBarHomeIconColor = UIColor(red: 82/255, green: 143/255, blue: 221/255, alpha: 1.0)
var defaults = UserDefaults.standard

var userProfile : SingleTon.UserProfile!
var latitude = defaults.value(forKey: "latitude") ?? 33.521554
var longitude = defaults.value(forKey: "longitude") ?? 72.58451486
var userRadius = defaults.value(forKey: "userRadius") ?? 1000
var fireBaseToken = defaults.value(forKey: "fcmtoken") ?? "testtoken"

var refFireBase = Database.database().reference()
var refStorageFireBase = Storage.storage().reference()
let fbMessagesDB = refFireBase.child("Messages")
let BASEURL2ND = "http://api.dateafrica.com/index.php"
let BASEURL = "http://dateafrica.oreodevelopers.com/user/"
let BASEURLMEDIA = "http://dateafrica.oreodevelopers.com/user/uploads/"
var userImage = ""
class SingleTon {
    
    struct UserProfile {
        var aboutuser : String
        var emailaddres : String
        var profilePic : String
        var username : String
        var userid : String

        init(data: NSDictionary) {
            aboutuser  = data["aboutuser"] as? String ?? ""
            emailaddres  = data["emailaddres"] as? String ?? ""
            profilePic  = data["profilePic"] as? String ?? ""
            username  = data["username"] as? String ?? ""
            userid  = data["userid"] as? String ?? ""
            if userid == "" {
                userid  = data["id"] as? String ?? ""
            }
            if userid == "" {
                userid  = String(data["id"] as? Int ?? 0)
            }
        }
    }
    static func convertToDictionary(stringJson: String) -> [String: Any]? {
        var text = stringJson.replacingOccurrences(of: "[", with: "")
        text = text.replacingOccurrences(of: "]", with: "")

        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    static func convertToArray(stringJson: String) -> NSArray? {
//        var text = stringJson.replacingOccurrences(of: "[", with: "")
//        text = text.replacingOccurrences(of: "]", with: "")

        let data = stringJson.data(using: .utf8)!
            do{
                //let output = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                return try (JSONSerialization.jsonObject(with: data,
                                                         options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray)
           //     print ("\(String(describing: output))")
            }
            catch {
                print (error)
            }
        return nil
    }
    static func convertToArray2(stringJson: String) -> NSArray? {
        var text = stringJson.replacingOccurrences(of: "[", with: "")
        text = text.replacingOccurrences(of: "]", with: "")

        let data = text.data(using: .utf8)!
            do{
                //let output = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                return try (JSONSerialization.jsonObject(with: data,
                                                         options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray)
           //     print ("\(String(describing: output))")
            }
            catch {
                print (error)
            }
        return nil
    }
}
extension Sequence {
    public func toDictionary<Key: Hashable>(with selectKey: (Iterator.Element) -> Key) -> [Key:Iterator.Element] {
        var dict: [Key:Iterator.Element] = [:]
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
