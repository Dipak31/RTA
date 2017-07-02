//
//  RestAPI.swift
//  RoamingSE
//
//  Created by System Administrator on 12/28/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit

public enum HTTPMethod : String{
    case GET  = "GET"
    case POST = "POST"
    case PUT  = "PUT"
}
class RestAPI: NSObject {

    static func fetch(_ method:HTTPMethod,urlString:String,requestJSON:JSON?, completionHandler: @escaping (JSON?,String?) -> Swift.Void){
        
        let url:URL=URL(string: urlString)!;
        
        var request:URLRequest=URLRequest(url: url);
        
        request.httpMethod = method.rawValue;
        
        request.setValue("application/json", forHTTPHeaderField: String("Content-Type"));
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        if let data = requestJSON{
            let requestData = data.rawString()?.data(using: .utf8, allowLossyConversion: false);
            request.httpBody=requestData
            request.setValue("\(requestData?.count)",forHTTPHeaderField:String("Content-Length"));
        }
        
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 180.0;
        
        let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
        
        let task = session.dataTask(with: request, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                //print("error")
               // AlertUtil.showCustomAlertWithMessage("Your network is not rechable,Please try again!!!");
                completionHandler(nil,Message.FAILURE_MESSAGE)
                return;
            }
            let json=JSON(data: data!)
            
            if json.array != nil{
                completionHandler(json,nil)
            }else{
                //AlertUtil.showCustomAlertWithMessage("Your network is not rechable,Please try again!!!");
                completionHandler(nil,"Please try again")
            }
           
        })
        task.resume()
    }
}
    
  
