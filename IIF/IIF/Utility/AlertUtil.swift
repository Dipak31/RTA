//
//  AlertUtil.swift
//  OneHopIOS
//
//  Created by System Administrator on 5/28/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//

import Foundation
import UIKit

open class AlertUtil : NSObject {
    
    open static func getLoading(_ title:String,message:String) -> UIAlertView {
        let alertView:UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "" )

        

        let spinner:UIActivityIndicatorView=UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray);

        spinner.center=CGPoint(x: 139.5, y: 75.5);

        alertView.addSubview(spinner);

        spinner.startAnimating();

        

        return alertView;

    }

    open static func getOk(_ title:String,message:String) -> UIAlertView {

        let alert:UIAlertView = UIAlertView( title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")

        return alert;

    }
    
    open static func getOk(_ title:String,message:String,okButtonTitle:String) -> UIAlertView {
        
        let alert:UIAlertView = UIAlertView( title: title, message: message, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: okButtonTitle)
        
        return alert;
    }
    
    open static func showConnectivityAlert() -> UIAlertView {
        
        let alert:UIAlertView = UIAlertView( title: Message.NO_INTERNET_CONNECTION, message: Message.NO_INTERNET_CONNECTION_MESSAGE, delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok")
        
        return alert;
        
    }
    open static func getYesNo(_ title:String,message:String,delegate:UIAlertViewDelegate) -> UIAlertView {

        let alert:UIAlertView = UIAlertView( title: title, message: message, delegate: delegate, cancelButtonTitle: "No", otherButtonTitles: "Yes")

        return alert;

    }

    open static func getConfirmCancel(_ title:String,message:String,delegate:UIAlertViewDelegate) -> UIAlertView {

        let alert:UIAlertView = UIAlertView( title: title, message: message, delegate: delegate, cancelButtonTitle: "Cancel", otherButtonTitles: "Confirm")

        return alert;

    }

    open static func getGotoSettingCancel(_ title:String,message:String,delegate:UIAlertViewDelegate) -> UIAlertView {

        let alert:UIAlertView = UIAlertView( title: title, message: message, delegate: delegate, cancelButtonTitle: "Cancel", otherButtonTitles: "Goto Setting")

        return alert;

    }

    open static func getYesNoWithPromptInput(_ title:String,message:String,delegate:UIAlertViewDelegate) -> UIAlertView {

        let alert:UIAlertView = UIAlertView( title: title, message: message, delegate: delegate, cancelButtonTitle: "No", otherButtonTitles: "Yes")

        alert.alertViewStyle = UIAlertViewStyle.plainTextInput;

        return alert;

    }

    open static func showAlertWithMessage(_ title:String,message:String,cancel : String, Ok : String ,delegate:UIAlertViewDelegate) -> UIAlertView {

        let alert:UIAlertView = UIAlertView( title: title, message: message, delegate: delegate, cancelButtonTitle: Ok, otherButtonTitles: cancel)

        return alert;

    }
    open static var alert : UIAlertView = UIAlertView();
    
    open static func showCustomAlertWithMessage(_ title:String,msg:String="")  {
        
        alert = UIAlertView(title:title, message: msg, delegate: nil, cancelButtonTitle: nil);
        
        alert.show();
        
        Timer.scheduledTimer(timeInterval: 2.0, target: AlertUtil.self, selector: #selector(hideAlertView), userInfo: nil, repeats: false)
    }
     open static func hideAlertView(){
        
        alert.dismiss(withClickedButtonIndex: 0, animated: true);
        
    }
//    public static func displayContactPermissionAlert(delegate:UIAlertViewDelegate) {
//        
//        var alert:UIAlertView? = nil;
//        
//        if NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 {
//            
//            alert = AlertUtil.showAlertWithMessage(MessageUtil.CONTACT_PERMISSION_DISABLE_TITLE, message:MessageUtil.CONTACT_PERMISSION_DISABLE_MESSAGE, cancel: "Change Setting", Ok: "OK", delegate: delegate)
//            //alert?.tag = CONTACT_ALERT_TAG
//            
//        }else
//        {
//            alert = AlertUtil.getOk(MessageUtil.CONTACT_PERMISSION_DISABLE_TITLE, message:MessageUtil.CONTACT_PERMISSION_DISABLE_MESSAGE)
//        }
//        
//        alert!.show()
//        
//    }
    open static func showAlertWithThreeButton(_ title:String,message:String,button1 : String, button2 : String ,button3 : String ,delegate:UIAlertViewDelegate) -> UIAlertView {

        let alert:UIAlertView = UIAlertView( title: title, message: message, delegate: delegate, cancelButtonTitle: "Ok", otherButtonTitles: button1, button2 , button3)
        return alert;
    }

}
