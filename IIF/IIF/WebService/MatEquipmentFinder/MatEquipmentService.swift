//
//  MatEquipmentService.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/4/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class MatEquipmentService: NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
    
    var responseData:NSMutableData=NSMutableData();
    
    var success : ((_ techPaperList: [MatEquipment])->())?
    var failure : ((_ errorMessage: String)->())?
    
    open func send(id:String) {
        
        let url:URL=URL(string: UrlConstants.FIND_MAT_EQUIMENT_BY_ID(id.encodeURL()!))!;
        print(url);
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
            
            var techPapers : [MatEquipment] = [];
            
            for object in json{
                if object.1.stringValue.lowercased() == ""{
                    let techPaper : MatEquipment = MatEquipment(json:object.1);
                    techPapers.append(techPaper);
                }
            }
            
            self.success?(techPapers);
        })
        
        task.resume()
    }
}
