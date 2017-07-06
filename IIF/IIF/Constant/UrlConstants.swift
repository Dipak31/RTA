//
//  UrlConstants.swift
//  OneHopIOS
//
//  Created by System Administrator on 5/24/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//
//onehop-269197948.us-east-1.elb.amazonaws.com
import Foundation

open class UrlConstants{
    
    fileprivate static let SERVER_ADDR:String="http://iifindia.org/api/";
  
    open static let IPA_VERSION:Int = 1;
    
    open static let isBuildForProduction:Bool = true;
    
  
    // ---- END PRODUCTION -------
    
    open static let KEYWORD_LIST:String = SERVER_ADDR+"list_kwrds/";
    open static let EQUIP_KEYWORD_LIST:String = SERVER_ADDR+"eqpmnt_list/";
    open static let CITY_LIST:String = SERVER_ADDR+"city_master/";
    open static let PDF_FILE_BASEAPI:String = "http://iifindia.org/files/techpaper/"
    open static let GOOGLE_DOC_VIEW_PDF:String = "https://docs.google.com/viewer?url="
    
    open static func LOGIN(_ phoneNumber:String) -> String{
        return SERVER_ADDR+"login/?User_Login=\(phoneNumber)"
    }
    open static func RATING(_ appId:String,_ rating:String) -> String{
        return SERVER_ADDR+"star_ratings/?app_id=\(appId)&rating=\(rating)"
    }
    open static func SIGNUP(_ user:User) -> String{
        
        var city = "";
        var designation = "";
        var company = "";
        
        if let _city = user.city{
            city = _city;
        }
        if let _designation = user.designation{
            designation = _designation;
        }
        if let _company = user.company{
            company = _company;
        }
        let url = SERVER_ADDR+"registration/?name=\(user.name!)&email=\(user.email!)&city=\(city)&company=\(company)&designation=\(designation)&mobile=\(user.phoneNumber!)&user_id=\(user.id!)".removeWhitespace();
        
        return url;
    }
    open static let GET_CASTING_FILTER:String = SERVER_ADDR+"casting_filter/";
    open static func GET_FOUNDARY_LIST(_ metalId:String,_ combination_id:String) -> String{
        return SERVER_ADDR+"foundry_details/?metal_id=\(metalId)&combination_id=\(combination_id)&user_id=\(AppLifeState.getUserId()!)"
    }
    open static func FIND_TECH_PAPER_BY_ID(_ id:String) -> String{
        return SERVER_ADDR+"find_tech_paper/?kwd_id=\(id)&user_id=\(AppLifeState.getUserId()!)"
    }
    open static func FIND_MAT_EQUIMENT_BY_ID(_ id:String) -> String{
        return SERVER_ADDR+"material_equipment/?kwd_id=\(id)&user_id=\(AppLifeState.getUserId()!)"
    }
    open static func FIND_TUTORIAL_BY_ID(_ id:String) -> String{
        return SERVER_ADDR+"application_details/?app_id=\(id)"
    }
    open static func FIND_ADVERTISE_BY_ID(_ appId:String,inpIdA:String,inpIdB:String) -> String{
        return SERVER_ADDR+"advt_details/?app_id=\(appId)&inp1=\(inpIdA)&inp2=\(inpIdB)"
    }
   
   
}
