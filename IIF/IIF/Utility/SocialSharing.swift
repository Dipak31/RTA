//
//  SocialSharing.swift
//  Bhakti Radio
//
//  Created by System Administrator on 12/5/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit
import Social
import MessageUI

class SocialSharing: NSObject,UIAlertViewDelegate{

    var viewController : UIViewController!
    
    init(vc:UIViewController) {
        viewController = vc;
    }
    
    func shareFile(file:String){
        // Configure a new action to show the UIActivityViewController
                    
        let activityViewController = UIActivityViewController(activityItems: [file], applicationActivities: nil)
                    
        activityViewController.excludedActivityTypes = [UIActivityType.mail]
                    
        self.viewController.present(activityViewController, animated: true, completion: nil)

    }
    
    func shareLink(link:String){
        // Configure a new action to show the UIActivityViewController
        
        let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [UIActivityType.mail]
        
        self.viewController.present(activityViewController, animated: true, completion: nil)
        
    }

}
