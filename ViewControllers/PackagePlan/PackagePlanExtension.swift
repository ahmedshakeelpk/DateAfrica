//
//  PackagePlanExtension.swift
//  DateAfrica
//
//  Created by Apple on 23/12/2020.
//

import Foundation
import UIKit
import Stripe

extension PackagePlan: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, STPAddCardViewControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let numberofItem: CGFloat = 4

        let collectionViewWidth = self.colv.bounds.width

        let extraSpace = (numberofItem - 1) * flowLayout.minimumInteritemSpacing

        let inset = flowLayout.sectionInset.right + flowLayout.sectionInset.left

        let width = Int((collectionViewWidth - extraSpace - inset) / numberofItem)

        print(width)

        return CGSize(width: width, height: width+50)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ShortVideoListHeader

            header.titleLabel.text = arrHeaderTitle[indexPath.section]
            header.setNeedsLayout()
            return header

        default:
            return UICollectionReusableView()
        }
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
            let temp = packages.filter{$0.packgetype == "Basic"}
            return temp.count
        }
        else if section == 1 {
            return 2
            let temp = packages.filter{$0.packgetype == "Silver"}
            return temp.count
        }
        else {
            return 0
            let temp = packages.filter({$0.packgetype == "Gold"})
            return temp.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackagePlanCell", for: indexPath) as! PackagePlanCell
        
        cell.layer.cornerRadius = 4
        cell.layer.borderWidth = 1
        cell.clipsToBounds = true
        cell.layer.borderColor = tabBarHomeIconColor.cgColor
        if selectedCell == indexPath {
            cell.contentView.backgroundColor = tabBarHomeIconColor
        }
        else {
            cell.contentView.backgroundColor = .white
        }
        var record = [packages[indexPath.row]]
        
        if indexPath.section == 0 {
            record = packages.filter{$0.packgetype == "Basic"}
        }
        else if indexPath.section == 1 {
            record = packages.filter{$0.packgetype == "Silver"}
        }
        else {
            record = packages.filter({$0.packgetype == "Gold"})
        }
        //let record = packages[indexPath.section]
        cell.lblTime.text = record[indexPath.row].pckgeduration
        cell.lblPrice.text = record[indexPath.row].pckgeprice
        cell.lblBundles.text = record[indexPath.row].packgetype        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = indexPath
        colv.reloadData()
        if !isSubscribeButton {
            let btnSubscribe = UIBarButtonItem(title: "Subscribe", style: .plain, target: self, action: #selector(funSubscribe))

            navigationItem.rightBarButtonItems = [btnSubscribe]
        }
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {

    }

    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: (Error?) -> Void) {
        
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        funActivePackage(stripeToken: paymentMethod.stripeId)
    }

    func funStripe() {
        STPAPIClient.shared.publishableKey = "pk_test_51HrgTJH5To6tLv9NMMALY6I95AXzCA85DvX6fdWh994PBa9H8L2FL1h2mPM6St5v0vFaTB0WA3ErDrB8w2I8lvog00H3fXw6SK"
        //StripeAPI.defaultPublishableKey =
        
        
        let config = STPPaymentConfiguration()
        config.requiredBillingAddressFields = .none
        let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.default())
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    fileprivate func createPayment(token: String, amount: Float) {

    //        AF.request(paymentURL, method: .post, parameters: ["stripeToken": token, "amount": amount * 100],encoding: JSONEncoding.default, headers: nil).responseString {
    //            response in
    //            switch response.result {
    //            case .success:
    //                print("Success")
    //
    //                break
    //            case .failure(let error):
    //
    //                print("Failure")
    //            }
    //        }
    }
}

class ShortVideoListHeader: UICollectionReusableView {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame.origin = CGPoint(x: 15, y: 25) // navigationBar's height is 64
        titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        titleLabel.sizeToFit()
    }
}


