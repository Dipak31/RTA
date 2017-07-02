//
//  GetUserCommandService.swift
//  OneHop
//
//  Created by Nishant on 12/10/15.
//  Copyright © 2015 OneHop. All rights reserved.
//

import Foundation


open class GetFoundaryListService : NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
        
    var responseData:NSMutableData=NSMutableData();
    
    var success : ((_ foundaryList: [Foundary])->())?
    var failure : ((_ errorMessage: String)->())?

    open func send(metalIds:String,combinationIds:String) {
        
        let url:URL=URL(string: UrlConstants.GET_FOUNDARY_LIST(metalIds,combinationIds))!;
        
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

            var foundarys : [Foundary] = [];
            
            for object in json{
                if object.1.stringValue.lowercased() == ""{
                    let foundary : Foundary = Foundary(json:object.1);
                    foundarys.append(foundary);
                }
            }
            self.success?(foundarys);
        })
        
        task.resume()
    }
   }
