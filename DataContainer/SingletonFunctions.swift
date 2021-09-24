//
//  SingletonFunctions.swift
//  DateAfrica
//
//  Created by Apple on 23/12/2020.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

func showAlert(controller : UIViewController, title : String, message : String){
    
    let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    DispatchQueue.main.async {
        controller.present(alert, animated: true, completion: nil)
    }
}

func loadImageFromUrl(urlString: String, completionHandler: @escaping(_ result: UIImage)-> Void)  {
    
    //let url = URL(string: BASEURLMEDIA + urlString)
    
    AF.request(BASEURLMEDIA + urlString).responseImage { response in
        debugPrint(response)

        //print(response.request)
        //print(response.response)
        //debugPrint(response.result)

        if case .success(let image) = response.result {
           // print("image downloaded: \(image)")
            completionHandler(image)
        }
        else {
            completionHandler(UIImage(named: "account")!)
        }
    }
    
    
//    
//    return()
//    DispatchQueue.global().async { 
//        if let data = try? Data(contentsOf: url!) {
//            if let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    completionHandler(image)
//                }
//            }
//            else {
//                completionHandler(UIImage(named: "account")!)
//            }
//        }
//        else {
//            completionHandler(UIImage(named: "account")!)
//        }
//    }
}
