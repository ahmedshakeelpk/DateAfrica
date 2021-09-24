//
//  ViewController.swift
//  DateAfrica
//
//  Created by Apple on 07/12/2020.
//

import UIKit


class Login: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBAction func btnLogin(_ sender: Any) {

        let parameters = ["emailaddres":txtEmail.text!,
                          "userpassword":txtPassword.text!,
                          "usertoken":fireBaseToken] as [String : Any]
        andicator.startAnimating()
        DispatchQueue.main.async {
            self.funLoginApi(url: URLs.urlLogin, parameters: parameters, completionHandler:{ success  in
                DispatchQueue.main.async {
                    self.andicator.stopAnimating()
                    if success {
                        let vc = sbHome.instantiateViewController(withIdentifier: "HomeTabBar") as! HomeTabBar
                              //  self.present(vc, animated: true, completion: nil)
                        DispatchQueue.main.async {
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            })
        }
    }
    @IBOutlet weak var btnForgot: UIButton!
    @IBAction func btnForgot(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Forgot") as! Forgot
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        txtEmail.text = nil
        txtPassword.text = nil
        self.title = "Login"
        txtEmail.setRound()
        txtPassword.setRound()
        btnLogin.setButtonCornorRadius()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


