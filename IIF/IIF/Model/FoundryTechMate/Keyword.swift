//
//  DiscountModel.swift
//  OneHop
//
//  Created by System Administrator on 8/2/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//

import Foundation



open class Keyword : NSObject{
    
    var id:String? = nil;
    var name:String? = nil;
    var keyword:String? = nil;
    var catName:String? = nil;
    
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        id = json["Kwd_Id"].string;
        name = json["Kwd_Name"].string;
        keyword = json["kwd"].string;
        catName = json["CatName"].string
    }
 
}
