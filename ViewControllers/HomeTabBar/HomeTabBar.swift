//
//  HomeTabBar.swift
//  DateAfrica
//
//  Created by Apple on 09/12/2020.
//

import UIKit
import XLPagerTabStrip
import CoreLocation

class HomeTabBar: ButtonBarPagerTabStripViewController {

    
    @IBOutlet weak var customcolv: ButtonBarView!
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func viewDidLoad() {
        funGetCurrentLocation()
        // Do any additional setup after loading the view.
        ////////////////////////////////////////////////
        UINavigationBar.appearance().barTintColor = .blue
        //
        settings.style.buttonBarItemTitleColor = tabBarHomeIconColor
        // bar seperator color
        settings.style.buttonBarBackgroundColor = .white
        // change bar cell bg color
        settings.style.buttonBarItemBackgroundColor = .white
        //MARK:- bottom line color
        settings.style.selectedBarBackgroundColor = tabBarHomeIconColor
        //MARK: - Cell Height
        settings.style.buttonBarHeight = 50
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        //MARK:- bottom line height
        settings.style.selectedBarHeight = 3.0
        //MARK:- set Y Axes of bar view (its create by me manual)
//        settings.style.buttonBarFrameYAxes = NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT
//        if IPAD {
//            settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 23)
//            //MARK: - Cell Height
//            settings.style.buttonBarHeight = 90
//            //MARK:- bottom line height
//            settings.style.selectedBarHeight = 6.0
//            //MARK:- set Y Axes of bar view (its create by me manual)
//            settings.style.buttonBarFrameYAxes = 64
//        }
        
        //MARK:- Center spacing between items
        settings.style.buttonBarMinimumLineSpacing = 5
        settings.style.buttonBarItemTitleColor = .red
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarItemLeftRightMargin = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
        guard changeCurrentIndex == true else { return }
            //MARK:- unselected text color
        oldCell?.label.textColor = .white
          //  oldCell?.imageView.image = newCell?.imageView.image?.withRenderingMode(.alwaysTemplate)
          //  oldCell?.imageView.tintColor = tabBarHomeIconColor
//            //MARK:- bottom line height
//            //MARK:- Selected text color
            newCell?.label.textColor = .white
          //  newCell?.imageView.image = newCell?.imageView.image?.withRenderingMode(.alwaysTemplate)
          //  newCell?.imageView.tintColor = tabBarHomeIconColor
        }
        
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = sbHome.instantiateViewController(withIdentifier: "Home")
        let child_2 = sbHome.instantiateViewController(withIdentifier: "Like")
        let child_3 = sbHome.instantiateViewController(withIdentifier: "Messages")
        let child_4 = sbHome.instantiateViewController(withIdentifier: "Account")
        return [child_1, child_2, child_3, child_4]
    }
}


extension HomeTabBar {
    func funGetCurrentLocation() {
        let getLocation = GetLocation()
        getLocation.run {
            if let location = $0 {
                print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
                defaults.setValue(latitude, forKey: "latitude")
                defaults.setValue(longitude, forKey: "longitude")
                
                
                self.funUpdateUserCurrentLocation()
            } else {
                print("Get Location failed \(getLocation.didFailWithError)")
                self.funUpdateUserCurrentLocation()
            }
        }
    }
    
    func funUpdateUserCurrentLocation() {
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = [
          [
            "key": "id",
            "value": userProfile.userid,
            "type": "text"
          ],
            [
            "key": "latitude",
            "value": "\(latitude)",
            "type": "text"
          ],
          [
            "key": "longitude",
            "value": "\(longitude)",
            "type": "text"
          ],
          [
            "key": "radius",
            "value": "\(userRadius)",
            "type": "text"
          ],
          [
            "key": "filename",
            "value": "add_user_location",
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
                let responseData = SingleTon.convertToDictionary(stringJson: jsonstring!)
                if responseData != nil {
                    let dataDic = (responseData! as NSDictionary)
                    if dataDic.count > 0 {
                        if ((dataDic["response"] as! NSDictionary).value(forKey: "Status") as! NSDictionary).value(forKey: "Status") as? String == "Success" {
                            //MARK:- Card Liked Successfully
                            print((dataDic["response"] as! NSDictionary).value(forKey: "message") as! String)
                        }
                        else {
                            showAlert(controller: self, title: "Error!", message: "Please try again an error occured!")
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



