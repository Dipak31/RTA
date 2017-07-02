//
//  File.swift
//  OneHop
//
//  Created by System Administrator on 7/27/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//

import Foundation


extension Date {
    
    func getFormattedDate () -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: self)
    }
    
    func getPickerDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short;
        return formatter.string(from: self)
    }
    
    func getCurrentMillis()->Double{
        return  NSDate().timeIntervalSince1970 * 1000
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
    }
}

