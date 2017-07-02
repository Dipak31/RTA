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
        
        SVProgressHUD.setDefaultMaskType(.black);
        SVProgressHUD.setBackgroundColor(UIColor.darkGray);
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
    open static func getBackView(_ backImage:String,_frame:CGRect)-> UIView{
        
        let associateBackViewForBarItem:UIView? = UIView(frame:_frame);
        
        let backIcon:UIImageView = UIImageView(frame: _frame);
        
        backIcon.contentMode = UIViewContentMode.scaleAspectFit
        
        backIcon.image=UIImage(named:backImage);
        
        associateBackViewForBarItem?.addSubview(backIcon)
        
        return associateBackViewForBarItem!;
    }
    open static func getImageViewForBarItem(_ target: AnyObject, action: Selector,image:String,width:Int=22) -> UIBarButtonItem {
        
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
  
}
