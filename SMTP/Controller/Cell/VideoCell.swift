//
//  VideoCell.swift
//  SMTP
//
//  Created by Dipak on 04/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit
let VideoCellIdentifier = String(describing:VideoCell.self);

class VideoCell: UICollectionViewCell {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var upgradeImgv: UIImageView!
    @IBOutlet var progresView: UIProgressView!
    
    @IBOutlet weak var progressCount: UILabel!
    @IBOutlet var cancelButton: UIButton!
    var actionPlayVideo : UITapGestureRecognizer? = nil;
    var video : Video? = nil;
    var actionRemoveCell: ((_ theCell:VideoCell) -> ())?
    var actionDownloadVideo: ((_ theCell:VideoCell) -> ())?
    var actionCancelVideo: ((_ theCell:VideoCell) -> ())?

    func initialize(){

        if let name = video?.originalFileName{
            lblName.text = name;
        }else{
            lblName.text = "";
        }
        
        if let duration = video?.duration{
            lblDuration.text = duration;
        }else{
            lblDuration.text = "";
        }
        renderIsFavorite();
        renerIsDownload();
        
        if let image = video?.thumbnail{
            if let url = URL(string:image){
                imageView.kf.setImage(with: url)
            }
        }else{
            imageView.image = nil;
        }
        
        if video!.isPurchased{
            upgradeImgv.image = nil;
        }else{
            
            if let image = video?.upgradeVideo{
                if let url = URL(string:image){
                    upgradeImgv.kf.setImage(with: url)
                }
            }else{
                upgradeImgv.image = nil;
            }
        }
        
    }
    
    func renerIsDownload(){
        btnDownload.isSelected = video!.isDownloaded;
        btnDownload.isHidden = video!.isDownloaded;
        btnDelete.isHidden = !btnDownload.isHidden;
    }
    func renderIsFavorite(){
        btnFavorite.isSelected = video!.isFavorite;
    }
    @IBAction func actionFavorite(_ sender: Any) {
        
        self.video!.isFavorite = !self.video!.isFavorite;
        
//        if !self.video!.isFavorite{
//            actionRemoveCell?(self);
//        }
        actionRemoveCell?(self);

        self.video!.saveContext();
        renderIsFavorite();

    }
    
 
    @IBAction func actionCancelDownload(_ sender: Any) {
        
        actionCancelVideo?(self);
    }
    @IBAction func actionDownload(_ sender: Any) {
        
        if NetworkReachability.isConnectedToNetwork(){
            
            if !self.video!.isPurchased{
                //print("Video Not Purchased");
                redirectToPurchase();
                return;
            }
            actionDownloadVideo?(self);
            return;
            
            if let fileName = self.video?.originalFileName?.encodeURL(){
                let url = UrlConstants.VIDEO_URL+fileName
                //print(url);
                
                let fileManager = File_Manager();
                fileManager.video = self.video;
                fileManager.downloadVideo(url);
                
                fileManager.completationHandler = { destinationPath in
                    
                   // SVProgressHUD.showSuccess(withStatus: "Success");
                    //print("Video Download Complete");
                    self.video!.isDownloaded = true;
                    self.video!.saveContext();
                    self.renerIsDownload();
                }
            }
        }
    }
    func getVideoUrlString() -> String?{
    
        if let fileName = self.video?.originalFileName?.encodeURL(){
           return UrlConstants.VIDEO_URL+fileName;
        }
        return nil;
    }
    
    func redirectToPurchase(){
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:PurchaseController.self)) as!  PurchaseController
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        APP_DELEGATE?.rootViewController().present(vc, animated: true, completion: nil);
    }
}
