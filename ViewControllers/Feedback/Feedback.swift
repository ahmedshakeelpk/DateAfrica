//
//  Feedback.swift
//  DateAfrica
//
//  Created by Apple on 09/01/2021.
//

import UIKit

class Feedback: UIViewController {
    @IBOutlet weak var txtvFeedback: UITextView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBAction func btnSubmit(_ sender: Any) {
        if txtvFeedback.text == "Write Feedback here" || txtvFeedback.text == "" {
            
        }
        else {
            andicator.startAnimating()
            DispatchQueue.main.async {
                self.funSendFeedBack()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        txtvFeedback.layer.borderWidth = 1
        txtvFeedback.layer.cornerRadius = 4
        txtvFeedback.layer.borderColor = UIColor.gray.cgColor
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Feedback: UITextViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write Feedback here" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write Feedback here"
            textView.textColor = .lightGray
        }
    }
    
    func funSendFeedBack() {
        let parameters = [
          [
            "key": "filename",
            "value": "insrt_feedback",
            "type": "text"
          ],
          [
            "key": "usrtokn",
            "value": fireBaseToken,
            "type": "text"
          ],
          [
            "key": "userid",
            "value": userProfile.userid,
            "type": "text"
          ],
          [
            "key": "feedback",
            "value": txtvFeedback.text!,
            "type": "text"
          ]] as [[String : Any]]
        
        let semaphore = DispatchSemaphore (value: 0)
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
                let responseData = SingleTon.convertToArray2(stringJson: jsonstring!)
                let refreshAlert = UIAlertController(title: "Success!", message: "Thanks for you feedback!", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                    self.navigationController?.popViewController(animated: true)
                }))

                DispatchQueue.main.async {
                    present(refreshAlert, animated: true, completion: nil)
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


