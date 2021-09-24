//
//  LikeAPIs.swift
//  DateAfrica
//
//  Created by Apple on 28/12/2020.
//

import Foundation
import UIKit

extension Like {
    
    func funFetchTopPicks() {
        let parameters = [
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "top_picks",
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
           // self.view.removeEmoji()
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
                            let dataDicRecords = (dataDic.value(forKey: "userData") as! NSArray)
                            if dataDicRecords.count > 0 {
                                topPicks.removeAll()
                                let recordData = dataDicRecords[0] as! NSArray
                                for (_, record) in recordData.enumerated() {
                                    topPicks.append(TopPicks.init(data: record as! NSDictionary))
                                }
                                if topPicks.count > 0 {
                                    funReloadColView()
                                }
                                else {
                                    self.colv.isHidden = true
                                }
                            }
                        }
                    }
                    else {
                        self.colv.isHidden = true
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
    
    func funFetchWhoLikesMe() {
        let parameters = [
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "who_likes_me",
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
                        if (((dataDic[0] as! NSDictionary)["Status"] as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as! String == "Success" {
                            if dataDic.count > 0 {
                                usersLikes.removeAll()
                                for (index, record) in dataDic.enumerated() {
                                    if index == 0 {
                                        
                                    }
                                    else {
                                        usersLikes.append(UsersLikes.init(data: record as! NSDictionary))
                                    }
                                }
                                if usersLikes.count > 0 {
                                    funReloadColView()
                                }
                                else {
                                    self.colv.isHidden = true
                                    DispatchQueue.global().async { [weak self] in
                                        self?.andicator.stopAnimating()
                                    }
                                }
                            }
                            else {
                                DispatchQueue.main.async {
                                    self.andicator.stopAnimating()
                                }
                                self.view.setEmojiMessage(msg: "No Profile Avalible", icon: "home")
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
