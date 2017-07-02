//
//  DiscountModel.swift
//  OneHop
//
//  Created by System Administrator on 8/2/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//city

import Foundation

public class Foundary : NSObject{
    
    var companyName:String? = nil;
    var city:String? = nil;
    var state : String? = nil;
    var region:String? = nil;
    var year:String? = nil;
    var capacity:String? = nil;
    var url:String? = nil;


    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    override init(){
    
    }
    public init(json: JSON) {
        
        companyName = json["Company_Name"].string;
        city = json["City"].string;
        state = json["State"].string;
        region = json["Region"].string;
        year = json["Estb_Year"].string;
        capacity = json["Capacity"].string;
        url = json["URL"].string;

    }

    
  
}
