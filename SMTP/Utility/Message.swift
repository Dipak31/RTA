//
//  MessageUtil.swift
//  OneHop
//
//  Created by System Administrator on 10/6/15.
//  Copyright©2015 OneHop. All rights reserved.
//

import Foundation

open class Template {
    
   open static func getRakshabandhan(bizName:String) -> String{
        
        return bizName+" wishes you happy Rakhi!! Visit our store today and avail the special Raki discount of XY%. Offer valid till stock lasts! Thank You"
    }
  open static func getNavratri(bizName:String) -> String{
        
        return "Special Navratri Offer!!! Save UpTo 20% on store wide collection for 10 days!! Visit "+bizName+" today. Thank You"
    }
   open static func getDiwali(bizName:String) -> String{
        
        return "Wish You & Your Family A Very Happy Diwali in advance!!! New festive collection is added!! Visit "+bizName+" today. Thank You"
    }
  open static func get50off(bizName:String) -> String{
        
       return "FLAT 50% OFF!!! "+bizName+" presents End of season SALE!! Grab the fastest style faster. Visit "+bizName+" today. Thank You"
    }
   open static func get20off(bizName:String) -> String{
        
        return "Get UpTo 20% off on "+bizName+"’s latest collection of <Product description>. Visit  "+bizName+" today @ Address. Thank you"
    }
}
 class Message {
    
    //Registration
     static let  PROVIDE_DETAILS:String = "Provide Details";
     static let  COUNTRY_NOT_SELECTED_MESSAGE:String = "Please select country";
    
     static let  EMPTY_PHONE_NO_FOR_INDIA_COUNTRY:String = "Please enter 10 digit phone number";
     static let  INVALID_VERIFICATION_CODE_TITLE:String = "Invalid verification code";
     static let  INVALID_VERIFICATION_CODE_MESSAGE:String = "Please enter valid verification code";

     static let NO_INTERNET_CONNECTION:String = "No Internet Connection";
     static let NO_INTERNET_CONNECTION_MESSAGE:String = "Please check your internet connection and try again.";
    
     static let EMPTY_VERIFICATION_CODE_TITLE:String = "Enter verification code";
     static let EMPTY_VERIFICATION_CODE_MESSAGE:String = "Please enter varification code provided via SMS";
    
    //BusinessInfo
     static let EMPTY_STORE_NAME:String = "Please enter store name";
     static let EMPTY_COMPOSE_TEXT:String = "Please enter message";

     static let  FAILURE_MESSAGE:String = " Sorry! Our system failed to execute your request. We request you to try again.";
    
     static let  TELEPHONY_NOT_ALLOWED:String = "Telephony feature is not available on your device"


    //Invite
     static let  CANCEL_INVITATION:String = "Are you sure you want to cancel this invitation?"

    //Contact Permission Disable
     static let  CONTACT_PERMISSION_DISABLE_TITLE:String = "Walkins Would Like to Access Your Contacts";
     static let  CONTACT_PERMISSION_DISABLE_MESSAGE:String = "Walkins syncs phone numbers and names from your address book to Walkins server. It helps Walkins find the right trusted local stores for you.";
    
    //Send SMS
     static let  SEND_MESSAGE_INFO:String = "A Message with up to 160 characters (including space and special characters) uses one SMS credit (Balance).\n\nIf the message is more than 160 characters,2 SMS credits are used for that message.Meaning the account balance is debited by 2 SMS.\n\nMaximum eligble limit per message is 306 characters.\n\nOnly ENGLISH language messages(Indian language messages)."
    
    //Business Info
     static let  SENDER_ID_INFO:String = "When you will broadcast any SMS OR when system will send auto-response SMS,This sender is will be displayed to SMS receiver.\n\nYou can use capital as well as small alphabets to create you six character sender ID.\n\nExample:\n  Valid sender IDS\n   ONEHOP,Onehop,onehop\n  Invalid sender IDs\n   1hoper,On-Hop,On hop \n";
    

}
