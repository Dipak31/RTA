//
//  NetworkReachability.swift
//  OneHop
//
//  Created by System Administrator on 10/3/15.
//  Copyright © 2015 OneHop. All rights reserved.
//

import Foundation
import SystemConfiguration

open class NetworkReachability {
    
     open static func isConnectedToNetwork () -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags =  SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            showAlertMsg();
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        if (isReachable && !needsConnection){
            return true;
        }
        showAlertMsg();

        return false;
        
    }
    
    open static func showAlertMsg(){
        AlertUtil.showCustomAlertWithMessage(Message.NO_INTERNET_CONNECTION, msg:Message.NO_INTERNET_CONNECTION_MESSAGE);
    }
   }
