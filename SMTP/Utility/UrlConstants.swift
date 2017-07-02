//
//  UrlConstants.swift
//  OneHopIOS
//
//  Created by System Administrator on 5/24/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//
//onehop-269197948.us-east-1.elb.amazonaws.com
import Foundation

open class UrlConstants{
    
    fileprivate static let PROTOCOL:String="http://";
   
    fileprivate static let SERVER_ADDR:String = PROTOCOL+"www.tennispro.co.in/api/";
 
    static let IMAGE_URL:String = PROTOCOL+"www.tennispro.co.in/images/";
    static let VIDEO_URL:String = PROTOCOL+"www.tennispro.co.in/videos/";
    static let VIDEO_THUMBNAIL_URL:String = PROTOCOL+"www.tennispro.co.in/Thumbnail/";
    
    static let GET_VIDEO:String = SERVER_ADDR+"videos/Infobyview?start=0&length=100000";
    
    
    open static func GET_STROKE(_ name:String) -> String{
        return SERVER_ADDR+"videos/\(name)"
    }
 
    open static func GET_BUSINESS(_ id:String) -> String{
        return SERVER_ADDR+"/"+"businesses/user/\(id)"
    }
   
   
}
