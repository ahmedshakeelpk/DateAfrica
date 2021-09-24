//
//  UserProfile.swift
//  DateAfrica
//
//  Created by Apple on 29/12/2020.
//

import UIKit
import Cosmos

class UserProfile: UIViewController {

    var userRating = "0.0"
    var userProfileModel: UserProfileModel! = nil
    var userPicturesModel = [UserPicturesModel]()
    
    @IBOutlet weak var ratingView: CosmosView!
    var userid = ""
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var scrollv: UIScrollView!
    @IBOutlet weak var contentv: UIView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var txtvAbout: UITextView!
    
    @IBOutlet weak var btnReport: UIButton!
    @IBAction func btnReport(_ sender: Any) {
        let vc = sbHome.instantiateViewController(withIdentifier: "ReportUser") as! ReportUser
        vc.userName = userProfileModel.username
        vc.userid = userProfileModel.userid
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBOutlet weak var btnRate: UIButton!
    @IBAction func btnRate(_ sender: Any) {
        let vc = sbHome.instantiateViewController(withIdentifier: "RateUser") as! RateUser
        vc.userName = userProfileModel.username
        vc.userid = userProfileModel.userid
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
        self.title = "Profile"
        colv.registerCell(cellName: "ProfileDetailsCell")
        funGetUserPictures()
        funUserRating()
        funUserProfileDetails()
        
        txtvAbout.isUserInteractionEnabled = false
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func funFillDataInFields() {
        DispatchQueue.main.async {
            self.txtvAbout.text = self.userProfileModel.aboutuser
            self.lblName.text = self.userProfileModel.username
            self.lblGender.text = "Gender: " + self.userProfileModel.gender
            self.lblJob.text = "Job: " + self.userProfileModel.jobtitle
            self.lblSchool.text = "School: " + self.userProfileModel.school
            self.lblCompany.text = "Company: " + self.userProfileModel.company
            //self.pagecontrol.numberOfPages = userProfileModel
        }
    }
    
    func funLoadPictureData() {
        colv.reloadData()
        pagecontrol.numberOfPages = userPicturesModel.count
    }

}

extension UserProfile: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let numberofItem: CGFloat = 1

        let collectionViewWidth = self.colv.bounds.width

        let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing

        let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left

        let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)

        print(width)

        return CGSize(width: width, height: width+50)
    }

    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPicturesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileDetailsCell", for: indexPath) as! ProfileDetailsCell
                
        cell.layer.cornerRadius = 4
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.layer.borderColor = tabBarHomeIconColor.cgColor
        cell.imgv.loadImage(urlString: userPicturesModel[indexPath.row].imagename)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedCell = indexPath
        colv.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.colv.contentOffset, size: self.colv.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.colv.indexPathForItem(at: visiblePoint) {
            self.pagecontrol.currentPage = visibleIndexPath.row
        }
    }
}
