//
//  DiscountModel.swift
//  OneHop
//
//  Created by System Administrator on 8/2/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//

import Foundation

public class User : NSObject,NSCoding{
    
    var phoneNumber:String? = nil;
    var name : String? = nil;
    var email : String? = nil;
    var address : String? = nil;
    var city : String? = nil;
    var company : String? = nil;
    var designation : String? = nil;
    var id : Int? = nil;
    var otp : Int? = nil;
    
    
    override init(){
        
    }
    public init(json: JSON) {
        
        id = json["user_id"].intValue;
        name = json["name"].string;
        email = json["email"].string;
        city = json["city"].string;
        company = json["company"].string;
        designation = json["designation"].string;
        phoneNumber = json["phoneNumber"].string;
        otp = json["otp"].intValue;
        
    }
    public required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "user_id") as? Int
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.city = aDecoder.decodeObject(forKey: "city") as? String
        self.company = aDecoder.decodeObject(forKey: "company") as? String
        self.designation = aDecoder.decodeObject(forKey: "designation") as? String
        self.phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String
        self.otp = aDecoder.decodeObject(forKey: "otp") as? Int
        
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(id,forKey:"user_id");
        aCoder.encode(name,forKey:"name");
        aCoder.encode(city,forKey:"city");
        aCoder.encode(email,forKey:"email");
        aCoder.encode(company,forKey:"company");
        aCoder.encode(designation, forKey: "designation")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(otp,forKey:"otp");
    }
    
    
}
