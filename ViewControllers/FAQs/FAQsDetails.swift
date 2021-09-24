//
//  FAQsDetails.swift
//  DateAfrica
//
//  Created by Apple on 09/01/2021.
//

import UIKit

class FAQsDetails: UIViewController {

    var question = ""
    var desc = ""
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var lblQuestion: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        lblQuestion.numberOfLines = 0
        lblQuestion.lineBreakMode = .byWordWrapping
        lblQuestion.text = question
        lblQuestion.sizeToFit()
        lblDesc.numberOfLines = 0
        lblDesc.lineBreakMode = .byWordWrapping
        lblDesc.text = desc
        lblDesc.sizeToFit()
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
