//
//  LikeExtension.swift
//  DateAfrica
//
//  Created by Apple on 28/12/2020.
//

import Foundation
import UIKit

//MARK:- Collection View
extension Like: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return usersLikes.count
        }
        else {
            return topPicks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeCell", for: indexPath) as! LikeCell
        cell.imgv.image = nil
        if collectionView.tag == 0 {
            cell.imgv.loadImage(urlString: usersLikes[indexPath.row].usrimg)
            cell.lblName.text = usersLikes[indexPath.row].usrname
        }
        else {
            cell.imgv.loadImage(urlString: topPicks[indexPath.row].userimages)
            cell.lblName.text = topPicks[indexPath.row].username
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width/2) - 10, height: (collectionView.bounds.width/2) + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = sbHome.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
        if colv.tag == 0 {
            vc.userid = usersLikes[indexPath.row].usrid
        }
        else {
            vc.userid = topPicks[indexPath.row].userid
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


