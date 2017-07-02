//
//  DiscountModel.swift
//  OneHop
//
//  Created by System Administrator on 8/2/15.
//  Copyright (c) 2015 OneHop. All rights reserved.
//

import Foundation

public enum Gender : String {
    
    case men = "Men players"
    case women = "Women players"
    case menwomen = "MEN & WOMEN"

}

open class VideoFilter : NSObject {
    
    var strokeId:Int64? = nil;
    var gender:Gender? = .menwomen;
    var stroke : String? = "ALL STROKES"
    var player : String? = "ALL PLAYERS"
    var views: String? = "ALL VIEWS"
    var playerId : Int64? = nil;
    var viewId : Int64? = nil;
    var isFavorite : Bool = false;
    var isDownload : Bool = false;
    var isHq : String? = nil;

}
