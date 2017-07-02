//
//  DiscountModel.swift
//  OneHop
//
//  Created by System Administrator on 8/2/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//

import Foundation

public class Filter : NSObject{
    
    var id:String? = nil;
    var header:String? = nil;
    var isSelected : Bool? = false;
    var child : [Filter] = [];
    var value:String? = nil;
    var isHeaderSelected : Bool? = false;


    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    override init(){
    
    }
    public init(json: JSON) {
        
        id = json["Id"].string;
        header = json["Header"].string;
        value = json["Value"].string;
      
    }

    
  
}
