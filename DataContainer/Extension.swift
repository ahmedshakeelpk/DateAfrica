//
//  Extension.swift
//  DateAfrica
//
//  Created by Apple on 07/12/2020.
//

import Foundation
import UIKit
import Kingfisher

extension UITextField {
    func setRound() {
        self.setBottomShade()
        self.layer.cornerRadius = self.frame.height / 2
        
    }
}
extension UIView {
    public func setBottomShade() {
        let shadeColor = UIColor(red: 228.0/255, green: 228.0/255, blue: 228.0/255, alpha: 1.0)
        //view.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderColor = shadeColor.cgColor
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        //MARK:- Shade a view
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.clipsToBounds = true
    }
    
    public func setButtonCornorRadius() {
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.clipsToBounds = true
    }
    
    func setEmojiMessage(msg: String, icon: String){
        let noDataLabel = UILabel()
        noDataLabel.numberOfLines = 0
        noDataLabel.lineBreakMode = .byWordWrapping
        noDataLabel.textAlignment = .center
        noDataLabel.text = msg
        noDataLabel.tag = 9999
        self.tag = 9999
        
        let fullString = NSMutableAttributedString(string: msg+"\n")
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: icon)
        image1Attachment.bounds = CGRect(x: 0, y: -7, width: 25, height: 25)
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: ""))

        // draw the result in a label
        noDataLabel.attributedText = fullString
        noDataLabel.sizeToFit()
        noDataLabel.center = self.center
        
        self.addSubview(noDataLabel)
    }
    
    func removeEmoji() {
        if self.viewWithTag(9999) != nil {
            self.removeFromSuperview()
        }
    }
    
    
    
}
extension UITableView {
    func emptyMessage(msg: String, icon: String){
        let noDataLabel = UILabel()
        noDataLabel.textAlignment = .center
        noDataLabel.text = msg
        noDataLabel.tag = 9999
        noDataLabel.center = self.center
        self.backgroundView = noDataLabel
    }
    
    func recordFound() {
        if self.viewWithTag(9999) != nil {
            self.backgroundView = nil
        }
    }    
    
    func registerCell(cellName:String) {
        self.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
     
}


extension UICollectionView {
    func registerCell(cellName:String) {

        self.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)

    }
}
extension UIView {
    func circle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
}


//For Tinder Card
extension UIView {

  @discardableResult
  func anchor(top: NSLayoutYAxisAnchor? = nil,
              left: NSLayoutXAxisAnchor? = nil,
              bottom: NSLayoutYAxisAnchor? = nil,
              right: NSLayoutXAxisAnchor? = nil,
              paddingTop: CGFloat = 0,
              paddingLeft: CGFloat = 0,
              paddingBottom: CGFloat = 0,
              paddingRight: CGFloat = 0,
              width: CGFloat = 0,
              height: CGFloat = 0) -> [NSLayoutConstraint] {
    translatesAutoresizingMaskIntoConstraints = false

    var anchors = [NSLayoutConstraint]()

    if let top = top {
      anchors.append(topAnchor.constraint(equalTo: top, constant: paddingTop))
    }
    if let left = left {
      anchors.append(leftAnchor.constraint(equalTo: left, constant: paddingLeft))
    }
    if let bottom = bottom {
      anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom))
    }
    if let right = right {
      anchors.append(rightAnchor.constraint(equalTo: right, constant: -paddingRight))
    }
    if width > 0 {
      anchors.append(widthAnchor.constraint(equalToConstant: width))
    }
    if height > 0 {
      anchors.append(heightAnchor.constraint(equalToConstant: height))
    }

    anchors.forEach { $0.isActive = true }

    return anchors
  }

  @discardableResult
  func anchorToSuperview() -> [NSLayoutConstraint] {
    return anchor(top: superview?.topAnchor,
                  left: superview?.leftAnchor,
                  bottom: superview?.bottomAnchor,
                  right: superview?.rightAnchor)
  }
}

extension UIView {

  func applyShadow(radius: CGFloat,
                   opacity: Float,
                   offset: CGSize,
                   color: UIColor = .black) {
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
    layer.shadowOffset = offset
    layer.shadowColor = color.cgColor
  }
}

extension UIImageView {
    func loadImage(urlString: String) {
        if let url = URL(string: BASEURLMEDIA + urlString) {
            let processor = DownsamplingImageProcessor(size: self.bounds.size)
                         |> RoundCornerImageProcessor(cornerRadius: 20)
            self.kf.indicatorType = .activity
            self.kf.setImage(
                with: url,
                placeholder: UIImage(named: "account"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ], completionHandler:
                    {
                        result in
                        switch result {
                        case .success(let value):
                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
                        case .failure(let error):
                            print("Job failed: \(error.localizedDescription)")
                        }
                    })
        }
        
        
        
    }
}


extension UILabel {
    func setEmojiInLabel(msg: String, icon: String) {
        let fullString = NSMutableAttributedString(string: msg+"\n")
        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: icon)
        image1Attachment.bounds = CGRect(x: 0, y: -7, width: 25, height: 25)
        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: ""))

        // draw the result in a label
        self.attributedText = fullString
        //self.sizeToFit()
        //self.center = self.center
        
    }
}
