//
//  ViewController.swift
//  In-App Purchase
//
//  Created by Dipak on 30/01/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit
import StoreKit

enum RegisteredPurchase : String {
    
    case purchase1 = "com.myrta.product12"

}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func actionIn(_ sender: Any) {
        
//        let storyBoard =  UIStoryboard(name:"Main", bundle: nil)
//        let dsrNotification = storyBoard.instantiateViewController(withIdentifier: "BuyViewController")
//        let navVc = UINavigationController(rootViewController: dsrNotification);
//        navVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        navVc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
//        navVc.navigationBar.isHidden = true;
//        self.rootViewController().present(navVc, animated: false, completion: nil);
        
        SwiftyStoreKit.purchaseProduct(RegisteredPurchase.purchase1.rawValue, atomically: true) { result in
            
            if case .success(let product) = result {
                // Deliver content from server, then:
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
            self.showAlert(self.alertForPurchaseResult(result))
        }
        
    }
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController {
        switch result {
        case .success(let product):
            print("Purchase Success: \(product.productId)")
            return alertWithTitle("Thank You", message: "Purchase completed")
        case .error(let error):
            print("Purchase Failed: \(error)")
            switch error {
            case .failed(let error):
                if (error as NSError).domain == SKErrorDomain {
                    return alertWithTitle("Purchase failed", message: "Please check your Internet connection or try again later")
                }
                return alertWithTitle("Purchase failed", message: "Unknown error. Please contact support")
            case .invalidProductId(let productId):
                return alertWithTitle("Purchase failed", message: "\(productId) is not a valid product identifier")
            case .paymentNotAllowed:
                return alertWithTitle("Payments not enabled", message: "You are not allowed to make payments")
            }
        }
    }
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
    func rootViewController () -> UIViewController{
        
        var topRootViewController : UIViewController =  UIApplication.shared.keyWindow!.rootViewController!;
        
        while ((topRootViewController.presentedViewController) != nil)
        {
            topRootViewController = topRootViewController.presentedViewController!;
        }
        
        return topRootViewController;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

