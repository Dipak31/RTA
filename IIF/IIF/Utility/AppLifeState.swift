//
//  AppLifeState.swift
//  Walkins Seller
//
//  Created by System Administrator on 9/6/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit

open class AppLifeState: NSObject {

    open static let KEY_VERIFIED_BUSINESS_INFO:String="user_login";
    open static let KEY_BUSINESS_ID:String="business_id";

    open static let KEY_TECH_MATE:String="tech-mate-splash";
    open static let KEY_CASTING_FINDER:String="casting-finder-splash";
    open static let KEY_MATERIAL_EQUIPMENT:String="material-equipment-splash";
    
    open static let KEY_CASTING_FINDER_VIEW : String="casting_finder_view";
    open static let KEY_MAT_EQUIP_VIEW : String="mat_equip_view";
    open static let KEY_FOUNDARY_TECH_MAT_VIEW : String="foundary_tech_mat_view";

    open static func getTechMateSplash() -> Bool? {
        return (UserDefaults.standard.bool(forKey: KEY_TECH_MATE))
    }
    open static func setTechMateSplash(_ seededState:Bool) {
        UserDefaults.standard.set(seededState,forKey:KEY_TECH_MATE);
        UserDefaults.standard.synchronize()
    }
    
    open static func getCastingFinderSplash() -> Bool? {
        return (UserDefaults.standard.bool(forKey: KEY_CASTING_FINDER))
    }
    open static func setCastingFinderSplash(_ seededState:Bool) {
        UserDefaults.standard.set(seededState,forKey:KEY_CASTING_FINDER);
        UserDefaults.standard.synchronize()
    }
    open static func getMaterialEquipmentSplash() -> Bool? {
        return (UserDefaults.standard.bool(forKey: KEY_MATERIAL_EQUIPMENT))
    }
    open static func setMaterialEquipmentSplash(_ seededState:Bool) {
        UserDefaults.standard.set(seededState,forKey:KEY_MATERIAL_EQUIPMENT);
        UserDefaults.standard.synchronize()
    }

    open static func ArchivePaths(_ name:String) -> URL{
        
        let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
       return DocumentsDirectory.appendingPathComponent(name)
        
    }
    
    open static func getIsVerifyBusinessInfo() -> Bool? {
        return (UserDefaults.standard.bool(forKey: KEY_VERIFIED_BUSINESS_INFO))
    }
    open static func setIsVerifyBusinessInfo(_ seededState:Bool) {
        UserDefaults.standard.set(seededState,forKey:KEY_VERIFIED_BUSINESS_INFO);
        UserDefaults.standard.synchronize()
    }
    
    open static func getUser() -> User?{
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: AppLifeState.ArchivePaths("User").path) as? User
        
    }
    open static func getUserId() -> Int?{
        
        if let user = getUser(){
            
            if let id = user.id{
                return id;
            }
        }
        return nil;
    }
    public static func setCastingFinderViewDate(){
    
        UserDefaults.standard.set(Date(), forKey: KEY_CASTING_FINDER_VIEW);
    }
    public static func setMatQuipViewDate(){
        
        UserDefaults.standard.set(Date(), forKey: KEY_MAT_EQUIP_VIEW);
    }
    public static func setTechMateViewDate(){
        
        UserDefaults.standard.set(Date(), forKey: KEY_FOUNDARY_TECH_MAT_VIEW);
    }
    public static func isShowCastingFinderAppReview() -> Bool{
        
        if let endDate = UserDefaults.standard.object(forKey:KEY_CASTING_FINDER_VIEW) as? Date{
            let userCalendar = Calendar.current
            let requestedComponent: Set<Calendar.Component> = [.day]
            let startTime = Date()
            let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime, to: endDate)
            print(timeDifference.day!);
            if timeDifference.day! == 7{
                print("isShowCastingFinderAppReview");
                setCastingFinderViewDate();
                return true;
            }
        }else{
            setCastingFinderViewDate();
            return true;
        }
        return false;
    }
    
    public static func isShowMatQuipAppReview() -> Bool{
        
        if let endDate = UserDefaults.standard.object(forKey:KEY_MAT_EQUIP_VIEW) as? Date{
            let userCalendar = Calendar.current
            let requestedComponent: Set<Calendar.Component> = [.day]
            let startTime = Date()
            let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime, to: endDate)
            if timeDifference.day! == 7{
                print("isShowMatQuipAppReview");
                setMatQuipViewDate();
                return true;
            }
        }else{
            setMatQuipViewDate();
            return true;

        }
        return false;
    }
   
    
    public static func isShowTechMateAppReview() -> Bool{
        
        if let endDate = UserDefaults.standard.object(forKey:KEY_FOUNDARY_TECH_MAT_VIEW) as? Date{
            let userCalendar = Calendar.current
            let requestedComponent: Set<Calendar.Component> = [.day]
            let startTime = Date()
            let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime, to: endDate)
            if timeDifference.day! == 7{
                print("isShowTechMateAppReview");
                setTechMateViewDate();
                return true;
            }
        }else{
            setTechMateViewDate();
            return true;

        }
        return false;
    }
    

   
    open static func setUser(_ user:User){
        
        let isSuccess = NSKeyedArchiver.archiveRootObject(user, toFile: AppLifeState.ArchivePaths("User").path);
        
        if !isSuccess {
            print("Failed to save Business..")
        }
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
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    
    //    open static func setBusinessId(_ businessId:String) {
//        
//        UserDefaults.standard.setValue(businessId, forKey: KEY_BUSINESS_ID)
//        UserDefaults.standard.synchronize()
//
//    }
   //    open static func getBusinessPhoneNo() -> String? {
//        
//       if  let business = AppLifeState.getBusiness(){
//            
//            if let phoneNo = business.phoneNumber{
//                return phoneNo;
//            }
//        }
//        
//        return nil;
//    }
 }

