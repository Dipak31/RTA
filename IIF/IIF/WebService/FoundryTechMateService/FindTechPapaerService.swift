//
//  GetUserCommandService.swift
//  OneHop
//
//  Created by Nishant on 12/10/15.
//  Copyright © 2015 OneHop. All rights reserved.
//

import Foundation


open class FindTechPapaerService : NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
        
    var responseData:NSMutableData=NSMutableData();
    
    var success : ((_ techPaperList: [TechPaper])->())?
    var failure : ((_ errorMessage: String)->())?

    open func send(id:String) {
        
        let url:URL=URL(string: UrlConstants.FIND_TECH_PAPER_BY_ID(id.encodeURL()!))!;
        
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

            var techPapers : [TechPaper] = [];
            
            for object in json{
                if object.1.stringValue.lowercased() == ""{
                    let techPaper : TechPaper = TechPaper(json:object.1);
                    techPapers.append(techPaper);
                }
            }
            
            self.success?(techPapers);
        })
        
        task.resume()
    }
   }
