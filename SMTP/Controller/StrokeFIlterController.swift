//
//  StrokeFIlterController.swift
//  SMTP
//
//  Created by Dipak on 03/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit

class StrokeFIlterController: UIViewController,SyncHelperDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var strokes : [Stroke] = [];
    fileprivate var refreshControl:UIRefreshControl? = nil;
    public var disMissHandler: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if APP_DELEGATE!.filter.gender == .men{
            strokes = APP_DELEGATE!.menStrokes;
        }else if APP_DELEGATE!.filter.gender == .women{
            strokes = APP_DELEGATE!.woMenStrokes;
        }else{
            strokes = APP_DELEGATE!.menWoMenStrokes;
        }
        
        refreshControl = UIRefreshControl();
        refreshControl!.addTarget(self, action: #selector(StrokeFIlterController.refreshPull), for: UIControlEvents.valueChanged);
        self.collectionView!.addSubview(refreshControl!);
       // SVProgressHUD.show();
        
        strokes = Stroke.getAllRecord();
        
        if DeviceUtil.isIpad(){
            
        }
    }
    // MARK: - FUNCTION
    func refreshPull(){
        
        if NetworkReachability.isConnectedToNetwork(displayAlert:false) && strokes.isEmpty{
            refreshControl!.beginRefreshing()
//            let getStrokesService : GetStrokeService = GetStrokeService();
//            var strokeKey = "Getstroke"
//            if APP_DELEGATE!.filter.gender == .men{
//                strokeKey = "getstrokemen"
//            }else if APP_DELEGATE!.filter.gender == .women{
//                strokeKey = "getstrokefemale"
//            }
//            getStrokesService.send(strokeName:strokeKey, delegate: self);
        }else{
            SVProgressHUD.dismiss();
            refreshControl?.endRefreshing();
        }
        let syncHelper : SyncHelper = SyncHelper();
        syncHelper.syncStrokeList(delegate:self);
    }
    var isFirstAppear : Bool = true;
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        if isFirstAppear{
            
            isFirstAppear = false;
            refreshPull();
            
        }
    }

    @IBAction func actionAllStroke(_ sender: Any) {
        APP_DELEGATE!.filter.stroke = "ALL STROKES";
        APP_DELEGATE!.filter.strokeId = nil;
        disMissHandler?();
        self.actionDisMiss();
    }
    @IBAction func actionClose(_ sender: Any) {
        self.actionDisMiss();
        
    }
    func syncCompletationHandler(_ isSuccess: Bool) {
        refreshControl?.endRefreshing();
        SVProgressHUD.dismiss();
        strokes = Stroke.getAllRecord();
        self.collectionView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension StrokeFIlterController : UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return strokes.count;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.collectionView.bounds.size.width/2-13;
        return CGSize(width: width, height: width*1.2);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StrokeCellIdentifier, for: indexPath) as? StrokeCell
        cell!.stroke = strokes[indexPath.row];
        cell!.initialize();
        
        return cell!;
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let stroke = strokes[indexPath.row];
        APP_DELEGATE!.filter.stroke = stroke.sortName!.uppercased();
        APP_DELEGATE!.filter.strokeId = stroke.id;

        disMissHandler?();

        self.actionDisMiss();
    }
}
