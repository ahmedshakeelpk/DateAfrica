//
//  ReportUser.swift
//  DateAfrica
//
//  Created by Apple on 31/12/2020.
//

import UIKit

class ReportUser: UIViewController {

    var userid = String()
    var userName = String()
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var txtvComments: UITextView!
    @IBOutlet weak var btnReport: UIButton!
    @IBAction func btnReport(_ sender: Any) {
        if txtvComments.text.isEmpty || txtvComments.text == "Comments about user" {
            showAlert(controller: self, title: "Alert!", message: "Please type comments about user!")
        }
        else {
            funReportUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        title = "Report User"
        lblUserName.text = userName
        txtvComments.delegate = self
        // Do any additional setup after loading the view.
        txtvComments.layer.cornerRadius = 4
        txtvComments.layer.borderWidth = 1
        txtvComments.layer.borderColor = UIColor.blue.cgColor
        super.viewDidLoad()
    }
    

    func funReportUser() {
        let parameters = [
          [
            "key": "target",
            "value": userid,
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "abused_usr",
            "type": "text"
          ],
          [
            "key": "actor",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "status",
            "value": txtvComments.text!,
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
                        if (dataDic["Status"] as! NSDictionary)["Status"] as? String == "Success" {
                            //MARK:- Card Liked Successfully
                            
                          //  self.userProfileModel = UserProfileModel(data: dataDic["response"] as! NSDictionary)
                         //   self.funFillDataInFields()
                            let alert  = UIAlertController(title: "Thankyou!", message: dataDic["message"] as? String ?? "Thank you for your comments!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            DispatchQueue.main.async {
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else {
                            showAlert(controller: self, title: "Error!", message: dataDic["message"] as? String ?? "Already Submitted!")
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


extension ReportUser: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Comments about user" {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "Comments about user" {
            textView.text = "Comments about user"
            textView.textColor = UIColor.lightGray
        }
    }
}
