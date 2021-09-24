//
//  Account.swift
//  DateAfrica
//
//  Created by Apple on 09/12/2020.
//

import UIKit
import XLPagerTabStrip

class Account: UIViewController {

    @IBOutlet weak var imgvUser: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBAction func btnEdit(_ sender: Any) {
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    @IBAction func btnSetting(_ sender: Any) {
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "AppSetting") as! AppSetting
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBOutlet weak var btnPhotoTip: UIButton!
    @IBAction func btnPhotoTip(_ sender: Any) {
        let vc = sbAppSetting.instantiateViewController(withIdentifier: "EditProfile") as! EditProfile
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBOutlet weak var btnMyDate: UIButton!
    @IBAction func btnMyDate(_ sender: Any) {
        let vc = sbHome.instantiateViewController(withIdentifier: "PackagePlan") as! PackagePlan
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func viewDidLoad() {
        lblName.text = userProfile.username
        if userImage != "" {
            imgvUser.loadImage(urlString: userImage)
        }
        btnMyDate.setButtonCornorRadius()
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

// MARK: - IndicatorInfoProvider for page controller like android
extension Account: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
       // let itemInfo = IndicatorInfo(title: "Account")
        let itemInfo = IndicatorInfo(image: UIImage(named: "accountUser"))
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Account")
        return itemInfo
    }
}
