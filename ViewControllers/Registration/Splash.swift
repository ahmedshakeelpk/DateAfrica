//
//  Splash.swift
//  DateAfrica
//
//  Created by Apple on 08/12/2020.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import AuthenticationServices


@available(iOS 13.0, *)
class Splash: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return view.window!
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            DispatchQueue.main.async {
                
                if "\(credentials.user)" != "" {

                    UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
                }
                if credentials.email != nil {

                    UserDefaults.standard.set("\(credentials.email!)", forKey: "User_Email")
                }
                if credentials.fullName!.givenName != nil {

                    UserDefaults.standard.set("\(credentials.fullName!.givenName!)", forKey: "User_FirstName")
                }
                if credentials.fullName!.familyName != nil {

                    UserDefaults.standard.set("\(credentials.fullName!.familyName!)", forKey: "User_LastName")
                }
                UserDefaults.standard.synchronize()
                self.setupUserInfoAndOpenView()
            }
            
        case let credentials as ASPasswordCredential:
            DispatchQueue.main.async {
            
                if "\(credentials.user)" != "" {

                    UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
                }
                if "\(credentials.password)" != "" {

                    UserDefaults.standard.set("\(credentials.password)", forKey: "User_Password")
                }
                UserDefaults.standard.synchronize()
                self.setupUserInfoAndOpenView()
            }
            
        default :
            let alert: UIAlertController = UIAlertController(title: "Apple Sign In", message: "Something went wrong with your Apple Sign In!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    public func setupUserInfoAndOpenView() {
        DispatchQueue.main.async {
            let parameters = ["userpassword":"","emailaddres":UserDefaults.standard.value(forKey: "User_Email")! , "usertoken":fireBaseToken, "imgurl":"", "type":"google"] as [String : Any]
            Registration.funRegisterationWithSocialMedia(parameters:parameters, completionHandler:{ success in
                    
                if success {
                    let vc = sbHome.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar
                          //  self.present(vc, animated: true, completion: nil)
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    showAlert(controller: self, title: "Failed", message: "Failed with login")
                }
            })
            
            
//            self.vwUserDetail.isHidden = false
//
//            if "\(UserDefaults.standard.value(forKey: "User_FirstName")!)" != "" || "\(UserDefaults.standard.value(forKey: "User_LastName")!)" != "" || "\(UserDefaults.standard.value(forKey: "User_Email")!)" != "" {
//
//                self.lblID.text = "\(UserDefaults.standard.value(forKey: "User_AppleID")!)"
//                self.lblFirstname.text = "\(UserDefaults.standard.value(forKey: "User_FirstName")!)"
//                self.lblLastname.text = "\(UserDefaults.standard.value(forKey: "User_LastName")!)"
//                self.lblEmail.text = "\(UserDefaults.standard.value(forKey: "User_Email")!)"
//            } else {
//
//                self.lblID.text = "\(UserDefaults.standard.value(forKey: "User_AppleID")!)"
//                self.lblFirstname.text = "\(UserDefaults.standard.value(forKey: "User_Password")!)"
//
//                self.lblLabelFirst.text = "Apple Password"
//
//                self.lblLabelLast.isHidden = true
//                self.lblLabelEmail.isHidden = true
//            }
            
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        let alert: UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBAction func btnLogin(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBAction func btnRegister(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Registration") as! Registration
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var btnLoginWithPhone: UIButton!
    @IBAction func btnLoginWithPhone(_ sender: Any) {
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "PhoneNumber") as! PhoneNumber
        vc.isPhone = true
        vc.complition = {
            success, phoneNumber in
            if success {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                    let vc = sbHome.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar
                          //  self.present(vc, animated: true, completion: nil)
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Registration") as! Registration
                        vc.phoneNumber = phoneNumber
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var btnLoginWithInstagram: UIButton!
    @IBAction func btnLoginWithInstagram(_ sender: Any) {
        
    }
    let objASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton()
    func setupAppleSignInButton() {
           
            objASAuthorizationAppleIDButton.frame = btnLoginWithInstagram.frame
            DispatchQueue.main.async {
                self.objASAuthorizationAppleIDButton.frame.origin.y = self.btnLoginWithInstagram.frame.origin.y
            }
           // objASAuthorizationAppleIDButton.frame = CGRect(x: btnLoginWithInstagram.frame.minX, y: btnLoginWithInstagram.frame.minY, width: btnLoginWithInstagram.frame.width, height: btnLoginWithInstagram.frame.height)
            objASAuthorizationAppleIDButton.addTarget(self, action: #selector(loginWithApple), for: .touchUpInside)
            self.view.addSubview(objASAuthorizationAppleIDButton)
    }
    
    
    
    @objc func loginWithApple() {
        if #available(iOS 13.0, *) {
        
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    @IBAction func btnPrivacyPolicy(_ sender: Any) {
        guard let url = URL(string: "http://fysal.oreodevelopers.com/intl2/safty-and-policy.php") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func btnTermsServices(_ sender: Any) {
        guard let url = URL(string: "https://drive.google.com/file/d/1Ld-Kg9C0yi2DOOB7WnzDL0lwKNAG4yAp/view?usp=sharing") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBOutlet weak var btnLoginWithFacebook: UIButton!
    @IBAction func btnLoginWithFacebook(_ sender: Any) {
        let loginButton = LoginManager()
        loginButton.logIn(permissions: ["email","user_posts","public_profile"], from: self, handler: {
            (result: LoginManagerLoginResult?, error: Error?) in
                if error != nil {
                    print("Process error")
                    return
                }
                else if (result?.isCancelled)! {
                    print("Cancelled")
                }
                else {
                    //Success!
                    let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.tokenString)!)
                    
                    if let token = AccessToken.current {
                                let params = ["fields": "first_name, last_name, email, picture.width(480)"]
                                let graphRequest = GraphRequest(graphPath: "me", parameters: params,
                                                                tokenString: token.tokenString, version: nil, httpMethod: .get)
                                graphRequest.start { (connection, result, error) in
                                    if let error = error {
                                        print("Facebook graph request error: \(error)")
                                    } else {
                                        print("Facebook graph request successful!")
                                        guard let json = result as? NSDictionary else { return }
                                        if let id = json["id"] as? String {
                                            print("\(id)")
                                        }
                                        var email = ""
                                        if let temp = json["email"] as? String {
                                            print("\(email)")
                                            email = temp
                                        }
                                        if let firstName = json["first_name"] as? String {
                                            print("\(firstName)")
                                        }
                                        if let lastName = json["last_name"] as? String {
                                            print("\(lastName)")
                                        }
                                        var profilePic = ""
                                        if let profilePicObj = json["picture"] as? [String:Any] {
                                            if let profilePicData = profilePicObj["data"] as? [String:Any] {
                                                print("\(profilePicData)")
                                                if let temp = profilePicData["url"] as? String {
                                                    print("\(profilePic)")
                                                    profilePic = temp
                                                    defaults.setValue(temp, forKey: "userimage")
                                                }
                                            }
                                        }
                                        
                                        let parameters = ["userpassword":"","emailaddres":email, "usertoken":fireBaseToken, "imgurl":profilePic, "type":"facebook"] as [String : Any]
                                        Registration.funRegisterationWithSocialMedia(parameters:parameters, completionHandler:{ success in
                                                
                                            if success {
                                                let vc = sbHome.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar
                                                      //  self.present(vc, animated: true, completion: nil)
                                                DispatchQueue.main.async {
                                                    self.navigationController?.pushViewController(vc, animated: true)
                                                }
                                            }
                                            else {
                                                showAlert(controller: self, title: "Failed", message: "Failed with login")
                                            }
                                        })
                                    }
                                }
                            }

                }
            })

    }
    
    @IBOutlet weak var btnLoginWithGoogle: UIButton!
    @IBAction func btnLoginWithGoogle(_ sender: Any) {
//        let vc = sbHome.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar
//       // vc.modalPresentationStyle = .fullScreen
//      //  self.present(vc, animated: true, completion: nil)
//
//        self.navigationController?.pushViewController(vc, animated: true)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    override func viewDidLoad() {
       // loginWithApple()
        if !UserDefaults.standard.bool(forKey: "isAppleSignIn_FirstTime") {
            UserDefaults.standard.set("", forKey: "User_AppleID")
            UserDefaults.standard.set(true, forKey: "isAppleSignIn_FirstTime")
            UserDefaults.standard.synchronize()
        }
        
        
        btnLoginWithInstagram.isHidden = true
        
        btnLogin.setButtonCornorRadius()
        btnLoginWithPhone.setButtonCornorRadius()
        btnLoginWithInstagram.setButtonCornorRadius()
        btnLoginWithFacebook.setButtonCornorRadius()
        btnLoginWithGoogle.setButtonCornorRadius()
        funGoogleSetting()

        if defaults.value(forKey: "isLogin") as? Bool ?? false {
            userRadius = defaults.value(forKey: "userRadius") as! Int
        }
        
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
//            self.checkStatusOfAppleSignIn()
//            setupAppleSignInButton()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.objASAuthorizationAppleIDButton.frame.origin.y = self.btnLoginWithInstagram.frame.origin.y
        }
    }
    func checkStatusOfAppleSignIn()
    {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: "\(UserDefaults.standard.value(forKey: "User_AppleID")!)") { (credentialState, error) in
                
                switch credentialState {
                case .authorized:
                    self.setupUserInfoAndOpenView()
                    break
                case .revoked:
                            // The Apple ID credential is revoked.
                    break
                case .notFound:
                    // No credential was found, so show the sign-in UI.
                    break
                default:
                    break
                }
        }
    }
    func funGoogleSetting() {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
    }
}

@available(iOS 13.0, *)
extension Splash: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if let error = error {
        // ...
        return()
      }
        
        print(user.profile)

        let email = user.profile.email
        let fullName = user.profile.name
        let userimage = user.profile.imageURL(withDimension: 100)
        let userIdToken = user.authentication.idToken
//        if userimage ?? <#default value#> != "" {
//            defaults.setValue(userimage, forKey: "userimage")
//        }
        print(userIdToken)
        guard let authentication = user.authentication else { return }
        //let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        let parameters = ["userpassword":"","emailaddres":email!, "usertoken":fireBaseToken, "imgurl":userimage!, "type":"google"] as [String : Any]
        Registration.funRegisterationWithSocialMedia(parameters:parameters, completionHandler:{ success in
                
            if success {
                let vc = sbHome.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar
                      //  self.present(vc, animated: true, completion: nil)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else {
                showAlert(controller: self, title: "Failed", message: "Failed with login")
            }
        })
        
        
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
}



//@available(iOS 13.0, *)
//extension Splash : ASAuthorizationControllerDelegate
//{
//    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
//    {
//        switch authorization.credential {
//
//        case let credentials as ASAuthorizationAppleIDCredential:
//            DispatchQueue.main.async {
//
//                if "\(credentials.user)" != "" {
//
//                    UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
//                }
//                if credentials.email != nil {
//
//                    UserDefaults.standard.set("\(credentials.email!)", forKey: "User_Email")
//                }
//                if credentials.fullName!.givenName != nil {
//
//                    UserDefaults.standard.set("\(credentials.fullName!.givenName!)", forKey: "User_FirstName")
//                }
//                if credentials.fullName!.familyName != nil {
//
//                    UserDefaults.standard.set("\(credentials.fullName!.familyName!)", forKey: "User_LastName")
//                }
//                UserDefaults.standard.synchronize()
//                self.setupUserInfoAndOpenView()
//            }
//
//        case let credentials as ASPasswordCredential:
//            DispatchQueue.main.async {
//
//                if "\(credentials.user)" != "" {
//
//                    UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
//                }
//                if "\(credentials.password)" != "" {
//
//                    UserDefaults.standard.set("\(credentials.password)", forKey: "User_Password")
//                }
//                UserDefaults.standard.synchronize()
//                self.setupUserInfoAndOpenView()
//            }
//
//        default :
//            let alert: UIAlertController = UIAlertController(title: "Apple Sign In", message: "Something went wrong with your Apple Sign In!", preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//
//            self.present(alert, animated: true, completion: nil)
//            break
//        }
//    }
//
//    public func setupUserInfoAndOpenView() {
//        DispatchQueue.main.async {
//            let parameters = ["userpassword":"","emailaddres":UserDefaults.standard.value(forKey: "User_Email")! , "usertoken":fireBaseToken, "imgurl":"", "type":"google"] as [String : Any]
//            Registration.funRegisterationWithSocialMedia(parameters:parameters, completionHandler:{ success in
//
//                if success {
//                    let vc = sbHome.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar
//                          //  self.present(vc, animated: true, completion: nil)
//                    DispatchQueue.main.async {
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
//                else {
//                    showAlert(controller: self, title: "Failed", message: "Failed with login")
//                }
//            })
//
//
////            self.vwUserDetail.isHidden = false
////
////            if "\(UserDefaults.standard.value(forKey: "User_FirstName")!)" != "" || "\(UserDefaults.standard.value(forKey: "User_LastName")!)" != "" || "\(UserDefaults.standard.value(forKey: "User_Email")!)" != "" {
////
////                self.lblID.text = "\(UserDefaults.standard.value(forKey: "User_AppleID")!)"
////                self.lblFirstname.text = "\(UserDefaults.standard.value(forKey: "User_FirstName")!)"
////                self.lblLastname.text = "\(UserDefaults.standard.value(forKey: "User_LastName")!)"
////                self.lblEmail.text = "\(UserDefaults.standard.value(forKey: "User_Email")!)"
////            } else {
////
////                self.lblID.text = "\(UserDefaults.standard.value(forKey: "User_AppleID")!)"
////                self.lblFirstname.text = "\(UserDefaults.standard.value(forKey: "User_Password")!)"
////
////                self.lblLabelFirst.text = "Apple Password"
////
////                self.lblLabelLast.isHidden = true
////                self.lblLabelEmail.isHidden = true
////            }
//
//        }
//    }
//
//    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
//    {
//        let alert: UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//
//        self.present(alert, animated: true, completion: nil)
//    }
//}
//
//@available(iOS 13.0, *)
//extension Splash : ASAuthorizationControllerPresentationContextProviding
//{
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor
//    {
//        return view.window!
//    }
//}
