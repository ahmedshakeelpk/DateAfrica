//
//  MessagesAPIs.swift
//  DateAfrica
//
//  Created by Apple on 23/12/2020.
//

import Foundation

extension Messages {
    func funChatUsersApi(url:String, completionHandler: @escaping (_ success:Bool) -> Void) {
        let semaphore = DispatchSemaphore (value: 0)

        
        let parameters = [
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "chat_users",
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
                        if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Success1" {
                            chatUser.removeAll()
                            for (index, record) in dataDic.enumerated() {
                                if index == 0 {
                                    
                                }
                                else {
                                    chatUser.append(ChatUsers.init(data: record as! NSDictionary))
                                }
                            }
                            if chatUser.count > 0 {
                                self.tablev.isHidden = false
                                DispatchQueue.main.async {
                                    self.tablev.reloadData()
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    self.tablev.isHidden = true
                                }
                            }
                            
                        }
                        else {
                            self.tablev.isHidden = true
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
    
    
    
    func funMatchUserRecord() {
        let parameters = [
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "matches_users",
            "type": "text"
          ],
          [
            "key": "latitude",
            "value": "\(latitude)",
            "type": "text"
          ],
          [
            "key": "longitude",
            "value": "\(longitude)",
            "type": "text"
          ],
          [
            "key": "radius",
            "value": "\(userRadius)",
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
                        if (((dataDic[0] as! NSDictionary)["status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                            let dataRecord = (dataDic[0] as! NSDictionary)["userData"]! as! NSArray
                            if dataRecord.count > 0 {
                                matchUsersRecord.removeAll()
                                for (record) in dataRecord {
                                    //self.Packages?.append(Packages.init(data: record as! NSDictionary))
                                    matchUsersRecord.append(MatchUsersRecord.init(data: record as! NSDictionary))
                                }
                                if matchUsersRecord.count > 0 {
                                    DispatchQueue.main.async {
                                        colv.reloadData()
                                    }
                                }
                            }
                            else {
                                
                            }
                        }
                    }
                    else {
                       // colv.setEmojiMessage(msg: "Say Hello!\nTap on a new match above to send a message", icon: "package")
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
