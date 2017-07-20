//
//  PurchaseController.swift
//  SMTP
//
//  Created by Dipak on 05/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit
import StoreKit

enum ProductIdentifier : String {
    
    case allStroke = "SMTP_AllStrokes"
    case backhandvolley = "SMTP_BackhandVolley"
    case doubleHandedBackhand = "SMTP_DHB"
    case doubleHandedBackhandReturn = "SMTP_DHBR"
    case footworkAndPointPlay = "SMTP_FWandPP"
    case forehand = "SMTP_Forehand"
    case returnForehand = "SMTP_ForehandReturn"
    case serve = "SMTP_Serve"
    case slice = "SMTP_Slice"
  
}

class PurchaseController: UIViewController {
    
    var products = [SKProduct]()
    
    @IBOutlet weak var tblProduct: UITableView!
    @IBOutlet var lblAllStrokes: UILabel!
    @IBOutlet var btnAllStrokes: UIButton!
    
    fileprivate  let productList: Set<String> = [
        ProductIdentifier.allStroke.rawValue,
        ProductIdentifier.backhandvolley.rawValue,
        ProductIdentifier.doubleHandedBackhand.rawValue,
        ProductIdentifier.doubleHandedBackhandReturn.rawValue,
        ProductIdentifier.footworkAndPointPlay.rawValue,
        ProductIdentifier.forehand.rawValue,
        ProductIdentifier.returnForehand.rawValue,
        ProductIdentifier.serve.rawValue,
        ProductIdentifier.slice.rawValue
    ]
    public var disMissHandler: ((_ isStrokePurchased:Bool) -> ())?
    var isProcessing : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if DeviceUtil.isIpad(){
            
        }
        
        //request for inapp purchase
        if (APP_DELEGATE?.products.isEmpty)!{
            getInfo(productIds: productList)
        }
        
        if (APP_DELEGATE!.productAllStroke != nil){
            self.lblAllStrokes.text = self.getProductDetails(product: (APP_DELEGATE?.productAllStroke)!)
        }
    }
    
    //MARK: - Purchse All Stroke Options
    
    func getProductDetails(product: SKProduct) -> String{
        
        //set product title
        var productName = product.localizedTitle as String
        InAppProductCell.priceFormatter.locale = product.priceLocale
        let strPrice = InAppProductCell.priceFormatter.string(from: product.price)
        productName += "\n \(strPrice!)"
        
        if AppLifeState.isVerifyProductFromIdentifier(product.productIdentifier){
            self.btnAllStrokes.isEnabled = false
            self.lblAllStrokes.alpha = 0.5
        }else{
            //btnProductBuy.isHidden = false
            self.btnAllStrokes.isEnabled = true
            self.lblAllStrokes.alpha = 1.0
        }
        return productName.uppercased()
    }
    
    //MARK : - Button Actions
    @IBAction func btnBuyAllStrokePressed(_ sender: Any) {
        //self.actionDisMiss();
        self.purchase(ProductIdentifier.allStroke.rawValue)
    }

    @IBAction func actionBack(_ sender: Any) {
        self.actionDisMiss();
        
    }
    
    
    
    //MARK: - In App Purchase Functions
    
    //*** Custom Alert ***
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(_ alert: UIAlertController) {
        guard let _ = self.presentedViewController else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    //*** Request for GET product information from itunes ***
    func getInfo(productIds: Set<String>) {
        
        SVProgressHUD.show();
        SwiftyStoreKit.retrieveProductsInfo(productIds) { result in
            SVProgressHUD.dismiss();
            
            self.productRetrievalInfo(result);
            self.tblProduct.reloadData();
            
        }
    }
    
    func productRetrievalInfo(_ result: RetrieveResults) {
        
        APP_DELEGATE?.products = []
        
        //Valid Products
        for product in result.retrievedProducts{
            if product.productIdentifier == ProductIdentifier.allStroke.rawValue{
                self.lblAllStrokes.text = self.getProductDetails(product: product)
                APP_DELEGATE?.productAllStroke = product
            }else{
                APP_DELEGATE?.products.append(product)
            }
        }
        APP_DELEGATE!.products.sort(by:{$0.0.localizedTitle < $0.1.localizedTitle});
        
        //Invalid Product
        for invalidProductId in result.invalidProductIDs{
            //print("\nCould not retrieve product info \n message: Invalid product identifier: \(invalidProductId)")
        }
        
        if let errorString = result.error?.localizedDescription{
            //print("Could not retrieve product info message: \(errorString)" )
        }
    }
    
    //*** Request for BUY product to itunes ***
    func purchase(_ productId: String) {
        
        if isProcessing{
            //print("InProcessing");
            return;
        }
        self.isProcessing = true

        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            self.isProcessing = false

            if case .success(let product) = result {
                // Deliver content from server, then:
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
            self.alertForPurchaseResult(result)
        }
    }
    func alertForPurchaseResult(_ result: PurchaseResult)  {
        switch result {
        case .success(let product):
            
            self.verifyPurchase(product.productId)
            
            //print("Purchase Success: \(product.productId)")
           // AlertUtil.showCustomAlertWithMessage("Thank You", msg: "Purchase completed")

            self.dismiss(animated: true, completion: {
                APP_DELEGATE!.menStrokes = [];
                APP_DELEGATE!.woMenStrokes = [];
                APP_DELEGATE!.menWoMenStrokes = [];
                self.disMissHandler?(true);
            })
                 case .error(let error):
            //print("Purchase Failed: \(error)")
            switch error {
            case .failed(let error):
                if (error as NSError).domain == SKErrorDomain {
                    AlertUtil.showCustomAlertWithMessage("Purchase Failed")
                }
               // AlertUtil.showCustomAlertWithMessage("Purchase failed", msg: "Unknown error. Please contact support")
            case .invalidProductId(let productId):
                AlertUtil.showCustomAlertWithMessage("Purchase failed", msg: "\(productId) is not a valid product identifier")

            case .paymentNotAllowed:
                AlertUtil.showCustomAlertWithMessage("Payments not enabled", msg: "You are not allowed to make payment");

            }
        }
    }
    
    //*** Verify Receipt ***
    func verifyPurchase(_ productId: String) {
        
        //SVProgressHUD.show();
        let appleValidator = AppleReceiptValidator(service: .sandbox )
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password:AppLifeState.KEY_ITUNES_SHARED_GENERATED_KEY) { result in
            //SVProgressHUD.dismiss();
            
            switch result {
            case .success(let receipt):
                
                //Save Receipt in User Default
                let pref = UserDefaults.standard
                pref.set(receipt, forKey: "InAppReceipt")
                pref.synchronize()
                
                // refresh single table row
                if productId == ProductIdentifier.allStroke.rawValue{
                    self.lblAllStrokes.text = self.getProductDetails(product: (APP_DELEGATE?.productAllStroke)!)
                    self.tblProduct.reloadData()
                }else{
                    for (index, product) in (APP_DELEGATE?.products.enumerated())! {
                        guard product.productIdentifier == productId else { continue }
                        
                        self.tblProduct.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    }
                }
                
            case .error(let error):
                self.showAlert(self.alertForVerifyReceipt(result))
                if case .noReceiptData = error {
                    self.refreshReceipt()
                }
            }
        }
    }
    
    func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case .success(let receipt):
            //print("Verify receipt Success: \(receipt)")
            return alertWithTitle("Receipt verified", message: "Receipt verified remotly")
        case .error(let error):
            //print("Verify receipt Failed: \(error)")
            switch (error) {
            case .noReceiptData :
                return alertWithTitle("Receipt verification", message: "No receipt data, application will try to get a new one. Try again.")
            default:
                return alertWithTitle("Receipt verification", message: "Receipt verification failed")
            }
        }
    }
    func refreshReceipt() {
        SwiftyStoreKit.refreshReceipt { result in
//            switch result {
//            case .success(let receiptData):
//                //print("Receipt refresh success: \(receiptData.base64EncodedString)")
//                
//            case .error(let error):
//                //print("Receipt refresh failed: \(error)")
//            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PurchaseController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (APP_DELEGATE?.products.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InAppProductCell", for: indexPath) as! InAppProductCell
        
        let product = APP_DELEGATE?.products[(indexPath as NSIndexPath).row]
        
        cell.isAllStrokePurchase = AppLifeState.isVerifyProductFromIdentifier(ProductIdentifier.allStroke.rawValue)
        
        cell.product = product
        cell.buyButtonHandler = { product in
            self.purchase(product.productIdentifier)
        }
        
        return cell
    }
}
