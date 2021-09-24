//
//  Messages.swift
//  DateAfrica
//
//  Created by Apple on 09/12/2020.
//

import UIKit
import XLPagerTabStrip

class Messages: UIViewController {
    
    
    var matchUsersRecord: [MatchUsersRecord] = []
    var chatUser = [ChatUsers]()
    let arrImages = ["home", "like", "messages", "account"]
    @IBOutlet weak var lblNoProfile: UILabel!

    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var tablev: UITableView!
    override func viewDidLoad() {
        self.lblNoProfile.setEmojiInLabel(msg: "Say Hello!\nTap on a new match above to send a message", icon: "messages")
        

        tablev.tableFooterView = UIView()
        colv.registerCell(cellName: "MessagesColvCell")
        tablev.registerCell(cellName: "MessagesCell")
        tablev.registerCell(cellName: "ChatSendCell")
        tablev.registerCell(cellName: "ChatReceiveCell")
        tablev.registerCell(cellName: "MessageTablevCell")
        funMatchUserRecord()
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        funChatUsers()
    }
    
    func funChatUsers() {
        funChatUsersApi(url: URLs.urlChatUsers, completionHandler: {
            success in
            if success {
                
            }
        })
    }
    
    
}
// MARK: - IndicatorInfoProvider for page controller like android
extension Messages: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        //let itemInfo = IndicatorInfo(title: "Messages")
        let itemInfo = IndicatorInfo(image: UIImage(named: "messages"))
        return itemInfo
    }
    
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let itemInfo = IndicatorInfo(title: "Messages")
        return itemInfo
    }
}
