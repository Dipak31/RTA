//
//  KeywordEquip.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/2/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class KeywordEquip: NSObject {

    var id:String? = "";
    var name:String? = "";
    
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        id = json["Id"].string;
        name = json["Value"].string;
    }
}
