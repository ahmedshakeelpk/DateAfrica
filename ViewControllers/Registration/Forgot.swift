//
//  Forgot.swift
//  DateAfrica
//
//  Created by Apple on 08/12/2020.
//

import UIKit

class Forgot: UIViewController {

    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var btnsend: UIButton!
    @IBOutlet weak var andicator: UIActivityIndicatorView!

    @IBAction func btnsend(_ sender: Any) {
        if txtemail.text == "" {
            showAlert(controller: self, title: "Alert!", message: "Please enter valid email")
        }
        else {
            let parameters = ["receiver":txtemail.text!] as [String : Any]
            andicator.startAnimating()
            DispatchQueue.main.async {
                self.funForgotPassword(url: URLs.urlForgot, parameters: parameters, completionHandler:{ success  in
                    DispatchQueue.main.async {
                        self.andicator.stopAnimating()
                    }
                })
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
        self.title = "Forgot"
        txtemail.setRound()        
        btnsend.setButtonCornorRadius()
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
