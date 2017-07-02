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
    
    func insert(seperator: String, afterEveryXChars: Int) -> String {
        var output = ""
        self.characters.enumerated().forEach { index, c in
            if index % afterEveryXChars == 0 && index > 0 {
                output += seperator
            }
            output.append(c)
        }
        return output
    }
    func getStoryBoard () -> UIStoryboard{
        return  UIStoryboard(name:self, bundle: nil)
    }
    func viewController(_ storyBoard:UIStoryboard) -> AnyObject{
        return storyBoard.instantiateViewController(withIdentifier: self)
    }

    func removeSpace() -> String{
        
        let trimmedString = self.trimmingCharacters(in: .whitespaces)

        return trimmedString;
    }
    func removeWhitespace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluate(with: self){
            return true;
        }
        AlertUtil.showCustomAlertWithMessage("Invalid Email Address", msg:"")

        return false;
    }
    
     func canDialNumber() -> Bool {
        
        let dialStr:String = "tel://5252552"
        
        let dialUrl:URL? = URL(string:dialStr);
        
        if dialUrl != nil {
            
            return UIApplication.shared.canOpenURL(dialUrl!)
            
        }
        
        return false;
        
    }
    
    func dialNumber(){
        
        let phNo = self.replacingOccurrences(of: " ", with: "") ;
        
        let dialStr:String = "tel://\(phNo))"
        
        let dialUrl:URL? = URL(string:dialStr);
        
        if dialUrl != nil {
            
            if UIApplication.shared.canOpenURL(dialUrl!) {
                
                UIApplication.shared.openURL(dialUrl!);
            }
        }
    }
    
    func encodeURL() -> String?
    {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    func isEmptyText(_ alertMsg:String) -> Bool{
        
        if self.isEmpty{
            AlertUtil.showCustomAlertWithMessage(alertMsg, msg:"")
            return true;
        }

        return false;
    }
    
    func addAttributedString(matchTxt:String,color:UIColor) -> NSMutableAttributedString{
        
        let range = (self.lowercased()   as NSString).range(of: matchTxt.lowercased())
        
        let attributedString = NSMutableAttributedString(string:self)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color , range: range)
        attributedString.addAttribute(NSFontAttributeName, value: UIUtil.getBoldFont(15) , range: range)

        return attributedString;
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
    
    func Instance () -> UIStoryboard{
        return  UIStoryboard(name:self, bundle: nil)
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
