//
//  SocialSharing.swift
//  Bhakti Radio
//
//  Created by System Administrator on 12/5/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayer: NSObject{

    var viewController : UIViewController!
    
    init(vc:UIViewController) {
        viewController = vc;
    }
    
    class func playVideo(file:String,vc:UIViewController){
    
        var videoURL = URL(string: file)
        
        if let url = URL(string: file){
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString

            let fullPath = documentsPath.appendingPathComponent(url.lastPathComponent);
            let localUrl =  URL(fileURLWithPath:fullPath)

            var isDir : ObjCBool = false
            if FileManager.default.fileExists(atPath: localUrl.path, isDirectory: &isDir){
                videoURL = localUrl;
            }
        }
        
//         if let filePath = File_Manager.isFileExist(videoLink: file){
//            videoURL = URL(fileURLWithPath: filePath);
//        }

        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        vc.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

}
