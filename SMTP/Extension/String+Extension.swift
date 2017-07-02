//
//  String + Extension.swift
//  OneHop
//
//  Created by System Administrator on 11/23/15.
//  Copyright © 2015 OneHop. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    func addAttributedString(matchTxt:String,color:UIColor) -> NSMutableAttributedString{
        
        let range = (self.lowercased()   as NSString).range(of: matchTxt.lowercased())
        
        let attributedString = NSMutableAttributedString(string:self)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color , range: range)
        attributedString.addAttribute(NSFontAttributeName, value: UIUtil.getBoldFont(15) , range: range)

        return attributedString;
    }
    
    func charcterCount () -> String{
        return String(self.characters.count);
    }
    func Instance () -> UIStoryboard{
        return  UIStoryboard(name:self, bundle: nil)
    }
    func heightForString (_ lblWidth : CGFloat , font : UIFont) -> CGFloat
    {
        if self.isEmpty{
            return 0;
        }
        let rect = NSString(string: self).boundingRect(with: CGSize(width: lblWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    func getSizeForText(_ width:CGFloat,height:CGFloat,font:UIFont) -> CGSize{
        
        let textSize = CGSize(width: width, height: height)
        let tempView = UILabel()
        tempView.text = self
        tempView.font =  font
        tempView.numberOfLines = 0
        
        let size = tempView.sizeThatFits(textSize)
        
        return size;
    }
    
    func StoryBoardInstance () -> UIStoryboard{
        return  UIStoryboard(name:self, bundle: nil)
    }
    func viewController(_ storyBoard:UIStoryboard) -> AnyObject{
        return storyBoard.instantiateViewController(withIdentifier: self)
    }
   
    func isEqualTo(text:String) -> Bool{
        
        if self.removeWhitespace().caseInsensitiveCompare(text.removeWhitespace()).rawValue == 0 {
            return true;
        }
        return false;
    }
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
        
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    func getHeight(_ width:CGFloat,_ font:UIFont) -> CGSize{
        
        let textSize = CGSize(width: width, height: 10000.0);
        let tempView = UILabel();
        tempView.text = self;
        tempView.font =  font;
        tempView.numberOfLines = 0;
        tempView.sizeToFit();

        let size = tempView.sizeThatFits(textSize)
        
        return size;
    }
//    func occurrencesOfString(_ aString:String) -> Int {
//        
//        var occurrences: Int = 0
//        
//        var range : Range<String.Index>? = self.characters.indices
//        
//        while range != nil
//        {
//            range = self.range(of: aString, options: NSString.CompareOptions.caseInsensitive, range: range, locale: nil)
//            
//            if range != nil{
//                
//                range = range!.upperBound..<self.endIndex
//                
//                occurrences += 1
//            }
//        }
//        return occurrences
//    }
    func encodeURL() -> String?
    {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    func haslinkContaint() -> String {
        
        var link : String = "";
        
        if self.isEmpty{
            return link;
        }
        
        let attributedString = NSMutableAttributedString(string:self)
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: attributedString.string, options: [], range: NSRange(location: 0, length: attributedString.string.utf16.count))
        
        for match in matches {
            
            link = (attributedString.string as NSString).substring(with: match.range)
            
        }
        return link;
    }
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    

}
