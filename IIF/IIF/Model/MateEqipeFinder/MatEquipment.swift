//
//  MatEquipment.swift
//  Mat. Quip Finder
//
//  Created by Kuldip Bhalodiya on 1/1/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class MatEquipment: NSObject {

    //var id:String? = nil;
    var companyName:String = ""
    var region:String = ""
    var city:String = ""
    var state:String = ""
    var year:String = ""
    var capacity:String = ""
    var url:String = ""
    
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        //id = json["Tech_Id"].string;
        if let company_Name = json["Company_Name"].string{
            companyName = company_Name;
        }
        if let aRegion = json["Region"].string{
            region = aRegion;
        }
        if let aCity = json["City"].string{
            city = aCity;
        }
        if let aState = json["State"].string{
            state = aState;
        }
        if let aYear = json["Estb_Year"].string{
            year = aYear;
        }
        if let aCapacity = json["Capacity"].string{
            capacity = aCapacity;
        }
        
        if let aURL = json["URL"].string{
            url = aURL;
        }
    }
    
    func getPDFUrl() -> URL{
        return URL(string:self.url.encodeURL()!)!
    }
}
