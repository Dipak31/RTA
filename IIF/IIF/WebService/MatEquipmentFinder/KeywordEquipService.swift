//
//  KeywordEquipService.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/4/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class KeywordEquipService: NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
    
    var responseData:NSMutableData=NSMutableData();
    
    var success : ((_ keywordList: [KeywordEquip])->())?
    var failure : ((_ errorMessage: String)->())?
    
    open func send() {
        
        let url:URL=URL(string: UrlConstants.EQUIP_KEYWORD_LIST)!;
        
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
            
            var keywords : [KeywordEquip] = [];
            
            for object in json{
                let keyword : KeywordEquip = KeywordEquip(json:object.1);
                keywords.append(keyword);
            }
            self.success?(keywords);
        })
        
        task.resume()
    }
}
