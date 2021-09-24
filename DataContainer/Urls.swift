//
//  Urls.swift
//  DateAfrica
//
//  Created by Apple on 14/12/2020.
//

import UIKit
import Foundation

struct URLs {
    static let baseUrl = "\(BASEURL)/user/"
    static let urlLogin =  "\(baseUrl)user_login"
    static let urlRegistration = "\(baseUrl)user_update"
    static let urlForgot = "\(baseUrl)forgotpassword"
    static let urlFaq = "\(baseUrl)faqs"
    static let urlGetUserStatusOnlineOffline = "\(baseUrl)active_status"
    static let urlChatUsers = "\(baseUrl)chat_users"
    static let urlInsertChatMail = "\(baseUrl)updte_chat_mail"
    static let urlUserPackage = "\(baseUrl)read_usr_subs"
    static let urlInsertUserLocation = "\(baseUrl)add_user_location"
    static let urlInsertMobileNoAfterVerification = "\(baseUrl)update_phone"
    static let urlSetting = "\(baseUrl)readsetting"
    static let urlInsertSetting = "\(baseUrl)updatesetting"
    static let urlDeleteAccount = "\(baseUrl)delete_acc"
    static let urlInsertFeedBack = "\(baseUrl)insrt_feedback"
    static let urlLogout = "\(baseUrl)logout"
    static let urlRegister = "\(baseUrl)simpleregister"
    static let urlRegisterGoogle = "\(baseUrl)google"
    static let urlRegisterFacebook = "\(baseUrl)facebook"
    static let urlGetUserDetails = "\(baseUrl)read_user_detail"
    static let urlUploadUserImage = "\(baseUrl)get_user_image"
    static let urlGetUserImage = "\(baseUrl)read_user_images"
    static let urlGetPackages = "\(baseUrl)show_packge"
    static let urlGetUserRating = "\(baseUrl)read_usr_rating"
    static let urlUserRating = "\(baseUrl)usr_rating"
} 
