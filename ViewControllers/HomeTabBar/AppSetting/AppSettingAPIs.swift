//
//  AppSettingAPIs.swift
//  DateAfrica
//
//  Created by Apple on 24/12/2020.
//

import Foundation
import UIKit

extension AppSetting {
    
    func funGetSetting() {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "readsetting",
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
                            let dataPackageRecord = dataDic[0] as! NSDictionary
                            
                            appSettingModel = AppSettingModel(data: dataPackageRecord)
                            DispatchQueue.main.async {
//                                self.lblSubscibePackage.text = "\(packageCurrent.packgetype) \(packageCurrent.pckgeduration) \n \(packageCurrent.pckgeprice)"
//                                self.lblPackageDetails.text = "Start date: \(packageCurrent.startdate)\nEnd date: \(packageCurrent.enddate)"
                                funSetData()
                            }
                        }
                        else if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Error" {
                            let msg = (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "message") as? String ?? "Please Selecte your package"
//                            self.lblSubscibePackage.text = msg
//                            self.lblPackageDetails.text = "No Package"
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
    
    @objc func funUpdateSetting() {
        let semaphore = DispatchSemaphore (value: 0)
        
        let minAge = String(format: "%.0f",ageRangeSlider.selectedMinValue)
        let maxAge = String(format: "%.0f",ageRangeSlider.selectedMaxValue)
        let maxDistance = String(format: "%.0f",distanceRangeSlider.selectedMaxValue)
        
        let parameters = [
            [
                "key": "id",
                "value": userProfile.userid,
                "type": "text"
            ],
          [
            "key": "filename",
            "value": "updatesetting",
            "type": "text"
          ],
          [
            "key": "showprofile",
            "value": switchShowProfile.isOn == true ? "true" : "false",
            "type": "text"
          ],
          [
            "key": "readreceipt",
            "value": switchReadReceipts.isOn == true ? "true" : "false",
            "type": "text"
          ],
          [
            "key": "swipesurge",
            "value": switchSwipeSurge.isOn == true ? "true" : "false",
            "type": "text"
          ],
          [
            "key": "toage",
            "value": maxAge,
            "type": "text"
          ],
          [
            "key": "recentactive",
            "value": switchRecentlyActive.isOn == true ? "true" : "false",
            "type": "text"
          ],
          [
            "key": "fromage",
            "value": minAge,
            "type": "text"
          ],
          [
            "key": "radius",
            "value": maxDistance,
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
                            
                                showAlert(controller: self, title: "Success!", message: (dataDic[0] as! NSDictionary)["message"]! as! String)
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
    
    func funDeleteAccount() {
        
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "filename",
            "value": "delete_acc",
            "type": "text"
          ],
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var _: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "C_t-Disposition:form-data; name=\"\(paramName)\""
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
           // self.andicator.stopAnimating()
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
                        //let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Splash")
                        self.navigationController?.popToRootViewController(animated: true)

                    }
                    else {
                        
                    }
                }
                else {
                }
            }
            else {
                DispatchQueue.main.async {
                   // showAlert(controller: self, title: "Failed", message: "Error Occured!")
                }
            }
        }
        catch let parseError {
            print(parseError)
            print("Something went wrong")
            // print(response.description)
            print(Error.self)
            //print(url)
        }
        }
        task.resume()
        semaphore.wait()
    }
    
    
    func funDisableAccount() {
        let semaphore = DispatchSemaphore (value: 0)
        
        let minAge = String(format: "%.0f",ageRangeSlider.selectedMinValue)
        let maxAge = String(format: "%.0f",ageRangeSlider.selectedMaxValue)
        let maxDistance = String(format: "%.0f",distanceRangeSlider.selectedMaxValue)
        
        let parameters = [
            [
                "key": "id",
                "value": userProfile.userid,
                "type": "text"
            ],
          [
            "key": "filename",
            "value": "updatesetting",
            "type": "text"
          ],
            [
              "key": "showprofile",
              "value": "false",
              "type": "text"
            ],
          [
            "key": "readreceipt",
            "value": switchReadReceipts.isOn == true ? "true" : "false",
            "type": "text"
          ],
          [
            "key": "swipesurge",
            "value": switchSwipeSurge.isOn == true ? "true" : "false",
            "type": "text"
          ],
          [
            "key": "toage",
            "value": maxAge,
            "type": "text"
          ],
          [
            "key": "recentactive",
            "value": switchRecentlyActive.isOn == true ? "true" : "false",
            "type": "text"
          ],
          [
            "key": "fromage",
            "value": minAge,
            "type": "text"
          ],
          [
            "key": "radius",
            "value": maxDistance,
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
                            
                                showAlert(controller: self, title: "Success!", message: (dataDic[0] as! NSDictionary)["message"]! as! String)
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
    
    func funLogout() {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "filename",
            "value": "logout",
            "type": "text"
          ],
          [
            "key": "id",
            "value": userProfile.userid,
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

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
            print(String(describing: error))
            return
          }
            
            let jsonstring = String(data: data, encoding: .utf8)
            do{
                let responseData = SingleTon.convertToArray(stringJson: jsonstring!)
                if responseData != nil {
                    let dataDic = (responseData! as NSArray)
                    if dataDic.count > 0 {
                        if (((dataDic[0] as! NSDictionary)["Status"]! as! NSArray)[0] as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                            userProfile = nil
                            DispatchQueue.main.async {
                               // let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Splash")
                                DispatchQueue.main.async {
                                    self.navigationController?.popToRootViewController(animated: true)

                                }
                            }
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
            
            
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
}
