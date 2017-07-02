//
//  Advertisement.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/8/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class Advertisement: NSObject {
    
    var advtImg:String? = nil;
    var advtUrl:URL? = nil;

    
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    override init(){
        
    }
    public init(json: JSON) {
        
        advtImg = json["Advt_Img"].string
        
        if let url = json["Advt_Url"].string{
            advtUrl = URL(string:url);
        }
        
    }
}
