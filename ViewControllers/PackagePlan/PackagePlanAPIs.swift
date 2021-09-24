//
//  PackagesAPIs.swift
//  DateAfrica
//
//  Created by Apple on 23/12/2020.
//

import Foundation
import Stripe

extension PackagePlan {
    func funCurrentPackage() {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "read_usr_subs",
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
                            let dataPackageRecord = ((dataDic[0] as! NSDictionary)["packge"]! as! NSArray)[0] as! NSDictionary
                            
                            packageCurrent = PackageCurrent(data: dataPackageRecord)
                            DispatchQueue.main.async {
                                self.lblSubscibePackage.text = "\(packageCurrent.packgetype) \(packageCurrent.pckgeduration) \n \(packageCurrent.pckgeprice)"
                                self.lblPackageDetails.text = "Start date: \(packageCurrent.startdate)\nEnd date: \(packageCurrent.enddate)"
                            }
                        }
                        else if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Error" {
                            let msg = (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String ?? "Please Selecte your package"
                            self.lblSubscibePackage.text = msg
                            self.lblPackageDetails.text = "No Package"
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
    
    func funShowPackages() {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "filename",
            "value": "show_packge",
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
                colv.removeEmoji()
                let responseData = SingleTon.convertToArray(stringJson: jsonstring!)
                if responseData != nil {
                    let dataDic = (responseData! as NSArray)
                    if dataDic.count > 0 {
                        if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                            let dataPackageRecord = (dataDic[0] as! NSDictionary)["packags"]! as! NSArray
                            packages.removeAll()
                            for (index,record) in dataPackageRecord.enumerated() {
                                //self.Packages?.append(Packages.init(data: record as! NSDictionary))
                                packages.append(Packages.init(data: record as! NSDictionary))
                                
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.colv.reloadData()
                        }
                    }
                    else {
                        colv.setEmojiMessage(msg: "Say Hello!\nTap on a new match above to send a message", icon: "package")
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
    
    @objc func funSubscribe() {
        //funStripe()
        
        funIAP()
    }
    

    
    
    func funActivePackage(stripeToken: String) {
        let semaphore = DispatchSemaphore (value: 0)
            let parameters = [
              [
                "key": "filename",
                "value": "stripepayment",
                "type": "text"
              ],
              [
                "key": "stripeToken",
                "value": stripeToken,
                "type": "text"
              ],
              [
                "key": "amount",
                "value": "100",
                "type": "text"
              ],
              [
                "key": "descrptn",
                "value": "kfkbjkfb",
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

        var request = URLRequest(url: URL(string: "http://dateafrica.oreodevelopers.com/user/")!,timeoutInterval: Double.infinity)
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
                                let dataPackageRecord = (dataDic[0] as! NSDictionary)["packags"]! as! NSArray
                                packages.removeAll()
                                for (record) in dataPackageRecord {
                                    //self.Packages?.append(Packages.init(data: record as! NSDictionary))
                                    packages.append(Packages.init(data: record as! NSDictionary))
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.colv.reloadData()
                            }
                        }
                        else {
                            colv.setEmojiMessage(msg: "Say Hello!\nTap on a new match above to send a message", icon: "package")
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
