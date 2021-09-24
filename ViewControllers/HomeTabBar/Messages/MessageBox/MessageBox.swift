//
//  MessageBox.swift
//  DateAfrica
//
//  Created by Apple on 01/01/2021.
//

import UIKit
import RSKGrowingTextView
import RSKKeyboardAnimationObserver
import RSKKeyboardAnimationObserver
import DropDown


class MessageBox: UIViewController {
    
    var userChat = [UserChat]()
    
    var targetId = ""
    var targetName = ""
    var isOnline = ""
    var targetToken = ""
    var targetImage = UIImage()
    var ifUserBlock = false
    private var isVisibleKeyboard = true
    var dataarray = [""]
    var blockArray = ["Block"]
    var unBlockArray = ["Unblock"]

    
    let dropDown = DropDown()
    var userProfileModel: UserProfile.UserProfileModel! = nil

    
    
    @IBOutlet weak var bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgvSend: UIImageView!
    @IBOutlet weak var tablev: UITableView!
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    
    @IBOutlet weak var txtvMsg: RSKGrowingTextView!
    @IBOutlet weak var navbar: UIView!
    @IBOutlet weak var imgvUser: UIImageView!
    @IBOutlet weak var imgvBack: UIImageView!
    @IBOutlet weak var imgvStatus: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        //funUserProfileDetails()
    }
    override func viewWillDisappear(_ animated: Bool) {
        fbMessagesDB.removeAllObservers()
    }
    var lastmessage = ""
    
    
    @IBAction func btnSend(_ sender: Any) {
//        print(txtvMsg.text!.containsBadWord())
//        print(txtvMsg.text!.containsBadWord())
        let trimmedString = txtvMsg.text.trimmingCharacters(in: .whitespaces)
        if trimmedString.count == 0 || txtvMsg.text == "Write a message..." {
            
        }
        else {
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "HH:mm:ss a"
            let dateString = df.string(from: date)
            
            let tempChat = ["dateandtime":dateString, "from":Int(userProfile.userid) as Any, "isseen":false, "msg":txtvMsg.text!, "to":targetId] as [String : Any]
            
            lastmessage = txtvMsg.text!.containsBadWord()
            fbMessagesDB.childByAutoId().setValue(lastmessage)
            txtvMsg.text = nil
            DispatchQueue.main.async {
                self.funSendMessageAPI()
            }
        }
    }
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var btnProfilePic: UIButton!
    @IBAction func btnProfilePic(_ sender: Any) {
        let vc = sbHome.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
        vc.userid = targetId
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var btnDots: UIButton!
    @IBAction func btnDots(_ sender: Any) {
        dropDown.direction = .bottom
        dropDown.width = 140
        self.dropDown.anchorView = btnDots
        if ifUserBlock {
            dataarray = unBlockArray
            
        }
        else {
            dataarray = blockArray
        }
        
        dropDown.dataSource = dataarray
        dropDown.show()
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.dropDown.hide()
            //MARK:-
            switch self.dataarray[index] {
                
            case "Block":
                DispatchQueue.main.async {
                    self.funBlockUnblockUser(status: "Block")
                }
                ifUserBlock = true
                break
            case "Unblock":
                DispatchQueue.main.async {
                    self.funBlockUnblockUser(status: "UnBlock")
                }
                ifUserBlock = false
                break
            
            default:
                print("no match")
                break
            }
        }
    }
   
    @IBOutlet weak var btnProfile: UIButton!
    @IBAction func btnProfile(_ sender: Any) {
        let vc = sbHome.instantiateViewController(withIdentifier: "UserProfile") as! UserProfile
        vc.userid = targetId
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        txtvMsg.delegate = self
        imgvUser.circle()
        imgvStatus.circle()
        imgvUser.image = targetImage
        lblname.text = targetName
        lblstatus.text = isOnline
        if isOnline == "Online" {
            imgvStatus.backgroundColor = .green
        }
        else {
            imgvStatus.backgroundColor = .lightGray
        }
        funUserBlockStatus()
        tablev.registerCell(cellName: "ChatSendCell")
        tablev.registerCell(cellName: "ChatReceiveCell")
        funRetreiveChat()
        addDoneButtonOnKeyboard()
        DispatchQueue.main.async {
            self.txtvMsg.layer.cornerRadius = self.txtvMsg.frame.size.height / 2
            DispatchQueue.main.async {
                self.txtvMsg.backgroundColor = .white
                self.txtvMsg.clipsToBounds = true
            }
        }
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func funMessageSent() {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss a"
        let dateString = df.string(from: date)
        
        //let tempChat = MessageBox.UserChat(data: ["dateandtime":dateString, "from":userProfile.userid, "isseen":false, "msg":txtvMsg.text!, "to":targetId])
       //hi userChat.append(tempChat)
        txtvMsg.text = nil
        tablev.reloadData()
    }
    
    
    func funUserBlockUnblock() {
        DispatchQueue.main.async {
            if self.ifUserBlock {
                self.btnSend.isHidden = true
                self.imgvSend.isHidden = true
                self.txtvMsg.isUserInteractionEnabled = false
                self.txtvMsg.text = "You cannot chat with this user"
            }
            else {
                self.btnSend.isHidden = false
                self.imgvSend.isHidden = false
                self.txtvMsg.isUserInteractionEnabled = true
                self.txtvMsg.text = "Write a message..."
            }
        }
    }
    
    func funFillDataInFields() {
        //lblstatus.text = userProfileModel.userstatus == "true" ?? "" : ""
       // print(userProfileModel)
       // print(userProfileModel)

    }
    

    // MARK: - Helper Methods
    private func adjustContent(for keyboardRect: CGRect) {
        let keyboardHeight = keyboardRect.height + 10
        self.bottomLayoutGuideTopAndGrowingTextViewBottomVeticalSpaceConstraint.constant = self.isVisibleKeyboard ? keyboardHeight - self.bottomLayoutGuide.length : 10.0
        self.view.layoutIfNeeded()
    }
    
    private func registerForKeyboardNotifications() {
        self.rsk_subscribeKeyboardWith(beforeWillShowOrHideAnimation: nil,
                                       willShowOrHideAnimation: { [unowned self] (keyboardRectEnd, duration, isShowing) -> Void in
                                        self.isVisibleKeyboard = isShowing
                                        self.adjustContent(for: keyboardRectEnd)
            }, onComplete: { (finished, isShown) -> Void in
                self.isVisibleKeyboard = isShown
               // let indexPath = IndexPath(row: self.arrMsgType.count-1, section: 0)
                //self.scrolltobottom(indexpath: indexPath)
        }
        )
        
        self.rsk_subscribeKeyboard(willChangeFrameAnimation: { [unowned self] (keyboardRectEnd, duration) -> Void in
            self.adjustContent(for: keyboardRectEnd)
            }, onComplete: nil)
    }
    
    private func unregisterForKeyboardNotifications() {
        self.rsk_unsubscribeKeyboard()
    }
    
   
    func funRetreiveChat() {
        
//        fbMessagesDB.observeSingleEvent(of: .value, with: {
//            (snapshot) in
//            let value = snapshot.value as? NSDictionary
//            //print(value)
//            let data = value.map({$0.allValues})! as NSArray
//            _ = data.map({tempRecord in
//                let record = UserChat(data: tempRecord as! NSDictionary)
//                if record.from == userProfile.userid && record.to == self.targetId {
//                    self.userChat.append(record)
//                }
//                else if record.to == self.targetId && record.from == userProfile.userid {
//                    self.userChat.append(record)
//                }
//            })
//            //result = result.filter { $0 != nil }
//            print(self.userChat)
//            if self.userChat.count > 0 {
//                self.tablev.reloadData()
//            }
//            self.andicator.stopAnimating()
//        })
//        { (error) in
//            print(error.localizedDescription)
//        }
        //andicator.startAnimating()
        fbMessagesDB.observe(.childAdded, with: {
            (snapshot) in
            self.andicator.stopAnimating()
            let value = snapshot.value as? NSDictionary
            let record = UserChat(data: value!)
            let indexPath = IndexPath(row: self.userChat.count, section: 0)
            if record.from == userProfile.userid && record.to == self.targetId {
                self.userChat.append(record)
                self.tablev.insertRows(at: [indexPath], with: .none)
            }
            else if record.to == self.targetId && record.from == userProfile.userid {
                self.userChat.append(record)
                self.tablev.insertRows(at: [indexPath], with: .none)
            }
            self.scrolltobottom(indexpath: indexPath)
        })
        { (error) in
            print(error.localizedDescription)
            self.andicator.stopAnimating()
        }
    }

    //MARK:- Function table view scroll to bottom
    func scrolltobottom(indexpath: IndexPath) {
        if indexpath.row < 1 {
            return
        }
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: indexpath.row-1, section: indexpath.section)
            self.tablev.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0); //values
            self.tablev.scrollToRow(at: indexPath, at: .bottom, animated: true)
            DispatchQueue.main.async{
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                    self.tablev.isHidden = false
                }
            }
        }
    }
}


extension MessageBox: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if userChat[indexPath.row].from == userProfile.userid {
            let cell = tablev.dequeueReusableCell(withIdentifier: "ChatSendCell") as! ChatSendCell
            cell.lblmsg.text = userChat[indexPath.row].msg
            cell.lbltime.text = userChat[indexPath.row].dateandtime
            return cell
        }
        else {
            let cell = tablev.dequeueReusableCell(withIdentifier: "ChatReceiveCell") as! ChatReceiveCell
            cell.lblmsg.text = userChat[indexPath.row].msg
            cell.lbltime.text = userChat[indexPath.row].dateandtime
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userChat.count
    }
}

extension MessageBox: UITextViewDelegate {
    //MARK:- Textview Delegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            //textView.resignFirstResponder()
            textView.text = textView.text + "\n"
            return false
        }
        //Remove first white space
        if textView.text.count == 0 && text == " "{
            return false
        }
        let string = text
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            if textView.text.count > 0{
                //textView.text!.removeLast()
            }
            
            if text.count == 0 {
               
            }
            return true
        }
        
        let newLength = string.count
        if newLength == 0 {
            
            let trimmedString = string.trimmingCharacters(in: .whitespaces)
            if (trimmedString.count > 0) {
               
            }
            else {
                
            }
            //SendAlert(text : "TypingStop", title: "TypingStop", content_type: true)
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write a message..." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let trimmedString = textView.text.trimmingCharacters(in: .whitespaces)

        if textView.text == nil && trimmedString.count == 0 {
            textView.text = "Write a message..."
            textView.textColor = .lightGray
        }
    }
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Return", style: .done, target: self, action: #selector(self.returnButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        txtvMsg.inputAccessoryView = doneToolbar
    }
    @objc func returnButtonAction() {
        self.view.endEditing(true)
    }
}



