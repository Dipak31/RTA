//
//  TutorialService.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/4/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class TutorialService: NSObject ,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
    
    var responseData:NSMutableData=NSMutableData();
    
    var success : ((_ tutorial: [Tutorial])->())?
    var failure : ((_ errorMessage: String)->())?
    
    open func send(id:String) {
        
        let url:URL=URL(string: UrlConstants.FIND_TUTORIAL_BY_ID(id.encodeURL()!))!;
        
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
            var appList : [Tutorial] = [];
            if (json.array != nil && json.array!.count > 0){
                
                for app in json{
                    let tutorial : Tutorial = Tutorial(json:app.1);
                    appList.append(tutorial);
                }
                self.success?(appList);
            }
                    })
        
        task.resume()
    }
}
