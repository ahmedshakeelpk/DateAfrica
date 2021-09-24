//
//  AppSetting.swift
//  DateAfrica
//
//  Created by Apple on 16/12/2020.
//

import UIKit
import RangeSeekSlider
import CoreLocation

class AppSetting: UIViewController {

    var appSettingModel: AppSettingModel! = nil
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var lblRange: UILabel!
    @IBOutlet weak var ageRangeSlider: RangeSeekSlider!
    @IBOutlet weak var btnFeedBack: UIButton!
    @IBAction func btnFeedBack(_ sender: Any) {
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "Feedback") as! Feedback
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func ageRangeSlider(_ sender: RangeSeekSlider) {
        
    }
    @IBOutlet weak var txtLocation: UITextField!
    @IBAction func txtfunLocation(_ sender: Any) {
        txtLocation.resignFirstResponder()
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "CurrentLocation") as! CurrentLocation
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnPausePutHoldAccount(_ sender: Any) {
        DispatchQueue.main.async {
            self.funLogout()
        }
    }
    @IBAction func btnLogout(_ sender: Any) {
        
        let refreshAlert = UIAlertController(title: "Logout!", message: "Are you sure want to logout your account?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            DispatchQueue.main.async {
                self.funLogout()
            }
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    @IBOutlet weak var switchShowProfile: UISwitch!
    @IBAction func switchShowProfile(_ sender: Any) {
    }
    @IBOutlet weak var switchReadReceipts: UISwitch!
    @IBAction func switchReadReceipts(_ sender: Any) {
    }
   
    @IBOutlet weak var switchSwipeSurge: UISwitch!
    @IBAction func switchSwipeSurge(_ sender: Any) {
    }
    
    @IBOutlet weak var switchRecentlyActive: UISwitch!
    @IBAction func switchRecentlyActive(_ sender: Any) {
    }
    
    @IBOutlet weak var lblPhoneVerified: UILabel!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var lblEmailVarified: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imgvBottom: UIImageView!
    @IBOutlet weak var distanceRangeSlider: RangeSeekSlider!
    @IBAction func btnDeleteAccount(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Account", message: "Are you sure want to delete your account?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            
            DispatchQueue.main.async {
                self.funDeleteAccount()
            }
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          print("Handle Cancel Logic here")
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    @IBAction func txtPhone(_ sender: Any) {
        txtPhone.resignFirstResponder()
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "PhoneNumber") as! PhoneNumber
        vc.isPhone = true
        vc.complition = {
            success, phoneNumber in
            if success {
                self.funGetSetting()
            }
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func txtFunEmail(_ sender: Any) {
        txtEmail.resignFirstResponder()
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "PhoneNumber") as! PhoneNumber
        vc.isPhone = false
        vc.complition = {
            success, phoneNumber in
            if success {
                self.funGetSetting()
            }
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var scrollv: UIScrollView!
    @IBOutlet weak var contentv: UIView!
    
    @IBAction func btnCommunityGuideliness(_ sender: Any) {
    }
    @IBAction func btnSafetyCenter(_ sender: Any) {
        guard let url = URL(string: "http://fysal.oreodevelopers.com/intl2/safty-and-policy.php") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func btnHarassment(_ sender: Any) {
        guard let url = URL(string: "http://fysal.oreodevelopers.com/intl2/harasment.php") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func btnTravel(_ sender: Any) {
        guard let url = URL(string: "http://fysal.oreodevelopers.com/intl2/travel.php") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func btnReport(_ sender: Any) {
        guard let url = URL(string: "http://fysal.oreodevelopers.com/intl2/report.php") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func btnConsent(_ sender: Any) {
        guard let url = URL(string: "http://fysal.oreodevelopers.com/intl2/consent.php") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func btnReportNear(_ sender: Any) {
        guard let url = URL(string: "http://fysal.oreodevelopers.com/intl2/report_near.php") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnLicence(_ sender: Any) {
        guard let url = URL(string: "http://fysal.oreodevelopers.com/intl2/report_near.php") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func btnPrivacyPolicy(_ sender: Any) {
        guard let url = URL(string: "http://fysal.oreodevelopers.com/intl2/safty-and-policy.php") else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func btnTermsServices(_ sender: Any) {
        guard let url = URL(string: "http://fysal.oreodevelopers.com/intl2/Terms-of-service.php") else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func btnHelpNSupportFAQs(_ sender: Any) {
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "FAQs") as! FAQs
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnDisableAccount(_ sender: Any) {
        funDisableAccount()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    override func viewDidLoad() {
        
        ageRangeSlider.delegate = self
        distanceRangeSlider.delegate = self

        title = "App Setting"
        funGetSetting()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(funUpdateSetting))

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func funSetData() {
        let minValue = Float(appSettingModel.agerangefrom)
        let maxValue = Float(appSettingModel.agerangeto)
        DispatchQueue.main.async {
//            self.ageRangeSlider.selectedMinValue = CGFloat(minValue ?? 0.0)
//            self.ageRangeSlider.selectedMaxValue = CGFloat(maxValue ?? 100.0)
        }
       
        lblRange.text = "\(appSettingModel.agerangefrom) - \(appSettingModel.agerangeto)"
        txtEmail.text = appSettingModel.email
        
        lblEmailVarified.text = appSettingModel.emailStatus == "true" ? "Varified" : "Not Varified"
        lblEmailVarified.textColor = appSettingModel.emailStatus == "true" ? UIColor.green  : UIColor.red
        
        lblDistance.text = appSettingModel.radius + " Km"
        txtPhone.text = appSettingModel.phone
        lblPhoneVerified.text = appSettingModel.phone == "" ? "Not Varified" : "Varified"
        lblPhoneVerified.textColor = appSettingModel.phone == "" ? .red : .green
        switchShowProfile.isOn = appSettingModel.showprofile == "true" ? true : false
        
        switchReadReceipts.isOn = appSettingModel.readreceipt == "true" ? true : false
        switchSwipeSurge.isOn = appSettingModel.swipesurge == "true" ? true : false
        switchRecentlyActive.isOn = appSettingModel.recentactive == "true" ? true : false

        //getAddressFromLatLon(pdblLatitude: <#T##String#>, withLongitude: <#T##String#>)
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }


                        print(addressString)
                  }
            })

        }

}

extension AppSetting: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider == distanceRangeSlider {
            distanceRangeSlider.minDistance = 0
            let tempMaxValue = String(format: "%.0f",maxValue)
            userRadius = Int(tempMaxValue)!
            defaults.setValue(userRadius, forKey: "userRadius")
            lblDistance.text = "\(tempMaxValue) Km"
        }
        else if slider == ageRangeSlider {
            let tempMinValue = String(format: "%.0f",minValue)
            let tempMaxValue = String(format: "%.0f",maxValue)
            lblRange.text = "\(tempMinValue) - \(tempMaxValue)"
        }
    }
}
