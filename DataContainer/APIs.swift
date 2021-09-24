//
//  APIs.swift
//  DateAfrica
//
//  Created by Apple on 17/12/2020.
//

import UIKit
import Foundation
import Alamofire

struct APIs {
    static func getApi<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void) {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 20
        configuration.allowsCellularAccess = false

        AF.request(requestUrl).validate().responseData(completionHandler: {
            response in
            if(response.data != nil && response.data?.count != 0) {
                do {
                    let response = try JSONDecoder().decode(T.self, from: response.data!)
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        })
    }
    
    
    static func getApiData<T:Decodable>(requestUrl: URL, completionHandler:@escaping(_ result: T?)-> Void) {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 20
        configuration.allowsCellularAccess = false

        AF.request(requestUrl).validate().responseData(completionHandler: {
            response in
            if(response.data != nil && response.data?.count != 0)
            {
                do {
                    //let dataJson = JSON(response.value as Any)
                    //self.testRecordData(response: response)
                    
                    //_=completionHandler((dataJson as! T))
                }
                
            }
        })
    }

    static func postApi2<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void) {
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "post"
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")

        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in

            if(data != nil && data?.count != 0)
            {
                do {
                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        }.resume()
    }
    
    static func testRecordData(response: AFDataResponse<Data>?) {
        var jsonstring = String()
        if let data = response?.data, let utf8Text = String(data: (response?.data)!, encoding: .utf8) {
            // print("Data: \(utf8Text)") // original server data as UTF8 string
            jsonstring = utf8Text
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                
                print(json!)
                print(json!)
                if json == nil {
                    let json2 = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                    if json2 == nil {
                        
                    }
//                    print(json2!)
//                    print(json2!)
                }
//                print(json!)
//                print(json!)
            }
            catch let parseError {
                print(parseError)
                print(jsonstring)
                print("Something went wrong")
                print(response?.description as Any)
                print(Error.self)
                //print(url)
            }
        }
    }
    
    
    //MARK: - Post WebServices
    static func postApi(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping ([NSDictionary]?, String?, [String:Any]?) -> ()) {
        
        let semaphore = DispatchSemaphore (value: 0)
        let parametersData = parameters
        let parameters = [
          [
            "key": "usertoken",
            "value": fireBaseToken,
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
//            "value": "\(parametersData["id"] ?? "")",
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
            
                var jsonstring = String(data: data, encoding: .utf8)
                do{
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                        
                        print(json as Any)
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
    
    static func postApiAlamofire(url:String , parameters:Dictionary<String,Any>, completionHandler: @escaping ([NSDictionary]?, String?, [String:Any]?) -> ()) {
                      let configuration = URLSessionConfiguration.af.default
                configuration.timeoutIntervalForRequest = 15
                configuration.allowsCellularAccess = false
                let sessionManager = Session(configuration: configuration)
                //        let headers: HTTPHeaders = [
                //            "Content-Type": "application/json",
                //       //     "Content-Type": "application/x-www-form-urlencoded",
                //            "Accept": "application/json"
                //        ]
                sessionManager.request(url, method: .post, parameters: parameters, encoding:JSONEncoding.default , headers: nil).responseData(completionHandler: {
        
                    response in
                    if let json = response.value {
                        print("JSON: \(json)") // serialized json response
                    }
                    var jsonstring = String()
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        // print("Data: \(utf8Text)") // original server data as UTF8 string
                        jsonstring = utf8Text
                        if jsonstring.count > 2
                        {
                            do{
        
                                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
        
                                print(json as Any)
                            }
                            catch let parseError {
                                print(parseError)
                                print(jsonstring)
                                print("Something went wrong")
                                print(response.description)
                                print(Error.self)
                                //print(url)
                            }
                        }
                    }
        
                    let data = response.result
                    switch(data)
                    {
                    case .success(let json):
                        print(json)
        
                        if let data = jsonstring.data(using: String.Encoding.utf8) {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSDictionary]
                                if json != nil
                                {
                                    completionHandler(json! as [NSDictionary], nil, nil)
                                    print(json!)
                                }
                                else
                                {
        
                                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                        // print("Data: \(utf8Text)") // original server data as UTF8 string
                                        jsonstring = utf8Text
                                        if jsonstring.count > 2
                                        {
                                            do{
        
                                                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                                                if json != nil
                                                {
                                                    completionHandler([NSDictionary](), nil, json! as [String: Any])
                                                }
                                                print(json as Any)
                                            }
                                            catch let parseError {
                                                print(parseError)
                                                print(jsonstring)
                                                print("Something went wrong")
                                                print(response.description)
                                                print(Error.self)
                                                //print(url)
                                            }
                                        }
                                    }
                                }
        
                            } catch let parseError {
                                print(parseError)
                                print(jsonstring)
                                print("Something went wrong")
                                print(response.description)
                                print(Error.self)
        
                                completionHandler(nil, "Not JSON Data.", nil)
                            }
                        }
        
        
                        sessionManager.session.invalidateAndCancel()
                        break
        
                        //            case .success(let JSON):
                        //                                    completionHandler(JSON as? NSDictionary, nil)
                        //
                        //                                    sessionManager.session.invalidateAndCancel()
                    //                                break
                    case .failure(let error):
                        if error._code == NSURLErrorCannotParseResponse
                        {
                            completionHandler(nil, "Not JSON Data.", nil)
        
                        }
                        else if error._code == NSURLErrorTimedOut
                        {
                            completionHandler(nil, "Server is not responding, request time out please try again.", nil)
        
                        }
                        else if error._code == NSURLErrorCannotFindHost
                        {
                            completionHandler(nil, error.localizedDescription, nil)
        
                        }
                        else if error._code == NSURLErrorNotConnectedToInternet
                        {
                            completionHandler(nil, error.localizedDescription, nil)
        
                        }
                        else
                        {
                            completionHandler(nil, error.localizedDescription, nil)
        
                        }
                        sessionManager.session.invalidateAndCancel()
                        break
                    }
                })
    }
}


