//
//  HomeExtension.swift
//  DateAfrica
//
//  Created by Apple on 10/12/2020.
//

import UIKit


//MARK:- Collection View
extension Messages: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tablev.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
        cell.lblName.text = matchUsersRecord[indexPath.row].username
        cell.imgv.loadImage(urlString: matchUsersRecord[indexPath.row].userimages)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! MessagesCell
        
        let vc = sbMessaging.instantiateViewController(withIdentifier: "MessageBox") as! MessageBox
        vc.targetId = matchUsersRecord[indexPath.row].userid
        vc.targetName = matchUsersRecord[indexPath.row].username
        vc.targetImage = cell.imgv.image ?? UIImage(named: "user")!

        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
//MARK:- Collection View
extension Messages: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchUsersRecord.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessagesColvCell", for: indexPath) as! MessagesColvCell
        
        cell.imgv.loadImage(urlString: matchUsersRecord[indexPath.row].userimages)
        cell.imgvOnlineStatus.backgroundColor = (matchUsersRecord[indexPath.row].offlineonline) == "true" ? UIColor.green : UIColor.lightGray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView.tag == 1 {
            let cellsAcross: CGFloat = 2.5
            let spaceBetweenCells: CGFloat = 1
            let dim = (collectionView.bounds.height)
            return CGSize(width: dim, height: dim)
//        }
//        else {
//            let cellsAcross: CGFloat = 7
//            let spaceBetweenCells: CGFloat = 1
//            let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
//            return CGSize(width: dim, height: dim+20)
//        }
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MessagesColvCell

        let vc = sbMessaging.instantiateViewController(withIdentifier: "MessageBox") as! MessageBox
        vc.targetId = matchUsersRecord[indexPath.row].userid
        vc.targetName = matchUsersRecord[indexPath.row].username
        vc.targetImage = cell.imgv.image ?? UIImage(named: "user")!
        vc.isOnline = (matchUsersRecord[indexPath.row].offlineonline) == "true" ? "Online" : "Offline"
        vc.targetToken = matchUsersRecord[indexPath.row].usrtokn
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}



extension String {
    func containsBadWord()->String {
        //Sorry for bad words
        let badWords = ["fuck","fuckyou","son of bitch","piss off","Asshole", "Son of a bitch", "Son of a b*tch", "Dick head", "Bastard"]
        var aString = self
        for word in badWords {
            if lowercased().contains(word) {
                aString = (aString.lowercased()).replacingOccurrences(of: word.lowercased(), with: "***", options: .literal, range: nil)
            }
        }
        return aString
    }

}
