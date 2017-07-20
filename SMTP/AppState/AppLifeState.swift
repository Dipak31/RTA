//
//  AppLifeState.swift
//  Walkins Seller
//
//  Created by System Administrator on 9/6/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit

open class AppLifeState: NSObject {


    open static let KEY_SHOW_TUTORIAL:String="show-tutorial";
    open static let KEY_SHOW_DELETE_DIALOGE:String="show-delete-dialoge";
    open static let KEY_SET_SYNC_DONE:String="is-sync-done";
    open static let KEY_IN_APP_RECEIPT:String="InAppReceipt";
    open static let KEY_ITUNES_SHARED_GENERATED_KEY:String="852c1c92dbb74ffa9f2d93d62fb4c124";
    open static let KEY_REFRESH_RECEIPT:String="isReceiptRefreshed";
    open static let KEY_LASTSYNC_DATE:String="lastSyncDate";
    open static let KEY_ABY_STROKE_PURCHASED:String="isAnyStrokePurchased";


    open static func getTutorial() -> Bool? {
        return (UserDefaults.standard.bool(forKey: KEY_SHOW_TUTORIAL))
    }
    open static func getReceiptRefresh() -> Bool? {
        return (UserDefaults.standard.bool(forKey: KEY_REFRESH_RECEIPT))
    }
    open static func setTutorial(_ seededState:Bool) {
        UserDefaults.standard.set(seededState,forKey:KEY_SHOW_TUTORIAL);
        UserDefaults.standard.synchronize()
    }
    
    open static func getIsSyncDone() -> Bool? {
        return false;

    }

    open static func setIsSyncDone(_ seededState:Bool) {
        UserDefaults.standard.set(seededState,forKey:KEY_SET_SYNC_DONE);
        UserDefaults.standard.synchronize()
    }
    
    open static func getDeleteDialog() -> Bool? {
        return (UserDefaults.standard.bool(forKey: KEY_SHOW_DELETE_DIALOGE))
    }
    open static func setDeleteDialog(_ seededState:Bool) {
        UserDefaults.standard.set(seededState,forKey:KEY_SHOW_DELETE_DIALOGE);
        UserDefaults.standard.synchronize()
    }

   

    open static func ArchivePaths(_ name:String) -> URL{
        
        let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
       return DocumentsDirectory.appendingPathComponent(name)
        
    }
    
    open static func setLastSyncDate() {
        UserDefaults.standard.set(Date(),forKey:AppLifeState.KEY_LASTSYNC_DATE);
        UserDefaults.standard.synchronize()
    }
    open static func getLastSyncDate() -> Date {
        return (UserDefaults.standard.object(forKey: AppLifeState.KEY_LASTSYNC_DATE) as! Date)
    }

    
    open static func clearAppData(){
        

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);
        
        let theAppSupportPath:String = dirPath.first!;
        
        let fileManager = FileManager.default
        
        do {
            let items = try fileManager.contentsOfDirectory(atPath: theAppSupportPath)
            
            for cacheFile in items {
                
                let paths = "\(theAppSupportPath)/" + cacheFile
                deleteFile(paths)

            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
        UserDefaults.standard.synchronize();
    }
    
    open static  func deleteFile(_ path: String){
        
        let exists = FileManager.default.fileExists(atPath: path)
        if exists {
            do {
                try FileManager.default.removeItem(atPath: path)
            }catch let error as NSError {
                //print("error: \(error.localizedDescription)")
            }
        }
    }
    
    //check If is In app produtc purchase or not
    //**** check product subscription
    class func isProductPurchased(strokeId: Int64) -> Bool{
        
        if isVerifyProductFromIdentifier((Constants.productIdToIdentifier[0])!){
            return true;
        }
        guard let identifier = Constants.productIdToIdentifier[strokeId] else { return false }

        return isVerifyProductFromIdentifier(identifier)
    }
       class func isVerifyProductFromIdentifier(_ productIdentifier : String) -> Bool{
        
        if let receipt = UserDefaults.standard.object(forKey: KEY_IN_APP_RECEIPT){
            let purchaseResult = SwiftyStoreKit.verifySubscription(
                productId: productIdentifier,
                inReceipt: receipt as! ReceiptInfo,
                validUntil: Date()
            )
            return AppLifeState.isValidSubscription(purchaseResult)
        }else{
            //print("Product Not Purchased");
            return false
        }
    }
   
    class func isValidSubscription(_ result: VerifySubscriptionResult) -> Bool {
        
        switch result {
        case .purchased(let expiresDate):
            //print("Product is purchased : Product is valid until \(expiresDate)")
            return true
        case .expired(let expiresDate):
           // //print("Product expired : Product is expired since \(expiresDate)")
            return false
        case .notPurchased:
            ////print("This product has never been purchased")
            return false
        }
    }
    class func isAnyStrokePurchased() -> Bool{
        
        for (strokeId,name) in Constants.productIdToIdentifier{
            if isProductPurchased(strokeId: strokeId){
                setStrokePurchased(true);
                return true;
            }
        }
        setStrokePurchased(false);
        return false;
    }
    
    open static func isStrokePurchased() -> Bool? {
        return (UserDefaults.standard.bool(forKey: KEY_ABY_STROKE_PURCHASED))
    }
    open static func setStrokePurchased(_ seededState:Bool) {
        UserDefaults.standard.set(seededState,forKey:KEY_ABY_STROKE_PURCHASED);
        UserDefaults.standard.synchronize()
    }

    class func refreshAndStoreLocallyReceipt(completationHandler: ((_ isSuccess: Bool)->())?){
        
        let appleValidator = AppleReceiptValidator(service: .sandbox)
        SwiftyStoreKit.verifyReceipt(using: appleValidator, password: KEY_ITUNES_SHARED_GENERATED_KEY) { result in
            switch result{
            case .error(let error) :
                if case .noReceiptData = error {
                    //print("Receipt failed.")
                    completationHandler?(false);
                }
                
            case .success(let receipt):
                //Save Receipt in User Default
                let pref = UserDefaults.standard
                pref.set(receipt, forKey: KEY_IN_APP_RECEIPT)
                pref.synchronize()
                completationHandler?(true);

            }
        }
    }
    
   class func refreshReceipt() {
    
    SwiftyStoreKit.refreshReceipt { result in
        
        UserDefaults.standard.set(true,forKey:KEY_REFRESH_RECEIPT);
        UserDefaults.standard.synchronize()
        
        
        AppLifeState.refreshAndStoreLocallyReceipt(completationHandler: { isSuccess in
            //print("Success Block");
        });
    }
    
    }

 }

