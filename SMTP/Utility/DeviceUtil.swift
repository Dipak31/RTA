//
//  DeviceUtil.swift
//  OneHopIOS
//
//  Created by System Administrator on 5/30/15.
//  Copyright (c) 2015 Walkins. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import AVFoundation

public enum TheDeviceType:Int{
    case unknown=1,simulator,iPhone4,iPhone5,iPhone6,iPhone6p,iPad1024,iPad2048

}




public class DeviceUtil {
    public static func getDeviceUniqueId()->String {
        let uiDevice:UIDevice=UIDevice();

        return (uiDevice.identifierForVendor!.uuidString)

    }
    public static func isIpad() -> Bool{
        
        if  UIDevice.current.userInterfaceIdiom == .pad{
            
            let array : [Int] = [];
            //print(array[5]);
            return true;
        }
        return false;
    }
    public static func getAppVersion()->String {
        
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    public static func resizeImage(image:UIImage,newSize:CGSize) -> UIImage {

                   // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).

            // Pass 1.0 to force exact pixel size.

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);

        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));

        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;

        UIGraphicsEndImageContext();

        

        return newImage;

    }

    

   

    public static func dialNumber(thePhNo:String) -> Bool {

        
        let phNo = thePhNo.replacingOccurrences(of: " ", with: "");
        

        let dialStr:String = "tel://\(phNo))"

        let dialUrl:NSURL? = NSURL(string:dialStr);

        if dialUrl != nil {

            //////print("--|\(dialUrl)|--");

            if UIApplication.shared.canOpenURL(dialUrl! as URL) {

                

                UIApplication.shared.openURL(dialUrl! as URL);

                return true;

            }

        }

        return false;

        

    }

    public static func canDialNumber() -> Bool {

        let dialStr:String = "tel://5252552"

        let dialUrl:NSURL? = NSURL(string:dialStr);

        if dialUrl != nil {

            return UIApplication.shared.canOpenURL(dialUrl! as URL)

        }

        return false;

    }

    public static func isGooglePlusAppInstalled() -> Bool {

        let gplusStr:String = "gplus://"

        

        let gplusUrl:NSURL? = NSURL(string:gplusStr);

        if gplusUrl != nil {

            //////print("--|\(dialUrl)|--");

            if UIApplication.shared.canOpenURL(gplusUrl! as URL) {

                return true;

                

            }

        }

        return false;

    }
    public static func openSettings() {
        
        if #available(iOS 8.0, *) {
            let url = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.openURL(url! as URL)
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
    public static func isWhtasappInstalled() -> Bool {
        
        let whtasappStr:String = "whatsapp://send?text=test"
        let whatsappUrl:NSURL? = NSURL(string:whtasappStr);
        if whatsappUrl != nil {
            if UIApplication.shared.canOpenURL(whatsappUrl! as URL) {
                return true;
            }
        }
        return false;
        
    }
   
    
    
    public static func openUrlSafely(url:String) {

        let theUrl:NSURL? = NSURL(string: url);

        if theUrl != nil {

            if UIApplication.shared.canOpenURL(theUrl! as URL) {

                UIApplication.shared.openURL(theUrl! as URL);

            }

        }

    }

    public static func isCameraPermissionGranted() -> Bool{
        
        var isPermissionGranted : Bool = false
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.authorized
        {
            // Already Authorized
            isPermissionGranted = true
        }
        else
        {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
               
                if granted == true
                {
                    // User granted
                     isPermissionGranted = true
                }
            });
        }
        
        return isPermissionGranted
    }
    
   



    

    public static func vibrateBeep() {

        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate));

    }

    public static func vibrate() {

        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate));

    }

 

  
  

    public static func isGreaterThanDate(startDate : NSDate, endDate : NSDate) -> Bool
    {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if startDate.compare(endDate as Date) == ComparisonResult.orderedDescending
        {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    
    public static func isLessThanDate(startDate : NSDate, endDate : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if startDate.compare(endDate as Date) == ComparisonResult.orderedAscending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    public static func isEqualToDate(startDate : NSDate, endDate : NSDate) -> Bool
    {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if startDate.compare(endDate as Date) == ComparisonResult.orderedSame
        {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }

    // ------------------------
    
    public static func isMonthNextToCurrentMonth(syncDate : Date) -> Bool{
        
        let syncYear = Calendar.current.component(.month, from: syncDate)
        let syncMonth = Calendar.current.component(.month, from: syncDate)
        let currYear = Calendar.current.component(.month, from: Date())
        let currMonth = Calendar.current.component(.month, from: Date())
        
        if (syncYear < currYear){
            return true
        }
        if (syncMonth < currMonth){
            return true
        }
        return false
    }

}
