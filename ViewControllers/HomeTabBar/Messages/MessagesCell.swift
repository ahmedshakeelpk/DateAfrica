//
//  HomeCell.swift
//  DateAfrica
//
//  Created by Apple on 10/12/2020.
//

import UIKit

class MessagesColvCell: UICollectionViewCell {

    @IBOutlet weak var bgv: UIView!
    @IBOutlet weak var imgv: UIImageView!
    
    @IBOutlet weak var imgvOnlineStatus: UIImageView!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            
            self.imgvOnlineStatus.circle()
            DispatchQueue.main.async {
                //self.bgv.circle()
                self.imgv.circle()
            }
        }
    }

}

class MessagesCell: UITableViewCell {

    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        imgv.circle()
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
