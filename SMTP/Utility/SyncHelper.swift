//
//  SocialSharing.swift
//  Bhakti Radio
//
//  Created by System Administrator on 12/5/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit
import CoreData

enum SyncStatus : String{
    case sync = "sync";
    case delete = "delete";
}
protocol SyncHelperDelegate : class{
    
    func syncCompletationHandler(_ isSuccess:Bool);
}
class SyncHelper: NSObject{

    static var isProcessing : Bool = false;
    weak var  delegate : SyncHelperDelegate? = nil;
    
    //ComplitationHandler
    var completionHandler: ((_ isSuccess:Bool) -> ())?

    func syncStrokeList(delegate:SyncHelperDelegate?){
        
        self.delegate = delegate;
        
        RestAPI.fetch(.GET, urlString:UrlConstants.GET_STROKE("Getstroke"), requestJSON: nil, completionHandler:{ (reponseJSON,error) in
            
            //print("Got Stroke Response");
            if reponseJSON == nil{
                
                SyncHelper.isProcessing = false;
                self.delegate?.syncCompletationHandler(false);
                
                //self.completionHandler?(false);
            }else{
                let localRecords = Stroke.getAllRecord();
                
                var remoteIds : [Int64] = [];
                //print("Start syncStrokeList");
                
                //Fetch all remote records and Insert/Update to local database
                for object in reponseJSON!{
                    
                    if let strokesId = object.1["StrokesId"].int64{
                        
                        remoteIds.append(strokesId);
                        
                        let predicate = NSPredicate(format: "id = \(strokesId)")
                        let dbVideo = (localRecords as NSArray).filtered(using: predicate)
                        
                        let db = CoreDataHelper.getContext(Stroke.ENTITY_NAME, inBackground: false);
                        
                        var strokeModel : Stroke
                        if dbVideo.count > 0{
                            strokeModel = dbVideo[0] as! Stroke;
                        }else{
                            strokeModel = Stroke(entity: db.entity, insertInto: db.context);
                            strokeModel.id = strokesId;
                        }
                        if let accountType = object.1["AccountTypeId"].int64{
                            strokeModel.accountTypeId = accountType;
                            strokeModel.isPurchased = false;

                            if accountType == 2 {
                                if AppLifeState.isProductPurchased(strokeId:strokeModel.id){
                                    strokeModel.isPurchased = true;
                                }
                            }
                        }
                        
                        if let name = object.1["StrokeName"].string{
                            strokeModel.name = name;
                        }
                        if let image = object.1["Images"].string{
                            strokeModel.image = UrlConstants.IMAGE_URL + image.encodeURL()!;
                        }
                        if let sortName = object.1["ShortName"].string{
                            strokeModel.sortName = sortName;
                        }
                        if let womenImage = object.1["ImagesW"].string{
                            strokeModel.womenImage = UrlConstants.IMAGE_URL + womenImage.encodeURL()!;
                        }
                        if let menImage = object.1["ImagesM"].string{
                            strokeModel.menImage = UrlConstants.IMAGE_URL + menImage.encodeURL()!;
                        }
                        if let lockImage = object.1["LockImage"].string{
                            
                            strokeModel.lockImage = UrlConstants.IMAGE_URL + lockImage.encodeURL()!;
//                            if AppLifeState.isProductPurchased(strokeId:strokeModel.id){
//                                strokeModel.isPurchased = true;
//                            }else{
//                                if strokeModel.lockImage!.lowercased() == "lock.png"{
//                                    strokeModel.isPurchased = false;
//                                }
//                            }
                        }else{
                          //  strokeModel.isPurchased = false;
                        }
                        
                        db.coreDataHelper.saveContext(db.context)
                    }
                }
                //Fetch all local strokes records and delete with remote records.
                for stroke in localRecords{
                    
                    if !remoteIds.contains(stroke.id){
                        let predicate = NSPredicate(format: "id = \(stroke.id)")
                        let strokes = (localRecords as NSArray).filtered(using: predicate)
                        
                        if strokes.count > 0 {
                            //print("Delte");
                            (strokes[0] as! Stroke).deleteRecord();
                        }
                    }
                }
                //print("Complete Stroke Sync");
                self.delegate?.syncCompletationHandler(true);
            }
        });
    }
    
    func startVideoSync(delegate:SyncHelperDelegate){
    
        
        if SyncHelper.isProcessing{
            //print("processing")
            return;
        }
        self.delegate = delegate;

        SyncHelper.isProcessing = true;
        
        RestAPI.fetch(.GET, urlString:UrlConstants.GET_VIDEO, requestJSON: nil, completionHandler:{ (reponseJSON,error) in
            
            //print("Got Response");
            DispatchQueue.main.async {
                self.syncStrokeList(delegate: nil);
            }
            
            if reponseJSON == nil{
                
                SyncHelper.isProcessing = false;
                self.delegate?.syncCompletationHandler(false);

                //self.completionHandler?(false);
            }else{
                let localRecords = Video.getAllRecord();

                var remoteIds : [Int64] = [];
                //print("Start Syncing");
                
//                let queue1 = DispatchQueue(label: "com.appcoda.queue1", qos: DispatchQoS.background)
//                queue1.async {
//
//                }
//
                //Fetch all remote records and Insert/Update to local database
                for object in reponseJSON!{
                    
                    if let videoId = object.1["VideoId"].int64{
                        
                        remoteIds.append(videoId);
                        
                        let predicate = NSPredicate(format: "videoId = \(videoId)")
                        let dbVideo = (localRecords as NSArray).filtered(using: predicate)
                        
                        let db = CoreDataHelper.getContext(Video.ENTITY_NAME, inBackground: false);
                        
                        var videoModel : Video
                        if dbVideo.count > 0{
                            videoModel = dbVideo[0] as! Video;
                        }else{
                            videoModel = Video(entity: db.entity, insertInto: db.context);
                            videoModel.videoId = videoId;
                        }
                        if let duration = object.1["Duration"].string{
                            videoModel.duration = duration;
                        }
                        if let playerName = object.1["PlayerName"].string{
                            videoModel.playerName = playerName;
                        }
                        if let strokeImage = object.1["StrokeImage"].string{
                            
                            videoModel.strokeImage = UrlConstants.IMAGE_URL+strokeImage.encodeURL()!;
                        }
                        if let strokesId = object.1["StrokesId"].int64
                        {
                            videoModel.strokesId = strokesId;
                            //Check for stroke is purchased or not
                            videoModel.isPurchased = AppLifeState.isProductPurchased(strokeId: strokesId);
                        }
                        if let upgradeVideo = object.1["UpgradeVideo"].string{
                            videoModel.upgradeVideo = UrlConstants.IMAGE_URL+upgradeVideo.encodeURL()!;
                        }
                        if let isActive = object.1["IsActive"].bool{
                            videoModel.isActive = isActive;
                        }
                        if let createdDate = object.1["CreatedDate"].string{
                            videoModel.createdDate = createdDate;
                        }
                        if let playerImage = object.1["PlayerImages"].string{
                            videoModel.playerImages = UrlConstants.IMAGE_URL+playerImage.encodeURL()!;
                        }
                        if let videoSize = object.1["VideoSize"].string{
                            videoModel.videoSize = videoSize;
                        }
                        if let fileName = object.1["FileName"].string{
                            videoModel.fileName = fileName;
                        }
                        if let strokeName = object.1["StrokeName"].string{
                            videoModel.strokeName = strokeName;
                        }
                        if let code = object.1["Code"].string{
                            videoModel.code = code;
                        }
                        if let accountType = object.1["AccountType"].string{
                            if accountType.lowercased() == "free"{
                                videoModel.isPurchased = true;
                            }
                            videoModel.accountType = accountType;
                        }
                        if let quality = object.1["Quality"].string{
                            videoModel.quality = quality;
                        }
                        if let viewId = object.1["ViewId"].int64{
                           // print(viewId);
                            videoModel.viewId = viewId;
                        }
                        if let viewName = object.1["ViewName"].string{
                            videoModel.viewName = viewName;
                        }
                        if let thumbnail = object.1["Thumbnail"].string{
                            videoModel.thumbnail = UrlConstants.VIDEO_THUMBNAIL_URL+thumbnail.encodeURL()!;
                        }
                        
                        if let originalFileName = object.1["OriginalFileName"].string{
                            videoModel.originalFileName = originalFileName;
                        }
                        if let favorite = object.1["Favourite"].string{
                            videoModel.favorite = favorite;
                        }
                        if let playerId = object.1["PlayerId"].int64{
                            videoModel.playerId = playerId;
                        }
                        
                        
                        db.coreDataHelper.saveContext(db.context)
                        
                    }else{
                        //print("Video Id NULL")
                    }
                }
                
                //Fetch all local records and delete with remote records.
                for video in localRecords{
                    
                    if !remoteIds.contains(video.videoId){
                        let predicate = NSPredicate(format: "videoId = \(video.videoId)")
                        let dbVideo = (localRecords as NSArray).filtered(using: predicate)
                        
                        if dbVideo.count > 0 {
                            //print("Delte");
                            (dbVideo[0] as! Video).deleteRecord();
                        }
                    }
                }
                //print("Complete Sync");
                SyncHelper.isProcessing = false;
                self.delegate?.syncCompletationHandler(true);
              //  self.completionHandler?(true);

            }
        });
    }
    
}
