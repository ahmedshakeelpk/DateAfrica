//
//  PhoneNumber.swift
//  DateAfrica
//
//  Created by Apple on 07/01/2021.
//

import UIKit
import FlagPhoneNumber
import FirebaseAuth

class PhoneNumber: UIViewController {
    
    var isPhone = false
    typealias complitionHandler = (_ success:Bool, _ phoneNumber: String) -> Void
    var complition: complitionHandler?
    
    var phonenumber = String()
    var countryCode = String()
    var countryName = String()
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var txtPhoneNumber: FPNTextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBAction func btnNext(_ sender: Any) {
        if isPhone {
            countryName = self.txtPhoneNumber.countryRepository.locale.regionCode ?? ""
            countryCode = self.txtPhoneNumber.selectedCountry!.phoneCode
            phonenumber = "\(txtPhoneNumber.selectedCountry!.phoneCode)\(txtPhoneNumber.text!)"
            phonenumber = phonenumber.replacingOccurrences(of: " ", with: "")
            phonenumber = phonenumber.replacingOccurrences(of: "+", with: "")
            funSendPhoneAuth()
        }
        else {
            if txtEmail.text != "" {
                andicator.startAnimating()
                DispatchQueue.main.async {
                    self.funSendEmail()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false

        DispatchQueue.main.async{
            //MARK:- Defaults selected country
            self.txtPhoneNumber.setFlag(key: FPNOBJCCountryKey.PK)
        }
        
        if !isPhone {
            txtPhoneNumber.isHidden = true
            lblDesc.text = "Registration code will be sent to your Email."
            lblTitle.text = "Enter your Email"
            txtPhoneNumber.placeholder = "abc@abc.com"
        }
        else {
            txtEmail.isHidden = true
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func funSendPhoneAuth() {
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "VerifyPhoneNumber") as! VerifyPhoneNumber
        //vc.fbVerificationID = verificationID!
        vc.phonenumber = self.phonenumber
        vc.isPhone = self.isPhone
        vc.complition = {
            success in
            if success {
                guard let complition = self.complition else {return}
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    complition(true, self.phonenumber)
                }
            }
            else {
                guard let complition = self.complition else {return}
                complition(false, self.phonenumber)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        return()
        andicator.startAnimating()
        PhoneAuthProvider.provider().verifyPhoneNumber(("+"+phonenumber), uiDelegate: nil){ (verificationID, error) in
            self.andicator.stopAnimating()
            if error != nil {
                showAlert(controller: self, title: "Alert!", message: (error?.localizedDescription)!)
                return
            }
            else{
                let vc = sbAppSetting.instantiateViewController(withIdentifier: "VerifyPhoneNumber") as! VerifyPhoneNumber
                vc.fbVerificationID = verificationID!
                vc.phonenumber = self.phonenumber
                vc.isPhone = self.isPhone
                vc.complition = {
                    success in
                    if success {
                        guard let complition = self.complition else {return}
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                            complition(true, self.phonenumber)
                        }
                    }
                    else {
                        guard let complition = self.complition else {return}
                        complition(false, self.phonenumber)
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
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
            "value": txtEmail.text!,
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
                            
                            DispatchQueue.main.async {
                                //showAlert(controller: self, title: "Success!", message: (dataDic[0] as! NSDictionary)["message"]! as! String)
                            let vc = sbAppSetting.instantiateViewController(withIdentifier: "VerifyPhoneNumber") as! VerifyPhoneNumber
                            vc.phonenumber = self.txtEmail.text!
                            vc.isPhone = self.isPhone
                            vc.complition = {
                                success in
                                if success {
                                    guard let complition = self.complition else {return}
                                    complition(true, self.phonenumber)
                                    DispatchQueue.main.async {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                                DispatchQueue.main.async {
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
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
}
