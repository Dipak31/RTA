//
//  GetUserCommandService.swift
//  OneHop
//
//  Created by Nishant on 12/10/15.
//  Copyright © 2015 OneHop. All rights reserved.
//

import Foundation


open class GetKeywordListService : NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
        
    var responseData:NSMutableData=NSMutableData();
    
    var success : ((_ keywordList: [Keyword])->())?
    var failure : ((_ errorMessage: String)->())?

    open func send() {
        
        let url:URL=URL(string: UrlConstants.KEYWORD_LIST)!;
        
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

            var keywords : [Keyword] = [];
            
            for object in json{
                let keyword : Keyword = Keyword(json:object.1);
                keywords.append(keyword);
            }
            self.success?(keywords);
        })
        
        task.resume()
    }
   }
