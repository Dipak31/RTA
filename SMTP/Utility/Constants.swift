//
//  Constants.swift
//  Walkins
//
//  Created by System Administrator on 8/16/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
public struct StoryBoard {
    public static let MAIN:String = "Main";
    public static let COMMON:String = "Common";
}
public struct StoryBoardID {
   
    public static let DRAWER_VC:String = "KYDrawerController";
    
}

public struct Constants {

    public static let CORNER_RADIUS:CGFloat = 5;
    public static let BORDER_WIDTH:CGFloat = 1;

    
    public static let productIdToIdentifier: [Int64:String] = [
        0   : ProductIdentifier.allStroke.rawValue,
        146 : ProductIdentifier.serve.rawValue,
        145 : ProductIdentifier.forehand.rawValue,
        143 : ProductIdentifier.doubleHandedBackhand.rawValue,
        142 : ProductIdentifier.slice.rawValue,
        141 : ProductIdentifier.returnForehand.rawValue,
        139 : ProductIdentifier.doubleHandedBackhandReturn.rawValue,
        137 : ProductIdentifier.backhandvolley.rawValue,
        211 : ProductIdentifier.footworkAndPointPlay.rawValue
    ]

}
