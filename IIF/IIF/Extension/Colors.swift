//
//  Colors.swift
//  OneHopIOS
//
//  Created by System Administrator on 5/10/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(red: Int, green: Int, blue: Int,opacity: Float) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(opacity))
    }
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    convenience init(hex:Int,opacity:Float) {
    
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff,opacity:opacity)
    }
 public static   func getRandomColor() -> Int{
        
    let array = [0xA6A8B5,0xC6CCB2,0xF5BFC5,0xC6DEE8,0x568794,0x72A7BF,0xFFE983,0xFFF2DE,0xC6CCB2,0xADC698,0xFBF8E5,0xFBF8E5,0xFFC07F,0xF2B8B3,0xBABAAB,0xC6CCB2,0xD0C9D0,0xDEDCE1,0xB2B09B,0xFFC07F,0xADC698,0x4CB5AE,0xD7AF70,0xB0AAA0,0xF5BFC5,0x568794,0xC481A4,0xA6A8B5,0xC6CCB2]
    
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
    
        return array[randomIndex]
    }
    public static   func getDarkRandomColor() -> Int{
        
        let array = [0x5E6AC0,0x25C4D9,0xEB3F79,0xED524E,0x27B5F5,0x25A499,0xFFA624]
        
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        
        return array[randomIndex]
    }
}

struct Colors {
    static let orange=0xF59320;
    static let blue=0x3F51B5
;
}
