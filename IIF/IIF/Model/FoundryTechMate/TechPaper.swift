//
//  DiscountModel.swift
//  OneHop
//
//  Created by System Administrator on 8/2/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//

import Foundation



open class TechPaper : NSObject{
    
    var id:String? = nil;
    var subject:String = "";
    var pubName:String = ""
    var pubId:String? = nil;
    var pubVol:String? = nil;
    var pubNo:String? = nil;
    var pubMonth:String = ""
    var fileName:String? = nil;

    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        id = json["Tech_Id"].string;
        if let tech_sub = json["Tech_Sub"].string{
            subject = tech_sub;
        }
        if let pub_Month = json["Pub_Month"].string{
            pubMonth = pub_Month;
        }
        if let pub_Name = json["Pub_Name"].string{
            pubName = pub_Name;
        }
        pubId = json["Tech_PubId"].string;
        pubVol = json["Tech_PubVol"].string;
        pubNo = json["Pub_No"].string;
        fileName = json["File_Name"].string;

    }
    
    func getPDFUrl() -> URL{
        return URL(string:UrlConstants.PDF_FILE_BASEAPI + self.fileName!.encodeURL()!)!
    }
}
