//
//  TutorialService.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/4/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class RatingService: NSObject ,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
    
    var responseData:NSMutableData=NSMutableData();
    
    var success : (()->())?
    var failure : (()->())?
    
    open func send(id:String,rating:String) {
        
        let url:URL=URL(string: UrlConstants.RATING(id,rating))!;
        
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
                self.failure?();
                return
            }
            self.success?();

    })
        
        task.resume()
    }
}
