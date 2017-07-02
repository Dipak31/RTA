//
//  AdvertisementService.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/8/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class AdvertisementService: NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
    
    var responseData:NSMutableData=NSMutableData();
    
    var success : ((_ advertise: [Advertisement])->())?
    var failure : ((_ errorMessage: String)->())?
    
    open func send(appId:String,inpIdA:String,inpIdB:String) {
        
        let url:URL=URL(string: UrlConstants.FIND_ADVERTISE_BY_ID(appId, inpIdA: inpIdA.encodeURL()!, inpIdB: inpIdB.encodeURL()!))!
        
        var request:URLRequest=URLRequest(url: url);
        
        request.httpMethod = String("GET")
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request, completionHandler: {
            (
            data, response, error) in
            
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                self.failure?("Please Try Again");
                return
            }
            
            let json = JSON(data: data!)
            print(json);
            var advertisements : [Advertisement] = [];
            
            if json.rawArray.count > 0{
                for object in json{
                    
                    let advertisement : Advertisement = Advertisement(json:object.1);
                    advertisements.append(advertisement);
                }
            }
            
            self.success?(advertisements);
        })
        
        task.resume()
    }
}
