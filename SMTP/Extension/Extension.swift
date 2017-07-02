//
//  UIView+Extension.swift
//  Walkins Seller
//
//  Created by System Administrator on 9/6/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import Foundation

extension UIButton {
    
    func getCellInstance() -> UICollectionViewCell?{
        
        var theCell:UICollectionViewCell? = self.superview!.superview!.superview! as? UICollectionViewCell
        
        if theCell == nil {
            theCell = self.superview!.superview! as? UICollectionViewCell
        }
        
        if theCell == nil {
            theCell = self.superview! as? UICollectionViewCell
        }
        
        if theCell == nil{
            theCell = self.superview!.superview!.superview! as? UICollectionViewCell
        }
        
        if theCell == nil {
            theCell = self.superview!.superview!.superview!.superview! as? UICollectionViewCell
        }
        return theCell;
    }
    
    
}
extension UIViewController {

    public static func Instance(storyBoard:String=StoryBoard.MAIN) -> UIViewController{
        let viewController = storyBoard.StoryBoardInstance().instantiateViewController(withIdentifier: String(describing:self));
        return viewController;
    }
    
    public func addSlideMenuBarItem(){
        let menuBarItem = UIUtil.getImageViewForBarItem(self, action:#selector(self.toggleSlideMenu), image: "menu.png");
        self.navigationItem.leftBarButtonItem = menuBarItem;
    }
    
    
    public func PUSH_VC(vc:UIViewController){
        self.navigationController?.pushViewController(vc, animated: true);
    }
    func actionBack(){
        let _ = self.navigationController?.popViewController(animated: true);
    }
    func actionDisMiss(){
        self.dismiss(animated: true, completion: nil);
    }
    func toggleSlideMenu(){
        let drawerController = self.navigationController?.parent as? KYDrawerController
        drawerController?.setDrawerState(.opened, animated: true);
    }
   
}

extension AppDelegate{
    
    
    func rootViewController () -> UIViewController{
        
        var topRootViewController : UIViewController =  UIApplication.shared.keyWindow!.rootViewController!;
        
        while ((topRootViewController.presentedViewController) != nil)
        {
            topRootViewController = topRootViewController.presentedViewController!;
        }
        
        return topRootViewController;
    }

    
    func setRootViewController(){
        
        let storyBoard = StoryBoard.MAIN.StoryBoardInstance();
        
        let  videos = Video.getAllRecord();
        
        if !NetworkReachability.isConnectedToNetwork(displayAlert: false) && videos.count <= 0 {
            let viewController =  storyBoard.instantiateViewController(withIdentifier: "splashViewController")
            APP_DELEGATE?.window?.rootViewController = viewController
            return;
        }
        
        if AppLifeState.getTutorial()!{
            let identifier = String(describing:KYDrawerController.self)
            let viewController =  storyBoard.instantiateViewController(withIdentifier: identifier) as! KYDrawerController
            viewController.drawerDirection = .right;
            APP_DELEGATE?.window?.rootViewController = viewController
            return;
        }
        
        let identifier = String(describing:TutorialViewController.self);
        let viewController =  storyBoard.instantiateViewController(withIdentifier: identifier)
        APP_DELEGATE?.window?.rootViewController = viewController
    }
}
