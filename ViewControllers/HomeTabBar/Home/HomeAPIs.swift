//
//  HomeAPIs.swift
//  DateAfrica
//
//  Created by Apple on 24/12/2020.
//

import Foundation
import UIKit
extension Home {
    func funFetchHomeRecord() {
        let parameters = [
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ],
            [
              "key": "pid",
              "value": "\(PID)",
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
            //self.view.removeEmoji()
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
                        userRecord.removeAll()
                        if (((dataDic[0] as! NSDictionary)["status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                            let dataRecord = (dataDic[0] as! NSDictionary)["userData"]! as! NSArray
                            if dataRecord.count > 0 {
                                //
                                for (record) in dataRecord {
                                    //self.Packages?.append(Packages.init(data: record as! NSDictionary))
                                    userRecord.append(UsersRecord.init(data: record as! NSDictionary))
                                }
                                if userRecord.count > 0 {
                                    DispatchQueue.main.async {
                                        self.funLoadData()
                                    }
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    self.andicator.stopAnimating()
                                }
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
    
    func funLikeCard(userId: String, type: String) {
        let parameters = [
          [
            "key": "actor",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "swipe_user",
            "type": "text"
          ],
          [
            "key": "target",
            "value": "96",
            "type": "text"
          ],
          [
            "key": "type",
            "value": type, //"Like" / "Reject"
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
