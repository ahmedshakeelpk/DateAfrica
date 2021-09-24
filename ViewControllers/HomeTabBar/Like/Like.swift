//
//  Like.swift
//  DateAfrica
//
//  Created by Apple on 09/12/2020.
//

import UIKit
import XLPagerTabStrip

class Like: UIViewController {

    var usersLikes = [UsersLikes]()
    var topPicks = [TopPicks]()
    @IBOutlet weak var lblNoProfile: UILabel!
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var segcLikeTopPicks: UISegmentedControl!
    @IBOutlet weak var andicator: UIActivityIndicatorView!

    @IBAction func segcLikeTopPicks(_ sender: Any) {
        
        if self.segcLikeTopPicks.selectedSegmentIndex == 1 {
            self.lblNoProfile.setEmojiInLabel(msg: "No Top Picks your profile till now", icon: "like")
            self.usersLikes.removeAll()
            self.colv.reloadData()
            self.colv.tag = 1
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.funFetchTopPicks()
                }
            }
        }
        else {
            self.lblNoProfile.setEmojiInLabel(msg: "No one Like your profile till now", icon: "like")
            self.topPicks.removeAll()
            self.colv.reloadData()
            self.colv.tag = 0
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    self.funFetchWhoLikesMe()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        self.lblNoProfile.setEmojiInLabel(msg: "No one like your profile till now", icon: "like")
        colv.tag = 0
        colv.registerCell(cellName: "LikeCell")
        funFetchWhoLikesMe()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func funReloadColView() {
        DispatchQueue.main.async {
            self.andicator.stopAnimating()
            self.colv.isHidden = false
            self.colv.reloadData()
        }
    }
   

}

// MARK: - IndicatorInfoProvider for page controller like android
extension Like: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        //let itemInfo = IndicatorInfo(title: "Like")
        
        let itemInfo = IndicatorInfo(image: UIImage(named: "like"))
        return itemInfo
        
        
        
    }
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Like")
        return itemInfo
    }
    
    
    
    
}
