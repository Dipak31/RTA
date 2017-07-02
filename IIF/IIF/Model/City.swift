//
//  City.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/3/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class City: NSObject {

    var id:String? = nil;
    var city:String? = nil;
    var state:String? = nil;
    var region:String? = nil;
    
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        id = json["Id"].string;
        city = json["City"].string;
        state = json["State"].string;
        region = json["Region"].string;
    }
}
