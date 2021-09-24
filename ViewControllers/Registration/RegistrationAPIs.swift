//
//  RegistrationAPIs.swift
//  DateAfrica
//
//  Created by Apple on 23/12/2020.
//

import Foundation
import UIKit
extension Login {
    func funLoginApi(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (_ success:Bool) -> Void) {
        let parametersData = parameters as NSDictionary
        let semaphore = DispatchSemaphore (value: 0)
        
        let parameters = [
          [
            "key": "filename",
            "value": "user_login",
            "type": "text"
          ],
          [
            "key": "emailaddres",
            "value": parametersData.value(forKey: "emailaddres") as Any,
            "type": "text"
          ],
          [
            "key": "userpassword",
            "value": parametersData.value(forKey: "userpassword") as Any,
            "type": "text"
          ],
          [
            "key": "usertoken",
            "value": fireBaseToken,
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
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
            print(String(describing: error))
            return
          }
           // print(String(data: data, encoding: .utf8)!)
        
            let jsonstring = String(data: data, encoding: .utf8)
            do{
                let responseData = try! SingleTon.convertToDictionary(stringJson: jsonstring!)
                if (responseData!["Status"]! as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                    
                    userProfile = SingleTon.UserProfile(data: responseData! as NSDictionary)
                    //print(SingleTon.UserProfile(data: responseData as! NSDictionary))
                    //showAlert(controller: self, title: "Success", message: "Login Successfully")
                    completionHandler(true)
                }
                else {
                    completionHandler(false)
                    showAlert(controller: self, title: "Failed", message: responseData!["message"]! as? String ?? "Error")
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

extension Forgot {
    func funForgotPassword(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping (_ success:Bool) -> Void) {
        let parametersData = parameters as NSDictionary
        let semaphore = DispatchSemaphore (value: 0)
        let parameters = [
          [
            "key": "receiver",
            "value": parametersData.value(forKey: "receiver") as Any,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "forgotpassword",
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
            guard let data = data else {
            print(String(describing: error))
            return
          }
           // print(String(data: data, encoding: .utf8)!)
        
            let jsonstring = String(data: data, encoding: .utf8)
            do{
                let responseData = SingleTon.convertToDictionary(stringJson: jsonstring!)
                if (responseData!["Status"]! as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                    showAlert(controller: self, title: "Success!", message: responseData!["message"]! as? String ?? "Success!")
                    completionHandler(true)
                }
                else {
                    completionHandler(false)
                    showAlert(controller: self, title: "Failed", message: responseData!["message"]! as? String ?? "Error")
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


extension Registration {
    static func funRegisterationWithSocialMedia(parameters:Dictionary<String,Any>, completionHandler: @escaping (_ success:Bool) -> Void) {
        let semaphore = DispatchSemaphore (value: 0)
        let parameters = [
          [
            "key": "filename",
            "value": "user_register",
            "type": "text"
          ],
          [
            "key": "userpassword",
            "value": parameters["userpassword"] ?? "",
            "type": "text"
          ],
          [
            "key": "emailaddres",
            "value": parameters["emailaddres"]!,
            "type": "text"
          ],
          [
            "key": "usertoken",
            "value": fireBaseToken,
            "type": "text"
          ],
          [
            "key": "pos",
            "value": "0",
            "type": "text"
          ],
          [
            "key": "url",
            "value": parameters["imgurl"] ?? "",
            "type": "text"
          ],
          [
            "key": "type",
            "value": parameters["type"]!,
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
              let paramValue = param["value"] as? String ?? ""
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
           // print(String(data: data, encoding: .utf8)!)
        
            let jsonstring = String(data: data, encoding: .utf8)
            do{
                let responseData = SingleTon.convertToDictionary(stringJson: jsonstring!)
                if responseData != nil {
                    if (responseData!["Status"]! as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                        userProfile = SingleTon.UserProfile(data: responseData! as NSDictionary)
                        completionHandler(true)
                    }
                    else {
                        completionHandler(false)
                    }
                }
                else {
                    completionHandler(false)
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
    static func simpleRegistration(parametersData:Dictionary<String,Any>, completionHandler: @escaping (_ success: Bool, _ message: String) -> ()) {
        
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
            "value": "user_register",
            "type": "text"
          ],
//          [
//            "key": "id",
//            "value": userProfile.userid,
//            "type": "text"
//          ]
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
                
                let responseData = SingleTon.convertToArray(stringJson: jsonstring!)

                if responseData != nil {
                    let dataDic = (responseData! as NSArray)
                    if dataDic.count > 0 {
                        if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                            userProfile = SingleTon.UserProfile(data: dataDic[0] as! NSDictionary)
                            completionHandler(true, (dataDic[0] as! NSDictionary)["message"]! as? String ?? "Successfully Register")
                        }
                        else {
                            completionHandler(false, (dataDic[0] as! NSDictionary)["message"]! as? String ?? "invalide user passwrod")
                        }
                    }
                    else {
                        completionHandler(false, "invalide user passwrod")
                    }
                }
                else {
                    //showAlert(controller: self, title: "Failed", message: "Error Occured!")
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
    
    static func funRegisterWithPhoneNumber(phoneNumber: String, completionHandler: @escaping (_ success:Bool, _ message: String) -> Void) {
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
            "value": phoneNumber,
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

        var request = URLRequest(url: URL(string: "http://Dateafrica.oreodevelopers.com/user/")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
              print(String(describing: error))
              return
            }
            let jsonstring = String(data: data, encoding: .utf8)
            do{
                let responseData = SingleTon.convertToDictionary(stringJson: jsonstring!)
                if (responseData!["Status"]! as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                   
                  //  showAlert(controller: self, title: "Success!", message: responseData!["message"]! as? String ?? "Success!")
                    userProfile = SingleTon.UserProfile(data: responseData! as NSDictionary)
                    completionHandler(true, responseData!["message"]! as? String ?? "Success!")
                }
                else {
                    completionHandler(false, responseData!["message"]! as? String ?? "Error")
                    
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
