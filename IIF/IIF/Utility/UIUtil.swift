//
//  UIUtil.swift
//  OneHop
//
//  Created by System Administrator on 6/20/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation

extension UIView {
    // Name this function in a way that makes sense to you...
    // slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names
    func slideInAnimation(_ duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
//        if let delegate: AnyObject = completionDelegate {
//            slideInFromLeftTransition.delegate = delegate
//        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromRight
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    func slideOutAnimation(_ duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
//        if let delegate: AnyObject = completionDelegate {
//            slideInFromLeftTransition.delegate = delegate
//        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionMoveIn
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    func slideInFromBottom(_ duration: TimeInterval = 0.1, completionDelegate: AnyObject? = nil) {
        let slideInFromBottomTransition = CATransition()
        
//        if let delegate: AnyObject = completionDelegate {
//            slideInFromBottomTransition.delegate = delegate
//        }
        
        slideInFromBottomTransition.type = kCATransitionPush
        slideInFromBottomTransition.subtype = kCATransitionFromTop
        slideInFromBottomTransition.duration = duration
        slideInFromBottomTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromBottomTransition.fillMode = kCAFillModeRemoved
        
        self.layer.add(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
    }
    func fadeIn(duration: TimeInterval = 1.0) {
        self.alpha = 0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    func flipAnimation(_ duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil,forKey:String) {
        
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 1.0)
        rotateAnimation.duration = duration
        
//        if let delegate: AnyObject = completionDelegate {
//            rotateAnimation.delegate = delegate
//        }
        self.layer.add(rotateAnimation, forKey: forKey)
    }
    
    func fadeOut(duration: TimeInterval = 0.1) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        })
    }
    
    func roundedCorner(_ color:UIColor,cornerRadius:CGFloat = Constants.CORNER_RADIUS,borderWidth:CGFloat = Constants.BORDER_WIDTH){
        
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = color.cgColor;
    }
    
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: 1)
        self.layer.addSublayer(border)
    }

 
    func shakeAnimation(){
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-30.0, 30.0, -30.0, 30.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
}
extension UITextField {
    
    func addPadding(){
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
    }
}
let PASSWORD_VIEW_TAG = 2030;

open class UIUtil {
    
    open static func setUpApperance(){
        
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIUtil.getBoldFont(14)]
        //UINavigationBar.appearance().barTintColor = UIColor(hex:Colors.blue,opacity:1.0)
        UINavigationBar.appearance().barStyle = UIBarStyle.black
       // UISearchBar.appearance().tintColor = UIColor(hex:Colors.RedOp._500);
        
        SVProgressHUD.setDefaultStyle(.dark);
        SVProgressHUD.setDefaultMaskType(.clear);
        SVProgressHUD.setMinimumDismissTimeInterval(1.0);
    }
    
   
    open static func getBoldFont(_ size:CGFloat) -> UIFont{
        
        return  UIFont.init(name: "Helvetica-Bold", size:size)!;
        
    }
  
    open static func getMediumFont(_ size:CGFloat) -> UIFont{
        
        return  UIFont.init(name: "Helvetica-Regular", size:size)!;
        
    }
    open static func getAspectImageSize(_ width:CGFloat,size:CGSize) -> CGSize{
        
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: size, insideRect: boundingRect)
        
        return rect.size;
        
    }
    
    open static func getTextSizeForText(_ txt:String,width:CGFloat,font:UIFont) -> CGSize {
        
        let textSize = CGSize(width: width, height: 10000.0)
        let tempView = UILabel()
        tempView.text = txt;
        tempView.font = font
        tempView.numberOfLines = 0
        

        return tempView.sizeThatFits(textSize)
    }
    open static func getSettingsBarItem(_ target: AnyObject, action: Selector) -> UIBarButtonItem {
        let settingsIcon:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25));

        settingsIcon.contentMode = UIViewContentMode.scaleAspectFit

        settingsIcon.image=UIImage(named:"ic_action_overflow.png");

        settingsIcon.isUserInteractionEnabled = true;

        settingsIcon.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))

        let settingsBarItem:UIBarButtonItem=UIBarButtonItem(customView: settingsIcon) //UIBarButtonItem(title: "settings", style: UIBarButtonItemStyle.Plain, target: self, action: "actionOpenSettings")

        

        settingsBarItem.tintColor=UIColor.white

        

        return settingsBarItem;

    }

    
    open static func getButtonForBarItem(_ title:String,target: AnyObject, action: Selector) -> UIBarButtonItem {
        
        
        let textWidth = title.getSizeForText(10000, height: 25, font: UIUtil.getBoldFont(15));
        
        let lblTitle : UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: textWidth.width, height: 25))
        
        lblTitle.text = title
        
        let barButtonFont = UIUtil.getBoldFont(15)
        
        lblTitle.font = barButtonFont
        
        lblTitle.textColor = UIColor.white
        
        lblTitle.isUserInteractionEnabled = true;
        
        lblTitle.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        
        let applyViewForBarItem:UIBarButtonItem=UIBarButtonItem(customView: lblTitle)
        
        applyViewForBarItem.tintColor=UIColor.white
        
        return applyViewForBarItem
    }
    open static func getSearchBarItem(_ target: AnyObject, action: Selector) -> UIBarButtonItem {

        let searchIcon:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25));

        searchIcon.contentMode = UIViewContentMode.scaleAspectFit

        searchIcon.image=UIImage(named:"ic_action_search_white");

        searchIcon.isUserInteractionEnabled = true;

        searchIcon.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))

        let settingsBarItem:UIBarButtonItem=UIBarButtonItem(customView: searchIcon) //UIBarButtonItem(title: "settings", style: UIBarButtonItemStyle.Plain, target: self, action: "actionOpenSettings")

        

        settingsBarItem.tintColor=UIColor.white

       

        return settingsBarItem;

    }

    

    open static func getShareBarItem(_ target: AnyObject, action: Selector) -> UIBarButtonItem {

        let shareIcon:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25));

        shareIcon.contentMode = UIViewContentMode.scaleAspectFit

        shareIcon.image=UIImage(named:"ic_action_share_overlay.png");

        shareIcon.isUserInteractionEnabled = true;

        shareIcon.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))

        let shareBarItem:UIBarButtonItem=UIBarButtonItem(customView: shareIcon) //UIBarButtonItem(title: "settings", style: UIBarButtonItemStyle.Plain, target: self, action: "actionOpenSettings")

        

        shareBarItem.tintColor=UIColor.white

        

        return shareBarItem;

    }

    open static func getBroadCastBarItem(_ target: AnyObject, action: Selector) -> UIBarButtonItem {
        
        let broadCastIcon:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25));
        
        broadCastIcon.contentMode = UIViewContentMode.scaleAspectFit
        
        broadCastIcon.image=UIImage(named:"broadcast_white.png");
        
        broadCastIcon.isUserInteractionEnabled = true;
        
        broadCastIcon.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        
        let broadCastBarItem:UIBarButtonItem=UIBarButtonItem(customView: broadCastIcon) //UIBarButtonItem(title: "settings", style: UIBarButtonItemStyle.Plain, target: self, action: "actionOpenSettings")
        
        broadCastBarItem.tintColor=UIColor.white
        
        
        return broadCastBarItem;
        
    }

   
    // Dynemic Cell Height Calculation
    open static func getTempleteCellSize() -> CGSize{
        
        if  UIDevice.current.userInterfaceIdiom == .pad{
            
            let tempWidth:CGFloat = ScreenSize.SCREEN_WIDTH - 30.0;
            
            let theWidth:CGFloat = tempWidth / 3.0;
            
           // let theHeight:CGFloat = theWidth * 1.8;
            
            return CGSize(width: theWidth, height: theWidth)
            
        }
        
        let tempWidth:CGFloat = ScreenSize.SCREEN_WIDTH-30;
        
        let theWidth:CGFloat = tempWidth / 2.0;
        
       // let theHeight:CGFloat = theWidth * 1.8;
        
        return CGSize(width: theWidth, height: theWidth)
    }
   
    open static func getNavigationbarTitleView(_ target: AnyObject,action: Selector) -> UILabel{
    
        let titleView = UILabel()
        titleView.font = UIUtil.getBoldFont(15)
        titleView.textColor = UIColor.white
        titleView.textAlignment = NSTextAlignment.center
        let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        titleView.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: width, height: 500))
        
        let recognizer = UITapGestureRecognizer(target: target, action:action)
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
        
        return titleView
    }
    open static func recursiveUserInteractability(_ view:UIView,interactable:Bool) {

      //  if view.isKindOfClass(UITextField) {

        //    (view as! UITextField).enabled = interactable;

       // }else {

            view.isUserInteractionEnabled = interactable;

      //  }

        for subView in view.subviews {

            recursiveUserInteractability(subView , interactable: interactable)

        }

    }

    

    open static func getImageFromView(_ view:UIView) -> UIImage {

       

            UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);

        view.layer.render(in: UIGraphicsGetCurrentContext()!);

        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;

        

            UIGraphicsEndImageContext();

            

            return img;

        

    }

    open static func getImageFromCollectionView(_ view:UICollectionView) -> UIImage {

        var frame:CGRect = view.frame;

        let oldHeight = frame.size.height;


        frame.size.height = view.contentSize.height;

        view.frame = frame;

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 2.0)

        view.layer.render(in: UIGraphicsGetCurrentContext()!);

       let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;

        UIGraphicsEndImageContext();

        //shrink the table view as it were

        frame.size.height = oldHeight;

        view.frame = frame;

        return img;

    }

  
    open static func getBackView(_ backImage:String,_frame:CGRect)-> UIView{

        let associateBackViewForBarItem:UIView? = UIView(frame:_frame);

        let backIcon:UIImageView = UIImageView(frame: _frame);

        backIcon.contentMode = UIViewContentMode.scaleAspectFit

        backIcon.image=UIImage(named:backImage);

        associateBackViewForBarItem?.addSubview(backIcon)

        return associateBackViewForBarItem!;
    }

    

    open static func getBackViewForBarItem(_ target: AnyObject, action: Selector,backImage:String="back_icon.png") -> UIBarButtonItem {

        let backAssociate:UIView = getBackView(backImage, _frame:CGRect(x: 0, y: 0, width: 20, height: 30));

        backAssociate.isUserInteractionEnabled = true;

        backAssociate.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))

        let backViewForBarItem:UIBarButtonItem=UIBarButtonItem(customView: backAssociate)
        
        backViewForBarItem.tintColor=UIColor.white

        return backViewForBarItem
    }

    open static func getImageViewForBarItem(_ target: AnyObject, action: Selector,image:String,width:Int=20) -> UIBarButtonItem {
        
        let backAssociate:UIView = getBackView(image, _frame:CGRect(x: 0, y: 0, width: width, height: width));
        
        backAssociate.isUserInteractionEnabled = true;
        
        backAssociate.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        
        let backViewForBarItem:UIBarButtonItem=UIBarButtonItem(customView: backAssociate)
        
        backViewForBarItem.tintColor=UIColor.white
        
        return backViewForBarItem
        
    }
    
    
    
    
    
    open static func addCardShadow(_ view:UIView) {

        let shadowPath = UIBezierPath(rect: view.bounds);

        view.layer.masksToBounds = false;

        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor;

        view.layer.shadowOffset = CGSize(width: 0.0, height: 5.0);

        view.layer.shadowOpacity = 0.2;

        view.layer.shadowPath = shadowPath.cgPath;

    }

    open static func addCardShadow(_ view:UIView,offset:CGSize) {

        let shadowPath = UIBezierPath(rect: view.bounds);

        view.layer.masksToBounds = false;

        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor;

        view.layer.shadowOffset = offset;

        view.layer.shadowOpacity = 0.2;

        view.layer.shadowPath = shadowPath.cgPath;

    }

    open static func addCardShadow(_ view:UIView,offset:CGSize,boundsDelta:CGRect) {

        let sizeRect:CGRect = CGRect(x: view.bounds.origin.x + boundsDelta.origin.x, y: view.bounds.origin.y + boundsDelta.origin.y, width: view.bounds.size.width + boundsDelta.size.width, height: view.bounds.size.height + boundsDelta.size.height)

        let shadowPath = UIBezierPath(rect: sizeRect);

        view.layer.masksToBounds = false;

        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor;

        view.layer.shadowOffset = offset;

        view.layer.shadowOpacity = 0.2;

        view.layer.shadowPath = shadowPath.cgPath;

    }

    open static func addCardShadow(_ view:UIView,offset:CGSize,boundsDelta:CGRect,opacity:Float) {

        let sizeRect:CGRect = CGRect(x: view.bounds.origin.x + boundsDelta.origin.x, y: view.bounds.origin.y + boundsDelta.origin.y, width: view.bounds.size.width + boundsDelta.size.width, height: view.bounds.size.height + boundsDelta.size.height)

        let shadowPath = UIBezierPath(rect: sizeRect);

        

        view.layer.masksToBounds = false;

        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor;

        view.layer.shadowOffset = offset;

        view.layer.shadowOpacity = opacity;

        view.layer.shadowPath = shadowPath.cgPath;

    }

    open static func addPasswordView(_ to:UITextField,target:AnyObject,action:Selector,tag:NSInteger=PASSWORD_VIEW_TAG) {
        
        let theLeftView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 28))
        
        let rightImage:UIImageView = UIImageView(frame: CGRect(x:0, y: 0, width: 25, height: 25));
        
        rightImage.image = UIImage(named: "ic_pass.png");
        
        rightImage.highlightedImage =  UIImage(named:  "ic_showpass.png");
        
        rightImage.isUserInteractionEnabled = true;
        
        rightImage.tag = tag;
        
        rightImage.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
 
        theLeftView.addSubview(rightImage);
        
        to.rightView = theLeftView;
        
        to.rightViewMode = UITextFieldViewMode.always;
    }
    
    open static func addLeftImage(_ to:UITextField,named:String) {

        let theLeftView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 28))

        let theLeftImage:UIImageView = UIImageView(frame: CGRect(x: 6, y: 2, width: 24, height: 24));

        theLeftImage.image = UIImage(named: named);

        theLeftView.addSubview(theLeftImage);

        to.leftView = theLeftView;

        to.leftViewMode = UITextFieldViewMode.always;

    }

    
   
    open static func imageScaleDown(_ image:UIImage) -> UIImage{

        
        let maxWidth : CGFloat = 800;
        let maxHeight : CGFloat = 800;
        
        let oldWidth:CGFloat = image.size.width;

        let oldHeight:CGFloat = image.size.height;

        if oldWidth <= maxWidth && oldHeight <= maxHeight {

            return image;

        }

                

        let scaleFactor:CGFloat = (oldWidth > oldHeight) ? maxWidth / oldWidth : maxHeight / oldHeight;

                

        let newHeight:CGFloat = oldHeight * scaleFactor;

        let newWidth:CGFloat = oldWidth * scaleFactor;

        let newSize:CGSize = CGSize(width: newWidth, height: newHeight);
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!;
    }
    fileprivate static var placeholderProductImage:UIImage? = nil;
    open static func getPlaceholderProductImage() -> UIImage {
        if placeholderProductImage == nil {
            placeholderProductImage = UIImage(named: "loading_icon")!;
        }
        return placeholderProductImage!;
    }
    
    fileprivate static var placeholderPersonImage:UIImage? = nil;
    open static func getPlaceholderPersonImage() -> UIImage {
        if placeholderPersonImage == nil {
            placeholderPersonImage = UIImage(named: "photo_icon.png")!;
        }
        return placeholderPersonImage!;
    }
    fileprivate static var placeholderLoadingBag:UIImage? = nil;
    open static func getPlaceholderLoadingBag() -> UIImage {
        if placeholderLoadingBag == nil {
            placeholderLoadingBag = UIImage(named: "animated_loading_bag.gif")!;
        }
        return placeholderLoadingBag!;
    }
    fileprivate static var placeholderLoadingCircular:UIImage? = nil;
//    public static func getPlaceholderLoadingCircular() -> UIImage {
//        if placeholderLoadingCircular == nil {
//            placeholderLoadingCircular = UIImage(named: "animated_loading_circular.gif")!;
//        }
//        return placeholderLoadingCircular!;
//    }
}
