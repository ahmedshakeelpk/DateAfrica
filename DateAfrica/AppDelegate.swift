//
//  AppDelegate.swift
//  DateAfrica
//
//  Created by Apple on 07/12/2020.
//

import UIKit
import Firebase
import UserNotifications
import UserNotificationsUI
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseInstallations
import GoogleMaps

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        application.registerForRemoteNotifications()
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: NSNotification.Name.InstallationIDDidChange,
                                               object: nil)
        
        Installations.installations().installationID { token, error in
            print("Id used to debug Firebase InApp Messaging: \(token ?? "")")
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let token = token {
                print("Remote instance ID token: \(token)")
                defaults.setValue(token, forKey: "fcmid")
            }
        }

        Installations.installations().authToken(completion: { token, error in
            print("Id used to debug Firebase InApp Messaging: \(token?.authToken ?? "")")
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let token = token {
                print("Remote instance ID token: \(token)")
                defaults.setValue(token.authToken, forKey: "fcmtoken")
            }
        })
        
        Messaging.messaging().token { token, error in
                 if let error = error {
                   print("Error fetching FCM registration token: \(error)")
                 } else if let token = token {
                   print("FCM registration token: \(token)")
                   UserDefaults.standard.setValue("\(token)", forKey: "fcmToken")
                 }
               }
            
            
        GMSServices.provideAPIKey("AIzaSyBCikWAg8rwOrUoS7OULXWLR_44AIosSRs")

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    @objc func tokenRefreshNotification(_ notification: Notification)
    {
        Installations.installations().installationID { token, error in
            print("Id used to debug Firebase InApp Messaging: \(token ?? "")")
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let token = token {
                print("Remote instance ID token: \(token)")
                defaults.setValue(token, forKey: "fcmid")
            }
        }

        Installations.installations().authToken(completion: { token, error in
            print("Id used to debug Firebase InApp Messaging: \(token?.authToken ?? "")")
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let token = token {
                print("Remote instance ID token: \(token)")
                defaults.setValue(token.authToken, forKey: "fcmtoken")
            }
        })
    }
}

