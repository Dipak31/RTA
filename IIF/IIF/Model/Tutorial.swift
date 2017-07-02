//
//  Tutorial.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/4/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class Tutorial: NSObject{
    
    var id:String? = nil;
    var appId:String? = nil;
    var appName:String? = nil;
    var descrip:String? = nil;
    var advImg:String? = nil;
    var createProfileUrl : URL? = nil;
    var rating:String? = "0";
    var videoUrl : URL? = nil;
    var advertiseUrl : URL? = nil;
    
    convenience public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    public init(json: JSON) {
        id = json["Id"].string;
        appId = json["App_Id"].string;
        appName = json["App_Name"].string;
        descrip = json["Description"].string;
        advImg = json["Adv_Img"].string;
        rating = json["Rating"].string;

        if let addUrl = json["Advt_Url"].string{
            advertiseUrl = URL(string:addUrl);
        }
        if let url1 = json["Url1"].string{
            createProfileUrl = URL(string:url1);
        }
        if let url2 = json["Url2"].string{
            videoUrl = URL(string:url2);
        }
        
    }
}
