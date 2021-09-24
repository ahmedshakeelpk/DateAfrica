//
//  RegisterSimple.swift
//  DateAfrica
//
//  Created by Apple on 07/01/2021.
//

import UIKit

class RegisterSimple: UIViewController {
    var phoneNumber = ""
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBAction func btnRegister(_ sender: Any) {
        if txtUserName.text == "" || txtEmail.text == "" || txtPassword.text == "" {
            showAlert(controller: self, title: "Alert!", message: "Please fill all fields")
        }
        else {
            let parameters = ["imgurl":"", "emailaddres":txtEmail.text!, "usertoken":fireBaseToken, "userpassword":txtPassword.text!, "type":"simpleregister", "":phoneNumber] as [String : Any]
            andicator.startAnimating()
            DispatchQueue.main.async {
                Registration.funRegisterationWithSocialMedia(parameters:parameters, completionHandler:{ success in
                    self.andicator.stopAnimating()
                    if success {
                        let vc = sbHome.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar
                              //  self.present(vc, animated: true, completion: nil)
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else {
                        showAlert(controller: self, title: "Failed", message: "Failed with Register")
                    }
                })
            }
        }
    }
    override func viewDidLoad() {
        lblPhoneNumber.text = "+" + phoneNumber
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
