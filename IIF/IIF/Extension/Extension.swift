//
//  String + Extension.swift
//  OneHop
//
//  Created by System Administrator on 11/23/15.
//  Copyright © 2015 OneHop. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func rotate(toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}

extension UITapGestureRecognizer {
    
    func getCellInstance() -> UITableViewHeaderFooterView?{
        
        var theCell:UITableViewHeaderFooterView? = self.view!.superview!.superview!.superview! as? UITableViewHeaderFooterView
        
        if theCell == nil {
            theCell = self.view!.superview!.superview! as? UITableViewHeaderFooterView
        }
        
        if theCell == nil {
            theCell = self.view!.superview! as? UITableViewHeaderFooterView
        }
        
        if theCell == nil{
            theCell = self.view!.superview!.superview!.superview! as? UITableViewHeaderFooterView
        }
        
        if theCell == nil {
            theCell = self.view!.superview!.superview!.superview!.superview! as? UITableViewHeaderFooterView
        }
        return theCell;
    }
    
    
}
extension UIButton {
    
    func getCellInstance() -> UITableViewCell?{
        
        var theCell:UITableViewCell? = self.superview!.superview!.superview! as? UITableViewCell
        
        if theCell == nil {
            theCell = self.superview!.superview! as? UITableViewCell
        }
        
        if theCell == nil {
            theCell = self.superview! as? UITableViewCell
        }
        
        if theCell == nil{
            theCell = self.superview!.superview!.superview! as? UITableViewCell
        }
        
        if theCell == nil {
            theCell = self.superview!.superview!.superview!.superview! as? UITableViewCell
        }
        return theCell;
    }
    
    
}
extension AppDelegate{
    
    public func setRootViewControoler(){
        
        var identifier = String(describing:SignInVC.self);
        
        if let user = AppLifeState.getUser(){
            
            identifier = "dashboardNav"
            if user.id != nil && user.id == 0{
                identifier = String(describing:SignUpVC.self);
            }
        }
        //identifier = "dashboardNav" //REMOVE THIS LINE
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        let vc =  storyBoard.instantiateViewController(withIdentifier: identifier)
        APP_DELEGATE?.window?.rootViewController = vc;
    }
}
extension UIViewController{

    public func PickerViewController(_ delegate:PickerViewControllerDelegate?,_ items:[String]?,_ currentIndex:Int?,_ tag:Int){
        
//        let vc = StoryBoard.MAIN.Instance().instantiateViewController(withIdentifier: StoryBoardID.PICKER_VC) as! PickerViewController
//        vc.delegate = delegate;
//        vc.listItems = items;
//        vc.selectedIndex = currentIndex;
//        vc.tag = tag;
//        vc.type = .PickerView;
//        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
//        APP_DELEGATE?.rootViewController().present(vc, animated: true, completion: nil);
    }
  
    public func showRatingView(appName : String,appId:String){
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:RatingViewController.self)) as!  RatingViewController
        vc.appName = appName
        vc.appId = appId;
        let navVc = UINavigationController(rootViewController: vc);
        navVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navVc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        navVc.navigationBar.isHidden = true;
        APP_DELEGATE?.rootViewController().present(navVc, animated: false, completion: nil);
    }
   
}
