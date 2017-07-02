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
open class StoryBoard {
    open static let MAIN:String = "Main";
    open static let COMMON_STORY_BOARD:String = "Common";

}
open class StoryBoardID {
    
    open static let FOUNDRY_TECHMATE:String = String(describing:FoundryTechMateVC.self);
    open static let CASTING_FILTER_VC:String = String(describing:CastingFilterVC.self);
    open static let MAT_EQUIP_VC:String     = String(describing:MatEquipFinderVC.self);

}

open class Constants {

    open static let CORNER_RADIUS:CGFloat = 5;
    open static let BORDER_WIDTH:CGFloat = 1;
    open static let NOTIFICATION_CATEGORY:String = "RoemaingSE";
    open static let ADD_NEW_ACTIVITY_NOTIFICATION:String = "activityAddNotification";
    open static let METAL_IDENTIFIER = "Metal Cast";
    
    open static let IIF_FOUNDRY_TECH_MATE_TITLE = "Foundray Tech Mate"
    open static let IIF_FOUNDRY_TECH_MATE_SUBTIT = "Mate"
    open static let IIF_FOUNDRY_CASTING_FINDER_TIT = "Finder"
    open static let IIF_FOUNDRY_CASTING_FINDER_SUBTIT = "Casting Finder"
    open static let IIF_FOUNDRY_Mat_EQUIP_TIT = "Finder"
    open static let IIF_FOUNDRY_Mat_EQUIP_SUBTIT = "Mat Quip"

}
