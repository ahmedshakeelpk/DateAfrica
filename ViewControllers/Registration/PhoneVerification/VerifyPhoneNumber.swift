//
//  VerifyPhoneNumber.swift
//  DateAfrica
//
//  Created by Apple on 07/01/2021.
//

import UIKit
import FirebaseAuth

class VerifyPhoneNumber: UIViewController {

    var isPhone = false
    typealias complitionHandler = (_ success:Bool) -> Void
    var complition: complitionHandler?

    var phonenumber = ""
    var fbVerificationID = String()
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var txtVerificationCode: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblDesc: UILabel!

    @IBAction func btnCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmit(_ sender: Any) {
        if txtVerificationCode.text! != "" {
            funVerifyCode()
        }
    }
    @IBOutlet weak var btnResend: UIButton!
    @IBAction func btnResend(_ sender: Any) {
        if isPhone {
            funSendPhoneAuth()
        }
        else {
            funSendEmail()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        if !isPhone {
            lblDesc.text = "Registration code has been sent to your Email."
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func funVerifyCode() {
        self.funUpdatePhoneNumbers()
        return
        andicator.startAnimating()
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: fbVerificationID,
            verificationCode: txtVerificationCode.text!)
        Auth.auth().signIn(with: credential, completion: { [self] (authResult, error) in
            self.andicator.stopAnimating()
            if error != nil {
                showAlert(controller: self, title: "Error!", message: (error?.localizedDescription)!)
                return
            }
            else {
                DispatchQueue.main.async {
                    self.funUpdatePhoneNumbers()
                }
            }
        })
    }
    
    func funSendPhoneAuth() {
        andicator.startAnimating()
        PhoneAuthProvider.provider().verifyPhoneNumber(("+"+phonenumber), uiDelegate: nil){ (verificationID, error) in
            self.andicator.stopAnimating()
            if error != nil {
                showAlert(controller: self, title: "Alert!", message: (error?.localizedDescription)!)
                return
            }
            else{
                self.fbVerificationID = verificationID!
                DispatchQueue.main.async {
                    showAlert(controller: self, title: "Success!", message: "Verification code successfully!")
                }
            }
        }
    }
    
    @objc func funSendEmail() {
        let semaphore = DispatchSemaphore (value: 0)
        
        let parameters = [
            [
                "key": "id",
                "value": userProfile.userid,
                "type": "text"
            ],
          [
            "key": "filename",
            "value": "verifyemail",
            "type": "text"
          ],
          [
            "key": "receiver",
            "value": phonenumber,
            "type": "text"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var _: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: BASEURL)!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            DispatchQueue.main.async {
                self.andicator.stopAnimating()
            }
            guard let data = data else {
                print(String(describing: error))
                return
            }
           // print(String(data: data, encoding: .utf8)!)
        
            let jsonstring = String(data: data, encoding: .utf8)
            do{
                let responseData = SingleTon.convertToArray(stringJson: jsonstring!)
                if responseData != nil {
                    let dataDic = (responseData! as NSArray)
                    if dataDic.count > 0 {
                        if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                            
                                showAlert(controller: self, title: "Success!", message: (dataDic[0] as! NSDictionary)["message"]! as! String)
                            }
                        else {
                            showAlert(controller: self, title: "Failed!", message: (dataDic[0] as! NSDictionary)["message"]! as! String)
                        }
                        }
                    else {
                        showAlert(controller: self, title: "Failed!", message: (dataDic[0] as! NSDictionary)["message"]! as! String)
                    }
                }
                else {
                    showAlert(controller: self, title: "Failed", message: "Error Occured!")
                }
            }
            catch let parseError {
                print(parseError)
                print("Something went wrong")
                // print(response.description)
                print(Error.self)
                //print(url)
            }
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    func funUpdatePhoneNumbers() {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "filename",
            "value": "user_login_phone",
            "type": "text"
          ],
          [
            "key": "type",
            "value": "login",
            "type": "text"
          ],
          [
            "key": "phoneno",
            "value": phonenumber,
            "type": "text"
          ],
            [
              "key": "usertoken",
              "value": fireBaseToken,
              "type": "text"
            ],
          [
            "key": "id",
            "value": "",
            "type": "text"
          ]] as [[String : Any]]


        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: BASEURL)!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.andicator.stopAnimating()
            }
            guard let data = data else {
                print(String(describing: error))
                return
            }
           // print(String(data: data, encoding: .utf8)!)
        
            let jsonstring = String(data: data, encoding: .utf8)
            do{
                let responseData = SingleTon.convertToDictionary(stringJson: jsonstring!)
                if responseData != nil {
                    let dataDic = (responseData! as NSDictionary)
                    if dataDic.count > 0 {
                        if (dataDic["Status"] as! NSDictionary)["Status"] as? String == "Success" {
                            //MARK:- Card Liked Successfully
                            userProfile = SingleTon.UserProfile(data: responseData! as NSDictionary)
                            guard let complition = self.complition else {return}
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                                complition(true)
                            }
                        }
                        else if (dataDic["Status"] as! NSDictionary)["Status"] as? String == "Error" {
                            if dataDic["message"] as? String == "Phone no not exists" {
                                guard let complition = self.complition else {return}
                                complition(false)
                                DispatchQueue.main.async {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                        else {
                            showAlert(controller: self, title: "Error!", message: dataDic["message"] as? String ?? "Error Occurd try again!")
                        }
                    }
                    else {
                       // colv.setEmojiMessage(msg: "Say Hello!\nTap on a new match above to send a message", icon: "package")
                    }
                }
                else {
                    
                }
            }
            catch let parseError {
                print(parseError)
                print("Something went wrong")
                // print(response.description)
                print(Error.self)
                //print(url)
            }
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
}
