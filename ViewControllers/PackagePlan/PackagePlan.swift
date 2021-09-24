//
//  PackagePlan.swift
//  DateAfrica
//
//  Created by Apple on 11/12/2020.
//

import UIKit
import Alamofire
import StoreKit


class PackagePlan: UIViewController {
    var isSubscribeButton = false
    var packages = [Packages]()
    var packageCurrent: PackageCurrent!
    
    var selectedCell = IndexPath()

    let arrHeaderTitle = ["Basic", "Silver", "Gold"]
    let arrMonthsBasic = ["1 Month", "3 Month", "6 Month", "12 Month"]
    let arrPriceBasic = ["$3.33", "$5.53", "$9.43", "$15.55"]
    let arrPackageBasic = ["Chat Only", "Chat Only", "Chat Only", "Chat Only"]
    
    let arrMonthsSilver = ["1 Month", "3 Month", "6 Month", "12 Month"]
    let arrPriceSilver = ["$3.33", "$5.53", "$9.43", "$15.55"]
    let arrPackageSilver = ["Chat Only", "Chat Only", "Chat Only", "Chat Only"]

    @IBOutlet weak var andicator: UIActivityIndicatorView!
    @IBOutlet weak var colv: UICollectionView!
    @IBOutlet weak var lblSubscibePackage: UILabel!
    @IBOutlet weak var lblPackageDetails: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        funShowPackages()
        funCurrentPackage()
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    let collectionViewLayout = UICollectionViewLayout()
    override func viewDidLoad() {

        title = "Get Data Africa Chat"
        colv.registerCell(cellName: "PackagePlanCell")
        
        colv.register(ShortVideoListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")

        colv.delegate = self
        
        colv.register(ShortVideoListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "header")

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        (colv.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    //Shakeel
    var arrProducts = [SKProduct]()
    var arrProductIDs = ["monthly01",
                         "basic3m",
                         "basic6months",
                         "basic1year",
                         "silvermonthly",
                         "silver3months",
                         "monthly01",
                         "basic3m",
                         "basic6months",
                         "basic1year",
                         "silvermonthly",
                         "silver3months"]
   
    func funIAP() {
        
       // andicator.startAnimating()
        PKIAPHandler.shared.setProductIds(ids: arrProductIDs)
        PKIAPHandler.shared.fetchAvailableProducts { [weak self](products)   in
            DispatchQueue.main.async {
                //self?.andicator.stopAnimating()
                DispatchQueue.main.async {
                    guard let sSelf = self else {return}
                    sSelf.arrProducts = products
                    self!.showActionSheet(sender: self!.view as Any)
                }
            }
        }
    }
    
    //Open Action Sheet for Camera and Gallery
    func showActionSheet(sender: Any) {
        
        var record = [packages[selectedCell.row]]
        if selectedCell.section == 0 {
            record = packages.filter{$0.packgetype == "Basic"}
        }
        else if selectedCell.section == 1 {
            record = packages.filter{$0.packgetype == "Silver"}
        }
        else {
            record = packages.filter({$0.packgetype == "Gold"})
        }

        let title = "Purchase Your Package For \(record[selectedCell.row].pckgeduration)"
        self.view.endEditing(true)
        
        let alert:UIAlertController=UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let btnPlayQuiz = UIAlertAction(title: "\(record[selectedCell.row].packgetype) (\(record[selectedCell.row].pckgeprice))", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.funPurchasePackage()
        }
        let btnNoThanks = UIAlertAction(title: "No Thanks", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(btnPlayQuiz)
        alert.addAction(btnNoThanks)
        // Present the controller
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = CGRect(x: (view.frame.width / 2) - 75, y: (view.frame.height/2)-200, width: 150, height: 200)
            alert.popoverPresentationController?.permittedArrowDirections = .down
        default:
            break
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func funPurchasePackage() {
        
        let index = (selectedCell.section + 1) * (selectedCell.row + 1) - 1
        print(self.arrProducts[index])
        if index > 5 {
            showAlert(controller: self, title: "", message: "Comming soon!")
        }
        PKIAPHandler.shared.purchase(product: self.arrProducts[index]) { (alert, product, transaction) in
            if let tran = transaction, let prod = product {
                //use transaction details and purchased product as you want
                //PKIAPHandler.canmak
                
            }
                //Globals.shared.showWarnigMessage(alert.message)
        }
    }
}

   //  PKIAPHandler.swift
   //
   //  Created by Pramod Kumar on 13/07/2017.
   //  Copyright © 2017 Pramod Kumar. All rights reserved.
   //

enum PKIAPHandlerAlertType: LocalizedError{
       case setProductIds
       case disabled
       case restored
       case purchased
       case noProductIDsFound
        case productRequestFailed
    
       var message: String{
           switch self {
           case .setProductIds: return "Product ids not set, call setProductIds method!"
           case .disabled: return "Purchases are disabled in your device!"
           case .restored: return "You've successfully restored your purchase!"
           case .purchased: return "You've successfully bought this purchase!"
           case .noProductIDsFound: return "No In-App Purchases were found."
           case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
           }
       }
   }


   class PKIAPHandler: NSObject {
       
       //MARK:- Shared Object
       //MARK:-
       static let shared = PKIAPHandler()
       private override init() { }
       
       //MARK:- Properties
       //MARK:- Private
       fileprivate var productIds = [String]()
       fileprivate var productID = ""
       fileprivate var productsRequest = SKProductsRequest()
       fileprivate var fetchProductComplition: (([SKProduct])->Void)?
       
       fileprivate var productToPurchase: SKProduct?
       fileprivate var purchaseProductComplition: ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?
       
       //MARK:- Public
       var isLogEnabled: Bool = true
       
       //MARK:- Methods
       //MARK:- Public
       
       //Set Product Ids
       func setProductIds(ids: [String]) {
           self.productIds = ids
       }

       //MAKE PURCHASE OF A PRODUCT
       func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
       
       func purchase(product: SKProduct, complition: @escaping ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)) {
           
           self.purchaseProductComplition = complition
           self.productToPurchase = product

           if self.canMakePurchases() {
               let payment = SKPayment(product: product)
               SKPaymentQueue.default().add(self)
               SKPaymentQueue.default().add(payment)
               
               log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
               productID = product.productIdentifier
           }
           else {
               complition(PKIAPHandlerAlertType.disabled, nil, nil)
           }
       }
       
       // RESTORE PURCHASE
       func restorePurchase(){
           SKPaymentQueue.default().add(self)
           SKPaymentQueue.default().restoreCompletedTransactions()
       }
       
       
       // FETCH AVAILABLE IAP PRODUCTS
       func fetchAvailableProducts(complition: @escaping (([SKProduct])->Void)){
           
           self.fetchProductComplition = complition
           // Put here your IAP Products ID's
           if self.productIds.isEmpty {
               log(PKIAPHandlerAlertType.setProductIds.message)
               fatalError(PKIAPHandlerAlertType.setProductIds.message)
           }
           else {
               productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
               productsRequest.delegate = self
               productsRequest.start()
           }
       }
       
       //MARK:- Private
       fileprivate func log <T> (_ object: T) {
           if isLogEnabled {
               NSLog("\(object)")
           }
       }
   }

   //MARK:- Product Request Delegate and Payment Transaction Methods
   //MARK:-
   extension PKIAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    func requestDidFinish(_ request: SKRequest) {
        print(request)
    }
    func paymentQueueDidChangeStorefront(_ queue: SKPaymentQueue) {
        print(queue)
    }
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        print(product)
        return true
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error)
        log(PKIAPHandlerAlertType.productRequestFailed.message)
        fatalError(PKIAPHandlerAlertType.productRequestFailed.message)
    }
    
       // REQUEST IAP PRODUCTS
       func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
           if (response.products.count > 0) {
               if let complition = self.fetchProductComplition {
                   complition(response.products)
               }
           }
           else {
            log(PKIAPHandlerAlertType.noProductIDsFound.message)
            fatalError(PKIAPHandlerAlertType.noProductIDsFound.message)
           }
       }
       
       func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
           if let complition = self.purchaseProductComplition {
               complition(PKIAPHandlerAlertType.restored, nil, nil)
           }
       }
       
       // IAP PAYMENT QUEUE
       func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
           for transaction:AnyObject in transactions {
               if let trans = transaction as? SKPaymentTransaction {
                   switch trans.transactionState {
                   case .purchased:
                       log("Product purchase done")
                    defaults.setValue(true, forKey: "isPurchased")
                       SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                       if let complition = self.purchaseProductComplition {
                           complition(PKIAPHandlerAlertType.purchased, self.productToPurchase, trans)
                       }
                       break
                       
                   case .failed:
                       log("Product purchase failed")
                       SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                       break
                   case .restored:
                       log("Product restored")
                       SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                       break
                       
                   default: break
                   }}}
       }
    
   }

