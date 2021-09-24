//
//  MessageBoxAPIs.swift
//  DateAfrica
//
//  Created by Apple on 01/01/2021.
//

import UIKit

extension MessageBox {

    func funSendMessageAPI() {
        let semaphore = DispatchSemaphore (value: 0)
        
        let parameters = [
          [
            "key": "actor",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "send_message",
            "type": "text"
          ],
          [
            "key": "target",
            "value": targetId,
            "type": "text"
          ],
          [
            "key": "message",
            "value": lastmessage,
            "type": "text"
          ],
          [
            "key": "messagetype",
            "value": "",
            "type": "text"
          ],
          [
            "key": "rcivertokn",
            "value": targetToken,
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
            
            guard let data = data else {
                print(String(describing: error))
            return
          }
           // print(String(data: data, encoding: .utf8)!)
        
            let jsonstring = String(data: data, encoding: .utf8)
            do{
                let responseData2 = SingleTon.convertToArray(stringJson: jsonstring!)

                let responseData = SingleTon.convertToDictionary(stringJson: jsonstring!)
                if responseData != nil {
                    let dataDic = (responseData! as NSDictionary)
                    if dataDic.count > 0 {
                        if (dataDic["Status"] as! NSDictionary)["Status"] as? String == "Success" {
                           
                            DispatchQueue.main.async {
                               funMessageSent()
                            }
                        }
                        else {
//                            showAlert(controller: self, title: "Error!", message: dataDic["message"] as? String ?? "Already Submitted!")
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
    
    func funBlockUnblockUser(status: String) {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "actor",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "blocked_user",
            "type": "text"
          ],
          [
            "key": "target",
            "value": targetId,
            "type": "text"
          ],
          [
            "key": "status",
            "value": status,
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

        andicator.startAnimating()
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
                            if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String == "User not blocked" {
                                //Mark:- if user blocked
                                print((((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String? as Any)
                                ifUserBlock = true
                                funUserBlockUnblock()
                            }
                            else {
                                print((((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String as Any)
                                ifUserBlock = false
                                funUserBlockUnblock()
                            }
                        }
//                        else if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Error" {
//                            if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String == "User is unblocked successfuly" {
//                                //Mark:- if user not block
//                                print((((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String as Any)
//                                ifUserBlock = false
//                                funUserBlockUnblock()
//                            }
//                        }
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
    
    
    func funUserBlockStatus() {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "actor",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "read_actor_block",
            "type": "text"
          ],
          [
            "key": "target",
            "value": targetId,
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
                            if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String == "User blocked" {
                                //Mark:- if user blocked
                                print((((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String? as Any)
                                ifUserBlock = true
                                funUserBlockUnblock()
                            }
                        }
                        else if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Error" {
                            if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String == "User not blocked" {
                                //Mark:- if user not block
                                print((((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String as Any)
                                ifUserBlock = false
                                funUserBlockUnblock()
                            }
                        }
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
    
    func funUserProfileDetails() {
        let parameters = [
          [
            "key": "filename",
            "value": "read_user_detail",
            "type": "text"
          ],
          [
            "key": "id",
            "value": targetId,
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
}
