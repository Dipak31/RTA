//
//  GetUserCommandService.swift
//  OneHop
//
//  Created by Nishant on 12/10/15.
//  Copyright © 2015 OneHop. All rights reserved.
//

import Foundation


open class GetFiltersService : NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
        
    var responseData:NSMutableData=NSMutableData();
    
    var success : ((_ filters: [Filter])->())?
    var failure : ((_ errorMessage: String)->())?

    open func send() {
        
        let url:URL=URL(string: UrlConstants.GET_CASTING_FILTER)!;
        
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

            var filters : [Filter] = [];
            
            for object in json{
                let filter : Filter = Filter(json:object.1);
                
                //let existFilter = filters.filter({ $0.header == filter.header})
                
                let index : Int? = filters.index(where: { $0.header == filter.header})
                
                if index != nil && index != -1{
                    filters[index!].child.append(filter);
                }else{
                    filter.child.append(filter);
                    filters.append(filter);
                }
            }
            self.success?(filters);
        })
        
        task.resume()
    }
   }
