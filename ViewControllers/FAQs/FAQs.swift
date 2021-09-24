//
//  FAQs.swift
//  DateAfrica
//
//  Created by Apple on 09/01/2021.
//

import UIKit

class FAQs: UIViewController {

    var fAQsModel = [FAQsModel]()
    @IBOutlet weak var tablev: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        tablev.delegate = self
        tablev.dataSource = self
        tablev.registerCell(cellName: "FAQsCell")
        funFAQs()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    func funFAQs() {
        
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "filename",
            "value": "faqs",
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
                let responseData = SingleTon.convertToArray(stringJson: jsonstring!)
                if responseData != nil {
                    let dataDic = (responseData! as NSArray)
                    if dataDic.count > 0 {
                        do {
                            guard let dataR = try? JSONSerialization.data(withJSONObject: dataDic, options: []) else {
                                return
                            }

                            let decoder = JSONDecoder()
                            self.fAQsModel = try decoder.decode([FAQsModel].self, from: dataR)
                            //print(self.fAQsModel)
                                if self.fAQsModel.count > 0 {
                                    DispatchQueue.main.async {
                                        self.tablev.reloadData()
                                    }
                                }
                            } catch DecodingError.dataCorrupted(let context) {
                                print(context)
                            } catch DecodingError.keyNotFound(let key, let context) {
                                print("Key '\(key)' not found:", context.debugDescription)
                                print("codingPath:", context.codingPath)
                            } catch DecodingError.valueNotFound(let value, let context) {
                                print("Value '\(value)' not found:", context.debugDescription)
                                print("codingPath:", context.codingPath)
                            } catch DecodingError.typeMismatch(let type, let context) {
                                print("Type '\(type)' mismatch:", context.debugDescription)
                                print("codingPath:", context.codingPath)
                            } catch {
                                print("error: ", error)
                            }
                            
//                            if userPicturesModel.count > 0 {
//                               // tablev.reloadData()
//                            }
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
}

struct FAQsModel: Decodable {
    let Status: String?
    let ans: String?
    let id: String?
    let ques: String?
}
extension FAQs: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "FAQsCell") as! FAQsCell
        cell.lblTitle.numberOfLines = 0;
        cell.lblTitle.lineBreakMode = .byWordWrapping
        cell.lblTitle.text = fAQsModel[indexPath.row].ques
        cell.lblTitle.sizeToFit()
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fAQsModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "FAQsDetails") as! FAQsDetails
        vc.question = fAQsModel[indexPath.row].ques ?? ""
        vc.desc = fAQsModel[indexPath.row].ans ?? ""
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
