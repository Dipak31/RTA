//
//  KeywordEquip.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/2/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class KeywordEquip: NSObject {

    var id:String? = nil;
    var name:String? = nil;
    
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        id = json["Kwd_Id"].string;
        name = json["Kwd_Name"].string;
    }
}
