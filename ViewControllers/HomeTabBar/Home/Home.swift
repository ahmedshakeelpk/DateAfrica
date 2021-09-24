//
//  Home.swift
//  DateAfrica
//
//  Created by Apple on 09/12/2020.
//

import UIKit
import XLPagerTabStrip
import Shuffle_iOS
import PopBounceButton

class Home: UIViewController {
    
    var PID = 0
    
    @IBOutlet weak var andicator: UIActivityIndicatorView!
    var userRecord: [UsersRecord] = []
    private let cardStack = SwipeCardStack()

      let cardImages = [
          UIImage(named: "home"),
          UIImage(named: "like"),
          UIImage(named: "messages")
      ]
    
    var cardModels = [
        
    TinderCardModel(name: "Michelle",
                           age: 26,
                           occupation: "Graphic Designer",
                           image: UIImage(named: "michelle")),
        TinderCardModel(name: "Michelle",
                        age: 26,
                        occupation: "Graphic Designer",
                        image: UIImage(named: "michelle")),
        TinderCardModel(name: "Joshua",
                        age: 27,
                        occupation: "Business Services Sales Representative",
                        image: UIImage(named: "joshua")),
        TinderCardModel(name: "Daiane",
                        age: 23,
                        occupation: "Graduate Student",
                        image: UIImage(named: "daiane")),
        TinderCardModel(name: "Julian",
                        age: 25,
                        occupation: "Model/Photographer",
                        image: UIImage(named: "julian")),
        TinderCardModel(name: "Andrew",
                        age: 26,
                        occupation: nil,
                        image: UIImage(named: "andrew")),
        TinderCardModel(name: "Bailey",
                        age: 25,
                        occupation: "Software Engineer",
                        image: UIImage(named: "bailey")),
        TinderCardModel(name: "Rachel",
                        age: 27,
                        occupation: "Interior Designer",
                        image: UIImage(named: "rachel"))
      ]
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        
        self.andicator.startAnimating()
        self.view.setEmojiMessage(msg: "No Profile Avalible", icon: "home")
        cardStack.delegate = self
        cardStack.dataSource = self
        buttonStackView.delegate = self
        self.funFetchHomeRecord()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
//    public void onDataChange(@NonNull DataSnapshot snapshot) {
////
//        for ( DataSnapshot shot : snapshot.getChildren()) {
//                        if (shot.child("to").getValue().toString().equals(currrentuserid) &&
//                                shot.child("from").getValue().toString().equals(userid)) {
//                            HashMap<String, Object> hashMap = new HashMap<>();
//                            hashMap.put("isseen", true);
//                            shot.getRef().updateChildren(hashMap);
//                        }
//                    }
//                }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func funLoadData() {
        cardModels = [TinderCardModel]()
        self.cardStack.reloadData()
        DispatchQueue.main.async {
            var tempcardModels = [TinderCardModel]()
            for (index, data) in self.userRecord.enumerated() {
                var image = UIImage()
                loadImageFromUrl(urlString: data.userimages, completionHandler: { [self]
                    responseImage in
                    image = responseImage
                    tempcardModels.append(TinderCardModel(name: data.username,
                                                      age: Int(data.userage) ?? 0,
                                                      occupation: data.gender,
                                                      image:  image))
                    
                    if index == userRecord.count - 1 {
                        self.configureNavigationBar()
                        self.layoutButtonStackView()
                        self.layoutCardStackView()
                        self.configureBackgroundGradient()
                        cardModels = [TinderCardModel]()
                        self.cardStack.reloadData()
                        cardModels = tempcardModels
                        self.andicator.stopAnimating()
                        DispatchQueue.main.async {
                            self.cardStack.reloadData()
                        }
                    }
                    else {
                        cardModels = tempcardModels
                    }
                })
                if self.userRecord.count == 0 {
                    self.andicator.stopAnimating()
                }
            }
        }
//        self.cardStack.bringSubviewToFront(andicator)
//        self.buttonStackView.bringSubviewToFront(andicator)
      //  self.view.bringSubviewToFront(andicator)
    }
    
    private let buttonStackView = ButtonStackView()

    
    private func configureNavigationBar() {
      let backButton = UIBarButtonItem(title: "Back",
                                       style: .plain,
                                       target: self,
                                       action: #selector(handleShift))
      backButton.tag = 1
      backButton.tintColor = .lightGray
      navigationItem.leftBarButtonItem = backButton

      let forwardButton = UIBarButtonItem(title: "Forward",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleShift))
      forwardButton.tag = 2
      forwardButton.tintColor = .lightGray
      navigationItem.rightBarButtonItem = forwardButton

      navigationController?.navigationBar.layer.zPosition = -1
    }

    private func configureBackgroundGradient() {
      let backgroundGray = UIColor(red: 244 / 255, green: 247 / 255, blue: 250 / 255, alpha: 1)
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [UIColor.white.cgColor, backgroundGray.cgColor]
      gradientLayer.frame = view.bounds
      view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func layoutButtonStackView() {
      view.addSubview(buttonStackView)
      buttonStackView.anchor(left: view.safeAreaLayoutGuide.leftAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             right: view.safeAreaLayoutGuide.rightAnchor,
                             paddingLeft: 24,
                             paddingBottom: 12,
                             paddingRight: 24)
    }

    private func layoutCardStackView() {
      view.addSubview(cardStack)
        
        cardStack.translatesAutoresizingMaskIntoConstraints = false

        cardStack.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                         left: self.view.safeAreaLayoutGuide.leftAnchor,
                       bottom: buttonStackView.topAnchor,
                       right: self.view.safeAreaLayoutGuide.rightAnchor)
    }

    @objc
    private func handleShift(_ sender: UIButton) {
      cardStack.shift(withDistance: sender.tag == 1 ? -1 : 1, animated: true)
    }
    func card(fromImage image: UIImage) -> SwipeCard {
      let card = SwipeCard()
      card.swipeDirections = [.left, .right]
      card.content = UIImageView(image: image)
      
      let leftOverlay = UIView()
      leftOverlay.backgroundColor = .green
      
      let rightOverlay = UIView()
      rightOverlay.backgroundColor = .red
      
      card.setOverlays([.left: leftOverlay, .right: rightOverlay])
      
      return card
    }

}


//extension Home: SwipeCardStackDataSource, SwipeCardStackDelegate {
//    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
//        return card(fromImage: cardImages[index]!)
//    }
//
//    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
//      return cardImages.count
//    }
//
//    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
//        let vc = HomeSB.instantiateViewController(withIdentifier: "ProfileDetails") as! ProfileDetails
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
// MARK: - IndicatorInfoProvider for page controller like android
extension Home: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        //let itemInfo = IndicatorInfo(title: "home")
        let itemInfo = IndicatorInfo(image: UIImage(named: "home"))
        return itemInfo
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        //let itemInfo = IndicatorInfo(title: "Home")
        var itemInfo = IndicatorInfo(image: UIImage(named: "like"))

       // itemInfo.image? = UIImage(named: "home")!.withRenderingMode(.alwaysTemplate).withTintColor(tabBarHomeIconColor)

        return itemInfo
    }
}
struct TinderCardModel {
  let name: String
  let age: Int
  let occupation: String?
  let image: UIImage?
}


extension Home: ButtonStackViewDelegate, SwipeCardStackDataSource, SwipeCardStackDelegate {

  func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
    let card = SwipeCard()
    card.footerHeight = 80
    card.swipeDirections = [.left, .up, .right]
    for direction in card.swipeDirections {
      card.setOverlay(TinderCardOverlay(direction: direction), forDirection: direction)
    }

    let model = cardModels[index]
    card.content = TinderCardContentView(withImage: model.image)
    card.footer = TinderCardFooterView(withTitle: "\(model.name), \(model.age)", subtitle: model.occupation)

    
    return card
  }

  func numberOfCards(in cardStack: SwipeCardStack) -> Int {
    return cardModels.count
  }

  func didSwipeAllCards(_ cardStack: SwipeCardStack) {
    print("Swiped all cards!")
  }

  func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
    print("Undo \(direction) swipe on \(cardModels[index].name)")
  }

  func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
    //MARK:- Swipe Right Like
    print("Swiped \(direction) on \(cardModels[index].name)")
    if direction == .left {
        self.funLikeCard(userId: userRecord[index].userid, type: "Reject")
    }
    else if direction == .right {
        self.funLikeCard(userId: userRecord[index].userid, type: "Like")
    }
    if userRecord.count - 1 == index {
        PID += 1
        DispatchQueue.main.async {
            self.funFetchHomeRecord()
        }
    }
  }

  func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
    print("Card tapped")
  }

  func didTapButton(button: TinderButton) {
    switch button.tag {
    case 1:
      cardStack.undoLastSwipe(animated: true)
    case 2:
      cardStack.swipe(.left, animated: true)
        self.funLikeCard(userId: userRecord[cardStack.topCardIndex!].userid, type: "Reject")
    case 3:
      cardStack.swipe(.up, animated: true)
    case 4:
        //MARK:- Swipe Right Like
        cardStack.swipe(.right, animated: true)
        self.funLikeCard(userId: userRecord[cardStack.topCardIndex!].userid, type: "Like")
    case 5:
      cardStack.reloadData()
    default:
      break
    }
  }
}




