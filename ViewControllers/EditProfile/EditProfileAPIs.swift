//
//  EditProfileAPIs.swift
//  DateAfrica
//
//  Created by Apple on 31/12/2020.
//

import Foundation
import UIKit

extension EditProfile {
    func funUserProfileDetails() {
        let parameters = [
          [
            "key": "filename",
            "value": "read_user_detail",
            "type": "text"
          ],
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ]] as [[String : Any]]
        let semaphore = DispatchSemaphore (value: 0)
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
        
        self.andicator.startAnimating()
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            self.view.removeEmoji()
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
                        if ((dataDic["response"] as! NSDictionary).value(forKey: "Status") as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                            //MARK:- Card Liked Successfully
                            
                            self.userProfileModel = UserProfile.UserProfileModel(data: dataDic["response"] as! NSDictionary)
                            self.funFillDataInFields()
                        }
                        else {
                            showAlert(controller: self, title: "Error!", message: "Please try again an error occured!")
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
    func funGetUserPictures() {
            let parameters = [
              [
                "key": "filename",
                "value": "read_user_images",
                "type": "text"
              ],
              [
                "key": "id",
                "value": userProfile.userid,
                "type": "text"
              ]] as [[String : Any]]
        
        
        let semaphore = DispatchSemaphore (value: 0)
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
        
        self.andicator.startAnimating()
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            self.view.removeEmoji()
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
                            for (index, record) in dataDic.enumerated() {
                                if index == 0 {
                                    
                                }
                                else {
                                    userPicturesModel.append(UserPicturesModel(data: record as! NSDictionary))
                                }
                            }
                            if userPicturesModel.count > 0 {
                                colv.reloadData()
                            }
                        }
                        else {
                            
                        }
                    }
                    else {
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
    
    
    func funUploadUserPicture(image: UIImage) {
        let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
        let fileData = image.jpegData(compressionQuality: CGFloat(0.7))!

        let parameters = [
          [
            "key": "filename",
            "value": "get_user_images",
            "type": "text"
          ],
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "pos ",
            "value": "0",
            "type": "text"
          ],
          [
            "key": "Logofile",
            "src": "\(currentTimeStamp).jpg",
            "type": "file"
          ]] as [[String : Any]]
        
        
        let semaphore = DispatchSemaphore (value: 0)
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
              //let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
                
                let fileContent = String(decoding: fileData, as: UTF8.self)
                //let fileContent = String(data: fileData!, encoding: .utf8)!
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
            self.view.removeEmoji()
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
//                            userPicturesModel.removeAll()
//                            for (index, record) in dataDic.enumerated() {
//                                if index == 0 {
//                                    
//                                }
//                                else {
//                                    userPicturesModel.append(UserPicturesModel(data: record as! NSDictionary))
//                                }
//                            }
//                            if userPicturesModel.count > 0 {
//                                colv.reloadData()
//                            }
                        }
                        else {
                            
                        }
                    }
                    else {
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
    
    func funRemoveUserPicture(imageid: String, index: Int) {
        andicator.startAnimating()

        
        let parameters = [
          [
            "key": "filename",
            "value": "delete_user_image",
            "type": "text"
          ],
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "imgid",
            "value": imageid,
            "type": "text"
          ]] as [[String : Any]]
        
        let semaphore = DispatchSemaphore (value: 0)
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
            self.view.removeEmoji()
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
                            userPicturesModel.remove(at: index)
                            colv.reloadData()
                        }
                        else {
                            
                        }
                    }
                    else {
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
    
    //MARK: - Post WebServices
    func updateProfile(parametersData:Dictionary<String,Any>, completionHandler: @escaping (_ success: Bool, _ message: String) -> ()) {
        
        let semaphore = DispatchSemaphore (value: 0)
        let parameters = [
          [
            "key": "usertoken",
            "value": fireBaseToken,
            "type": "text"
          ],
            [
                "key": "phoneno",
                "value": "\(parametersData["phoneno"] ?? "")",
                "type": "text"
            ],
            [
            "key": "mobilenumber",
            "value": "\(parametersData["mobilenumber"] ?? "")",
            "type": "text"
          ],
          [
            "key": "userage",
            "value": "\(parametersData["userage"] ?? "")",
            "type": "text"
          ],
          [
            "key": "type",
            "value": "simpleregister",
            "type": "text"
          ],
          [
            "key": "username",
            "value": "\(parametersData["username"] ?? "")",
            "type": "text"
          ],
          [
            "key": "emailaddres",
            "value": "\(parametersData["emailaddres"] ?? "")",
            "type": "text"
          ],
          [
            "key": "userpassword",
            "value": "\(parametersData["userpassword"] ?? "")",
            "type": "text"
          ],
          [
            "key": "jobtitle",
            "value": "\(parametersData["jobtitle"] ?? "")",
            "type": "text"
          ],
          [
            "key": "company",
            "value": "\(parametersData["company"] ?? "")",
            "type": "text"
          ],
          [
            "key": "school",
            "value": "\(parametersData["school"] ?? "")",
            "type": "text"
          ],
          [
            "key": "aboutuser",
            "value": "\(parametersData["aboutuser"] ?? "")",
            "type": "text"
          ],
          [
            "key": "intertestedgender",
            "value": "\(parametersData["intertestedgender"] ?? "")",
            "type": "text"
          ],
          [
            "key": "gender",
            "value": "\(parametersData["gender"] ?? "")",
            "type": "text"
          ],
          [
            "key": "agerangefrom",
            "value": "\(parametersData["agerangefrom"] ?? "")",
            "type": "text"
          ],
            [
              "key": "agerangeto",
              "value": "\(parametersData["agerangeto"] ?? "")",
              "type": "text"
            ],
          [
            "key": "userheight",
            "value": "\(parametersData["userheight"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedreligion",
            "value": "\(parametersData["interestedreligion"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedchildern",
            "value": "\(parametersData["interestedchildern"] ?? "")",
            "type": "text"
          ],
          [
            "key": "educationlevel",
            "value": "\(parametersData["educationlevel"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedindrink",
            "value": "\(parametersData["interestedindrink"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedinsmoking",
            "value": "\(parametersData["interestedinsmoking"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedethnicity",
            "value": "\(parametersData["interestedethnicity"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedinpolitics",
            "value": "\(parametersData["interestedinpolitics"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedingrugs",
            "value": "\(parametersData["interestedingrugs"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedinpets",
            "value": "\(parametersData["interestedinpets"] ?? "")",
            "type": "text"
          ],
          [
            "key": "lookingfor",
            "value": "\(parametersData["lookingfor"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedsexuality",
            "value": "\(parametersData["interestedsexuality"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedbodytype",
            "value": "\(parametersData["interestedbodytype"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedlanguage",
            "value": "\(parametersData["interestedlanguage"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedstarsign",
            "value": "\(parametersData["interestedstarsign"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedinexercise",
            "value": "\(parametersData["interestedinexercise"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedhaircolor",
            "value": "\(parametersData["interestedhaircolor"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedeyecolor",
            "value": "\(parametersData["interestedeyecolor"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedmatritalstatus",
            "value": "\(parametersData["interestedmatritalstatus"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedinlogestrelationship",
            "value": "\(parametersData["interestedinlogestrelationship"] ?? "")",
            "type": "text"
          ],
          [
            "key": "interestedpersonalitytype",
            "value": "\(parametersData["interestedpersonalitytype"] ?? "")",
            "type": "text"
          ],
          [
            "key": "livingin",
            "value": "\(parametersData["livingin"] ?? "")",
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "user_update",
            "type": "text"
          ],
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ]
        ] as [[String : Any]]
        
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
          guard let data = data else {
            print(String(describing: error))
            return
          }
                print(String(data: data, encoding: .utf8)!)
            
            let jsonstring = String(data: data, encoding: .utf8)
            do{
           //     let responseData = SingleTon.convertToDictionary(stringJson: jsonstring!)
               // if responseData != nil {
                    let alert  = UIAlertController(title: "Thankyou!", message: "User Profile update successfully!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                //}
               // else {
                    
              //  }
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
