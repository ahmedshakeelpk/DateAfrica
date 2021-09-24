//
//  ChatReceiveCell.swift
//  ZedChat
//
//  Created by MacBook Pro on 28/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
let appclrOtherMessageBg = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0)
let appclrOwnMessageBg = UIColor(red: 8/255, green: 127/255, blue: 255/255, alpha: 1.0)
let MESSAGECELL_RADIUS = CGFloat(6)

class ChatReceiveCell: UITableViewCell {

    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var vbg: UIImageView!
    @IBOutlet weak var vselection: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vbg.layer.cornerRadius = MESSAGECELL_RADIUS
        vbg.backgroundColor = appclrOtherMessageBg
        vselection.backgroundColor = appclrOwnMessageBg
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
