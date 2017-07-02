//
//  GetUserCommandService.swift
//  OneHop
//
//  Created by Nishant on 12/10/15.
//  Copyright © 2015 OneHop. All rights reserved.
//

import Foundation


public protocol GetStrokeServiceDelegate : class {
    func getStrokeSuccess(_ strokes:[Stroke]);
    func getStrokeFailure(_ errorMessage:String);
}

public class GetStrokeService : NSObject,NSURLConnectionDataDelegate,NSURLConnectionDelegate{
        
    var responseData:NSMutableData=NSMutableData();
   weak var delegate:GetStrokeServiceDelegate? = nil;
    
    public func send(strokeName:String,delegate:GetStrokeServiceDelegate,startImmediately:Bool=true) {
        
        self.delegate = delegate;
        
        RestAPI.fetch(.GET, urlString: UrlConstants.GET_STROKE(strokeName), requestJSON: nil, completionHandler:{ (reponseJSON,error) in
            
            if reponseJSON == nil{
                
                self.delegate?.getStrokeFailure(error!);
                
            }else{
                
                var strokes : [Stroke] = [];
                
                for object in reponseJSON!{
//                    let stroke : Stroke = Stroke(json:object.1);
//                    strokes.append(stroke);
                }
                self.delegate?.getStrokeSuccess(strokes);
            }
        });

    }
}
