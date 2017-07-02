//
//  HomeViewController.swift
//  SMTP
//
//  Created by Dipak on 31/01/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import GoogleMobileAds
import Foundation


class HomeViewController: UIViewController,URLSessionDelegate,SyncHelperDelegate,GADBannerViewDelegate{
    
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnHQ: UIButton!
    @IBOutlet weak var lblVideoCount: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var downloadVideoImg: UIImageView!
    @IBOutlet weak var infoDialoge: UIView!
    @IBOutlet weak var deleteDialogue: UIView!
    @IBOutlet weak var lblDeleteFile: UILabel!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var advertise: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var constraintHeightAdvertise: NSLayoutConstraint!
    @IBOutlet weak var constraintlblMsgCenter: NSLayoutConstraint!
    @IBOutlet weak var constraintOfflineModeView: NSLayoutConstraint!
    @IBOutlet weak var lblStroke: UILabel!
    @IBOutlet weak var lblView: UILabel!
    @IBOutlet weak var lblPlayer: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblDownloadMsg: UILabel!
    
    @IBOutlet weak var bannerView: UIView!;
    

    var deleteCell : VideoCell? = nil;
    var reachability: Reachability?
    var isRechable : Bool = true;
    
    var videos : [Video] = [];
    var player : [Video] = [];
    //var allRecords : [Video] = [];

    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        adBannerView.adUnitID = "ca-app-pub-8501671653071605/1974659335"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        return adBannerView
    }()
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var activeDownloads = [String: Download]()
    var refreshControl : UIRefreshControl!;
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .red;
        refreshControl.addTarget(self, action: #selector(pullDownToRefresh), for: .valueChanged)
        collectionView.addSubview(refreshControl);
        
        initializeAdMob();
        setupReachability();
        startNotifier();
        
    }
    func pullDownToRefresh(){
        //print("Refresh");
        restHeder();
    }
    var isFirstAppear : Bool = true;
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if isFirstAppear{
            isFirstAppear = false;
           
        }
    }
    func hideAdvertiseIfAnyStrokeIsPurchasedOrOffline(){
        
        if AppLifeState.isAnyStrokePurchased() || !isRechable{
            //print("Advertise Unlock");
            constraintHeightAdvertise.constant = 0;
        }else{
            constraintHeightAdvertise.constant = 50;
        }
    }
    func setupReachability() {
        
        reachability = Reachability()
        
        reachability?.whenReachable = { reachability in
            DispatchQueue.main.async {
                //print("rechable")
                self.isRechable = true;
                self.btnDownload.isUserInteractionEnabled = true;
                self.constraintOfflineModeView.constant = 0;
                self.resetFilter();
//                self.reloadAllRecordsAndRefreshHeader();
                self.hideAdvertiseIfAnyStrokeIsPurchasedOrOffline();

                if let syncDate = UserDefaults.standard.object(forKey: AppLifeState.KEY_LASTSYNC_DATE){
                    if DeviceUtil.isMonthNextToCurrentMonth(syncDate: syncDate as! Date){
                        self.startSyncing();
                    }
                }else{
                    self.startSyncing();
                }
                
            }
        }
        reachability?.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                //print("Unrechable")
                self.isRechable = false;
                APP_DELEGATE!.filter = VideoFilter();
                //self.btnFavorite.isSelected = false;
                //self.btnHQ.isSelected = false;
                self.btnDownload.isSelected = true;
                self.btnDownload.isUserInteractionEnabled = false;
                
                APP_DELEGATE!.filter.isFavorite = self.btnFavorite.isSelected;
                APP_DELEGATE!.filter.isDownload = self.btnDownload.isSelected;
                APP_DELEGATE!.filter.isHq = self.btnHQ.isSelected ? "HQ" : nil;
                self.constraintOfflineModeView.constant = 45;
                APP_DELEGATE!.filter.isDownload = true;
                self.reloadAllRecordsAndRefreshHeader();
                self.hideAdvertiseIfAnyStrokeIsPurchasedOrOffline();

            }
        }
    }
    
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            //print("network can not rechable")
            refreshRecords();
        }
    }
    
    func initializeAdMob(){
        
        adBannerView.load(GADRequest())
        bannerView.addSubview(adBannerView);
    }
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        //print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    func startSyncing(){

        if NetworkReachability.isConnectedToNetwork(){
            
            if !SyncHelper.isProcessing{
                if !AppLifeState.getIsSyncDone()!{
                    SVProgressHUD.show(withStatus: "Please wait a moment while we get things set up");
                }
                let syncHelper : SyncHelper = SyncHelper();
                syncHelper.startVideoSync(delegate:self);
            }
        }
    }
    func syncCompletationHandler(_ isSuccess:Bool){
        DispatchQueue.main.async {
            //print("Finished")
            self.advertise.isHidden = true;
            SVProgressHUD.dismiss();

            if !AppLifeState.getIsSyncDone()!{
                AppLifeState.setIsSyncDone(true);
                self.resetFilter();
                if isSuccess{
                    self.view.bringSubview(toFront: self.infoDialoge);
                    self.infoDialoge.isHidden = false;
                    AppLifeState.setLastSyncDate()
                }else{
                    self.startSyncing();
                }
            }
        }
    }
    func refreshRecords(isResetScrollPosition:Bool=true){
        
        var predicates : [NSPredicate] = [];
        
        let filter = APP_DELEGATE!.filter;
        
        if filter.playerId != nil{
            predicates.append(NSPredicate(format: "playerId=\(filter.playerId!)"));
        }
        if filter.strokeId != nil{
            predicates.append(NSPredicate(format: "strokesId=\(filter.strokeId!)"));
        }
        if filter.viewId != nil{
            predicates.append(NSPredicate(format: "viewId=\(filter.viewId!)"));
        }
        if filter.gender != .menwomen{
            predicates.append(NSPredicate(format: "code = %@", filter.gender!.rawValue));
        }
        if filter.isHq != nil{
            predicates.append(NSPredicate(format: "quality = %@", filter.isHq!));
        }
        if filter.isDownload{
            predicates.append(NSPredicate(format: "isDownloaded == %@", NSNumber(booleanLiteral: true)));
        }
        if filter.isFavorite{
            predicates.append(NSPredicate(format: "isFavorite == %@", NSNumber(booleanLiteral: true)));
        }

        videos = Video.getAllRecord(predicates);
    
            //print("Videos-\(self.videos.count)")

            self.lblVideoCount.text = String(self.videos.count);
            self.collectionView.reloadData();
        
        if (isResetScrollPosition){
            self.collectionView.setContentOffset(CGPoint.zero, animated: true);
        }
           // self.collectionView.isHidden = self.videos.count > 0 ? false : true;
            self.displayEmptyVideoMsgWthSituation();
        
            refreshPlayers();

    }
  
    func resetFilter(){
        restHeder();
        reloadAllRecordsAndRefreshHeader();
    }
    
    func reloadAllRecordsAndRefreshHeader(){
        refreshRecords();
        renderFilterName();
    }
    func restHeder(){
        APP_DELEGATE!.filter.stroke = "ALL STROKES";
        APP_DELEGATE!.filter.strokeId = nil;
        APP_DELEGATE!.filter.player = "ALL PLAYERS";
        APP_DELEGATE!.filter.playerId = nil;
        APP_DELEGATE!.filter.views = "ALL VIEWS";
        APP_DELEGATE!.filter.viewId = nil;
        APP_DELEGATE!.filter.gender = .menwomen;
        reloadAllRecordsAndRefreshHeader();
    }
    
    func disableFilter(){
        
//        //print("ResetDisableFilter:\(activeDownloads.count)");
//        
        let flag : Bool = activeDownloads.count == 0 ? true : false;
        
      //  self.btnDownload.isUserInteractionEnabled = flag;
        self.btnHQ.isUserInteractionEnabled = flag;
        self.btnFavorite.isUserInteractionEnabled = flag;
        self.lblGender.isUserInteractionEnabled = flag;
        self.lblPlayer.isUserInteractionEnabled = flag;
        self.lblView.isUserInteractionEnabled = flag;
        self.lblStroke.isUserInteractionEnabled = flag;
    }
    func displayEmptyVideoMsgWthSituation(){
        
        downloadVideoImg.isHidden = true;
        lblDownloadMsg.isHidden = true;
        lblMsg.isHidden = false;
        
        if videos.isEmpty{
            
            var emptyVideoMsg = "No videos found.\nPlease try another filter combination";
            
            var predicates : [NSPredicate] = [];
            predicates.append(NSPredicate(format: "isDownloaded == %@", NSNumber(booleanLiteral: true)));
            let downloadedVideos = Video.getAllRecord(predicates);
            
            if downloadedVideos.count > 0 && btnDownload.isSelected{
                 emptyVideoMsg = "No downloaded videos found.\nPlease try another filter combination";
            }else if isRechable && btnDownload.isSelected{
                downloadVideoImg.isHidden = false;
                lblDownloadMsg.isHidden = false;
                lblMsg.isHidden = true;
                lblDownloadMsg.text = "Downloaded videos mode is on but you have not downloaded any videos.Please download some videos.";
            }else if !isRechable {
                downloadVideoImg.isHidden = false;
                lblDownloadMsg.isHidden = false;
                lblMsg.isHidden = true;
                lblDownloadMsg.text = "You are offline but you have not downloaded any videos.Please download some videos the next time you have a wifi connection";
            }
            
//            if isRechable && btnDownload.isSelected{
//                
//                emptyVideoMsg = "You have turned on ‘downloaded videos only’ mode but you have not yet downloaded any videos.\nIn order to view videos in this mode,  please download some videos the next time you have a wifi connection.";
//                
//            }else if !isRechable && btnDownload.isSelected{
//            
//                emptyVideoMsg = "You are offline but you have not downloaded any videos.\nPlease download some videos the next tiggme you have a wifi connection."
//            }
            lblMsg.text = emptyVideoMsg;
        }else{
            lblMsg.isHidden = true;
        }
    }
    func refreshPlayers(){
    
        //Fetch player by Gender filter
        var playerIds  : [Int64] = [];
//        var genderFilter : Gender? = APP_DELEGATE!.filter.gender;
//        
//        if genderFilter == .menwomen{
//            genderFilter = nil;
//        }
//        var isHqDlFavoriteSelected : Bool = false;
//    
//        for button in [btnHQ,btnDownload,btnFavorite]{
//            
//            if button!.isSelected{
//                isHqDlFavoriteSelected = true;
//            }
//        }
//        
//        allRecords = isHqDlFavoriteSelected ? videos : Video.getAllRecord();

        let filter = APP_DELEGATE!.filter;
        
        var predicates : [NSPredicate] = [];

        if filter.strokeId != nil{
            predicates.append(NSPredicate(format: "strokesId=\(filter.strokeId!)"));
        }
        if filter.viewId != nil{
            predicates.append(NSPredicate(format: "viewId=\(filter.viewId!)"));
        }
        if filter.gender != .menwomen{
            predicates.append(NSPredicate(format: "code = %@", filter.gender!.rawValue));
        }
        if filter.isHq != nil{
            predicates.append(NSPredicate(format: "quality = %@", filter.isHq!));
        }
        if filter.isDownload{
            predicates.append(NSPredicate(format: "isDownloaded == %@", NSNumber(booleanLiteral: true)));
        }
        if filter.isFavorite{
            predicates.append(NSPredicate(format: "isFavorite == %@", NSNumber(booleanLiteral: true)));
        }
        
        let allRecords = Video.getAllRecord(predicates);
        
        player = allRecords.filter({
            
//            if genderFilter != nil && genderFilter!.rawValue != $0.code && !isHqDlFavoriteSelected{
//                return false;
//            }
            if !playerIds.contains($0.playerId){
                playerIds.append($0.playerId);
                return true;
            }
            return false;
        });
        player.sort(by:{$0.0.playerName! < $0.1.playerName!});
        
        //print("Players Count - \(player.count)")
        refreshControl.endRefreshing();
    }
    func renderFilterName(){
        
        let filter = APP_DELEGATE!.filter;
        lblGender.text = APP_DELEGATE!.filter.gender!.rawValue;
        if filter.gender == .men{
            lblGender.text = "MEN";
        }else if filter.gender == .women{
            lblGender.text = "WOMEN";
        }
        lblPlayer.text = filter.player;
        lblStroke.text = filter.stroke;
        lblView.text = filter.views;
    }

    func showDeleteDialogue(){
        
        var title = "Delete";
        if let file = deleteCell?.video?.originalFileName{
            title = "Delete  " + file + " ?";
        }
        lblDeleteFile.text = title;
        self.view.bringSubview(toFront: self.deleteDialogue);
        self.deleteDialogue.isHidden = false;
    }
    func showAlertWithMsg(_ msg:String){
        AlertUtil.showCustomAlertWithMessage(msg);
    }
    func actionDelete(sender:UIButton){
        
        let theCell : VideoCell? = sender.getCellInstance() as? VideoCell;
        
        if theCell != nil {
            deleteCell  = theCell;
            if AppLifeState.getDeleteDialog() == true{
                deleteVideoFile();
            }else{
                showDeleteDialogue();
            }
        }
    }
    func deleteVideoFile(){
        
        //print("Video File Delete");
        deleteCell!.video!.isDownloaded = false;
        deleteCell!.video!.saveContext();
        deleteCell!.initialize();
        
        if let fileName = deleteCell?.video?.originalFileName?.encodeURL(){
            let url = UrlConstants.VIDEO_URL+fileName
            if let path = File_Manager.isFileExist(videoLink:url){
                AppLifeState.deleteFile(path)
            }
        }
        actionRemoveCell(cell: deleteCell!);
    }
    @IBAction func toggleSlideMenu(_ sender: Any) {
        
        let drawerController = self.navigationController?.parent as? KYDrawerController
        drawerController?.setDrawerState(.opened, animated: true);
    }
    
    @IBAction func actionDownload(_ sender: Any) {
        if isVideoDownloading(){
            return;
        }
        btnDownload.isSelected = !btnDownload.isSelected;
        APP_DELEGATE!.filter.isDownload = btnDownload.isSelected;
        if btnDownload.isSelected{
            restHeder();
           // showAlertWithMsg("Showing downloaded videos only");
        }
        refreshRecords();

    }
    
    @IBAction func actionFavorite(_ sender: Any) {
        if isVideoDownloading(){
            return;
        }
        btnFavorite.isSelected = !btnFavorite.isSelected;
        APP_DELEGATE!.filter.isFavorite = btnFavorite.isSelected;
        if btnFavorite.isSelected{
            restHeder();
           // showAlertWithMsg("Showing favorite videos only");
        }
        refreshRecords();

    }
    @IBAction func actionHQ(_ sender: Any) {
        if isVideoDownloading(){
            return;
        }
        btnHQ.isSelected = !btnHQ.isSelected;
        APP_DELEGATE!.filter.isHq = btnHQ.isSelected ? "HQ" : nil;
        if btnHQ.isSelected{
            restHeder();
            //showAlertWithMsg("Showing high quality videos only");
        }
        refreshRecords();

    }
    
    @IBAction func actionCancelDeleteDialog(_ sender: Any) {
        deleteDialogue.isHidden = true;
    }
    
    @IBAction func actionDeleteVideo(_ sender: Any) {
        
        AppLifeState.setDeleteDialog(btnCheckBox.isSelected);
        deleteVideoFile();
        self.deleteDialogue.isHidden = true;
        
    }
    
    @IBAction func actionDeletePrefranceToggle(_ sender: Any) {
        btnCheckBox.isSelected = !btnCheckBox.isSelected;
    }
    
    @IBAction func actionGender(_ sender: Any) {
        if isVideoDownloading(){
            return;
        }
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:GenderFilterController.self)) as!  GenderFilterController
        vc.disMissHandler = {
            self.reloadAllRecordsAndRefreshHeader();
        }
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        APP_DELEGATE?.rootViewController().present(vc, animated: true, completion: nil);

    }
    
    @IBAction func actionPlayer(_ sender: Any) {
        if isVideoDownloading(){
            return;
        }
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:PlayerFilterController.self)) as!  PlayerFilterController
        vc.disMissHandler = {
            self.renderFilterName();
            self.refreshRecords();
        }
        vc.players = player;
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        APP_DELEGATE?.rootViewController().present(vc, animated: true, completion: nil);
    }
    
    @IBAction func actionStroke(_ sender: Any) {
        if isVideoDownloading(){
            return;
        }
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:StrokeFIlterController.self)) as!  StrokeFIlterController
        vc.disMissHandler = {
            self.renderFilterName();
            self.refreshRecords();
        }
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        APP_DELEGATE?.rootViewController().present(vc, animated: true, completion: nil);

    }
    @IBAction func actionAllView(_ sender: Any) {

        if isVideoDownloading(){
            return;
        }
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:ViewFilterController.self)) as!  ViewFilterController
        vc.disMissHandler = {
            self.renderFilterName();
            self.refreshRecords();
        }
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        APP_DELEGATE?.rootViewController().present(vc, animated: true, completion: nil);
    }
    @IBAction func actionDialoge(_ sender: Any) {
        infoDialoge.isHidden = true;
    }
    
    func isVideoDownloading() -> Bool{
        
        if activeDownloads.count > 0{
            AlertUtil.showCustomAlertWithMessage("Please wait until you download finishes");
            return true;
        }
        return false;
    }
    func redirectToPurchase(){
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:PurchaseController.self)) as!  PurchaseController
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        vc.disMissHandler = { isStrokePurchased in
            //print("Purchased");
            self.hideAdvertiseIfAnyStrokeIsPurchasedOrOffline();
            let syncHelper : SyncHelper = SyncHelper();
            syncHelper.syncStrokeList(delegate:nil);
            self.startSyncing();
        }
        APP_DELEGATE?.rootViewController().present(vc, animated: true, completion: nil);
    }
    
//    deinit {
//        //print("--- stop notifier")
//        reachability?.stopNotifier()
//        reachability = nil
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,URLSessionDownloadDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.collectionView.bounds.size.width-16;
        return CGSize(width: width, height: 100);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCellIdentifier, for: indexPath) as? VideoCell
    
        cell!.video = videos[indexPath.row];
        
        cell?.btnDelete.addTarget(self, action: #selector(actionDelete), for: .touchUpInside);
        
        cell?.actionRemoveCell = ({ theCell in
            self.actionRemoveCell(cell: theCell);
        })
        cell?.actionDownloadVideo = ({ theCell in
            self.startDownload(theCell);
        })
        cell?.actionCancelVideo = ({ theCell in
            self.cancelDownload(theCell);
        })
        cell?.initialize();
        
        var showDownloadControls = false;
        let videoUrlStr = cell?.getVideoUrlString();
        
        if let download = activeDownloads[videoUrlStr!] {
            showDownloadControls = true;
            //print("VideoId-\(cell!.video!.videoId)");
            cell?.progresView.progress = download.progress;
            
        }
        if showDownloadControls{
            cell?.btnDownload.isHidden = true;
        }
        cell?.progresView.isHidden = !showDownloadControls;
        cell?.cancelButton.isHidden = !showDownloadControls;
        cell?.progressCount.isHidden = !showDownloadControls;
        
        return cell!;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let video = videos[indexPath.row] ;
        //print(video.videoURL());

        if video.isPurchased{
            VideoPlayer.playVideo(file:video.videoURL(), vc: self);
        }else{
            self.redirectToPurchase();
        }
        
    }
   
    func actionRemoveCell(cell:VideoCell){
        
//        let filter = APP_DELEGATE!.filter;
//        
//        if filter.isDownload || filter.isFavorite{
//        
//            //print("Delete Cell")
//            let indexPath = self.collectionView.indexPath(for: cell);
//            videos.remove(at: indexPath!.row);
//            collectionView.reloadData();
//        }
     //   disableFilter();
        refreshRecords(isResetScrollPosition: false);
    }
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                DispatchQueue.main.async(execute: {
                    completionHandler()
                })
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // 1
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString,
            let destinationURL = localFilePathForUrl(originalURL) {
            
            //print(destinationURL)
            
            // 2
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(at: destinationURL)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
            do {
                try fileManager.copyItem(at: location, to: destinationURL)
            } catch let error as NSError {
                //print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        
        // 3
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            activeDownloads[url] = nil
            // 4
            if let trackIndex = trackIndexForDownloadTask(downloadTask) {
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: trackIndex, section: 0);

                  //  let cell = self.collectionView.cellForItem(at: indexPath) as? VideoCell
                    //print("Download Flag Set true");
                    
                    self.videos[trackIndex].isDownloaded = true;
                    self.videos[trackIndex].saveContext();
                    
//                    cell!.video!.isDownloaded = true;
//                    cell!.video!.saveContext();

//                    if let cell = self.collectionView.cellForItem(at: indexPath) as? VideoCell {
//                                          }
                    self.collectionView.reloadItems(at:[indexPath])
                }
            }
        }
       // disableFilter();
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        // 1
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads[downloadUrl] {
            // 2
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            // 3
            // let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
            // 4
            if let trackIndex = trackIndexForDownloadTask(downloadTask), let videoCell = self.collectionView.cellForItem(at: IndexPath(row: trackIndex, section: 0)) as? VideoCell{
                DispatchQueue.main.async(execute: {
                    videoCell.progresView.progress = download.progress;
                   // //print("Progress \(download.progress*100)");
                    //print("ProgressId-\(videoCell.video!.videoId)");
                    videoCell.progressCount.text =  String(format: "%.0f%%",  download.progress * 100)
                })
            }
        }
    }
    func localFileExistsForTrack(_ cell: VideoCell) -> Bool {
        if let urlString = cell.getVideoUrlString(), let localUrl = localFilePathForUrl(urlString) {
            var isDir : ObjCBool = false
            //  if let path = localUrl.path {
            return FileManager.default.fileExists(atPath: localUrl.path, isDirectory: &isDir)
            //   }
        }
        return false
    }
    func localFilePathForUrl(_ videoUrlStr: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        if let url = URL(string: videoUrlStr){
            let fullPath = documentsPath.appendingPathComponent(url.lastPathComponent)
            return URL(fileURLWithPath:fullPath)
        }
        return nil
    }
    
    func trackIndexForDownloadTask(_ downloadTask: URLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            for (index, video) in videos.enumerated() {
                
                if let fileName = video.originalFileName?.encodeURL(){
                    if url == UrlConstants.VIDEO_URL+fileName{
                        return index;
                    }
                }
            }
        }
        //print("Index Does Not Matched");
        return nil
    }
    func startDownload(_ cell: VideoCell) {
        
        //print("Start Download");
        
        if let videoUrlStr = cell.getVideoUrlString(){
            //print(videoUrlStr);
            if  let url =  URL(string: videoUrlStr){
                
                let download = Download(url: videoUrlStr);
                // 2
                download.downloadTask = downloadsSession.downloadTask(with: url);
                // 3
                download.downloadTask!.resume();
                // 4
                download.isDownloading = true;
                // 5
                activeDownloads[download.url] = download;
                //print(cell.video!.videoId);
                let indexPath = self.collectionView.indexPath(for : cell);
                self.collectionView.reloadItems(at:[indexPath!]);

            }
        }
        //disableFilter();

    }
    func cancelDownload(_ cell: VideoCell) {
        //print("cancelDownload");
        
        if let urlString = cell.getVideoUrlString(),let download = activeDownloads[urlString] {
            download.downloadTask?.cancel()
            activeDownloads[urlString] = nil
        }
        
        let indexPath = self.collectionView.indexPath(for : cell);
        self.collectionView.reloadItems(at:[indexPath!]);
       // disableFilter();

    }

}
