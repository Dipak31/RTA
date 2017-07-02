//
//  GetUserCommandService.swift
//  OneHop
//
//  Created by Nishant on 12/10/15.
//  Copyright © 2015 OneHop. All rights reserved.
//

import Foundation


open class SignUpService : NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
        
    var responseData:NSMutableData=NSMutableData();
    
    var signupSuccess : ((_ user: User)->())?
    var signupFailure : ((_ errorMessage: String)->())?

    open func send(user:User) {
        
        let url:URL=URL(string: UrlConstants.SIGNUP(user))!;
        
        var request:URLRequest=URLRequest(url: url);
    
        request.httpMethod = String("POST")
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate:nil, delegateQueue:OperationQueue.main)
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request, completionHandler: {
            (
            data, response, error) in
            
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                self.signupFailure?("Please Try Again");
                return
            }
            
            let json = JSON(data: data!)
            print("Signup Responce:\(json)")
            let user = User(json:json)
           
            self.signupSuccess?(user);
        })
        
        task.resume()
    }
   }
