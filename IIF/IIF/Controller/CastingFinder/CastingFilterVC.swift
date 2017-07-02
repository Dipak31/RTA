//
//  ViewController.swift
//  Casting Finder
//
//  Created by Dipak on 10/12/16.
//  Copyright © 2016 Dipak. All rights reserved.
//

import UIKit


class CastingFilterVC: UIViewController{
    
    static let applicationIdentify = 2
    
     @IBOutlet var imgAdvertisment: UIImageView!
    
    fileprivate var filterList : [Filter] = [];
    fileprivate var sectionIndex : Int = -1;
    
    fileprivate var refreshControl:UIRefreshControl? = nil;

    fileprivate var getFiltersService : GetFiltersService = GetFiltersService();
    
    fileprivate var advertisementService : AdvertisementService = AdvertisementService()
    
    @IBOutlet weak var tableVIew: UITableView!
    public var tutorial : Tutorial? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Foundary Search";
              
        refreshControl = UIRefreshControl();
        refreshControl!.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged);
        tableVIew!.addSubview(refreshControl!);
        
        
        // tutorial screen
        if !AppLifeState.getCastingFinderSplash()!{
            //AppLifeState.setCastingFinderSplash(true); // first time tutorial screen
            self.showTutorial(indentifierValue: 2,tutorial:tutorial!);
        }
    }
    
    fileprivate var isFirstAppear : Bool = true;
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated);
        
        if isFirstAppear{
            isFirstAppear = false;
            initWebServiceCallBack();
            refreshPull();
        }
    }
   
    func refreshPull(){
    
        if NetworkReachability.isConnectedToNetwork(){
            refreshControl?.beginRefreshing();
           // SVProgressHUD.show()
            getFiltersService.send();
        }else{
            refreshControl?.endRefreshing();
        }
    }
    public func showTutorial(indentifierValue : Int,tutorial:Tutorial){
        
      
        
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:TutorialViewController.self)) as!  TutorialViewController
        vc.indentifierValue = indentifierValue;
        vc.tutorial = tutorial;

        vc.actionCallBack = {
            
            if AppLifeState.isShowCastingFinderAppReview(){
                self.showRatingView(appName: Constants.IIF_FOUNDRY_CASTING_FINDER_SUBTIT,appId:"2");
            }
         
        }
        let navVc = UINavigationController(rootViewController: vc);
        navVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navVc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        navVc.navigationBar.isHidden = true;
        APP_DELEGATE?.rootViewController().present(navVc, animated: false, completion: nil);
    }
    //advertisment
    func refreshAdvertisment(metalIds:String,combinationIds:String){
        
        advertisementService.send(appId: "\(CastingFilterVC.applicationIdentify)", inpIdA: metalIds, inpIdB: combinationIds)
    }
    
    var advertiseList : [Advertisement] = [];
    var index : Int = 0;
    func initWebServiceCallBack(){
    
        getFiltersService.success = { (filters:[Filter]) in
            SVProgressHUD.dismiss()
            self.sectionIndex = -1;
            self.refreshControl?.endRefreshing();
            self.filterList = filters;
            self.tableVIew.reloadData();
            
            //for advertisment image
            self.refreshAdvertisment(metalIds: "0", combinationIds: "0")
        }
        getFiltersService.failure = {(errorMessage:String)in
            SVProgressHUD.dismiss()
            self.refreshControl?.endRefreshing();
        }
        
        //Advertisment service responce
        advertisementService.success = { (advertList:[Advertisement]) in
            SVProgressHUD.dismiss();
            self.advertiseList = advertList;
//            var aryImage = [UIImage]()
//            for advertImg in advertList{
//                // Advertisement
//                if let url = NSURL(string: advertImg.advtImg!) {
//                    if let data = NSData(contentsOf: url as URL) {
//                        aryImage.append(UIImage(data: data as Data)!)
//                    }
//                }
//            }
//            
//            self.imgAdvertisment.animationImages = aryImage
//            self.imgAdvertisment.animationDuration = Double(aryImage.count)*5.0
//            self.imgAdvertisment.startAnimating()
            
            if advertList.count > 0{
                Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(self.imageAnimation), userInfo: nil, repeats: true)
            }

        }
        
        advertisementService.failure = { (errorMessage:String) in
            print(errorMessage)
            SVProgressHUD.dismiss();
            self.refreshControl?.endRefreshing();
        }
        
    }
    func imageAnimation(){
        print(index);
        
        
        if let url = NSURL(string: advertiseList[index].advtImg!) {
            if let data = NSData(contentsOf: url as URL) {
                self.imgAdvertisment.image = UIImage(data:data as Data);
            }
        }
        index += 1;
        
        if index >= advertiseList.count{
            index = 0;
        }
    }
    @IBAction func actionBannerClick(_ sender: Any) {
        
        if advertiseList[index].advtUrl != nil{
            UIApplication.shared.openURL(advertiseList[index].advtUrl!);
        }
    }
    @IBAction func actionBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true);

    }
    @IBAction func actionSearch(_ sender: Any) {
        
        var combinationIds : [String] = [];
        var metalIds : [String] = [];

        let metalCasting = filterList.filter({$0.header!.removeSpace().lowercased() == Constants.METAL_IDENTIFIER.removeSpace().lowercased()});
        
        if metalCasting.count > 0{
            
            let isMetalChildSelected = metalCasting[0].child.filter({$0.isSelected == true});
            
            if isMetalChildSelected.count <= 0{
                AlertUtil.showCustomAlertWithMessage("Please Select \(Constants.METAL_IDENTIFIER)");
                return;
            }
        }else{
            return;
        }
        
        
        for filter in filterList{
            
            let selectedFilters = filter.child.filter({$0.isSelected == true});
            for object in selectedFilters{
                    
                if object.header!.removeSpace().lowercased() == Constants.METAL_IDENTIFIER.removeSpace().lowercased(){
                    metalIds.append(object.id!);
                }else{
                    combinationIds.append(object.id!);
                }
            }
        }
        
        print(metalIds);
        print(combinationIds);

        let storyBoard = StoryBoard.MAIN.Instance();
        let foundryVc =  storyBoard.instantiateViewController(withIdentifier:String(describing:FoundaryListController.self)) as! FoundaryListController;
        foundryVc.metalIds = metalIds.joined(separator: ",");
        foundryVc.combinationIds = combinationIds.joined(separator: ",");
        self.navigationController?.pushViewController(foundryVc, animated: true);

    }
       override func didReceiveMemoryWarning() {
      
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension CastingFilterVC : UITableViewDelegate,UITableViewDataSource{

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterList[section].child.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if filterList[indexPath.section].isHeaderSelected!{
            return 35;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 35;
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        guard let headerCell = Bundle.main.loadNibNamed("FilterHeaderView", owner: nil, options: nil)?.first as? FilterHeaderView else {
            return nil
        }
        headerCell.contentView.backgroundColor = UIColor.red;
        
        if headerCell.actionHeader == nil{
            headerCell.actionHeader = UITapGestureRecognizer(target: self, action: #selector(CastingFilterVC.actionHeader))
            headerCell.background.addGestureRecognizer( headerCell.actionHeader);
        }
        headerCell.section = section;
        headerCell.lblTitle.text = filterList[section].header;
        //headerCell.setCollapsed(collapsed: section == sectionIndex ? false : true);

        //   headerCell.initialize();
        return headerCell;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCellIdentifier, for: indexPath) as! FilterTableViewCell
        
        let filterModel =  filterList[indexPath.section].child[indexPath.row];
        
        cell.filter = filterModel;
        
        cell.initialize();
        
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let theCell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell;
        
        if theCell?.filter?.header == Constants.METAL_IDENTIFIER{
        
            let metalCasting = filterList.filter({$0.header!.removeSpace().lowercased() == Constants.METAL_IDENTIFIER.removeSpace().lowercased()});
            if metalCasting.count > 0{
                
                let isMetalChildSelected = metalCasting[0].child.filter({$0.isSelected == true});
                
                if isMetalChildSelected.count > 0{
                    
                    for filter in isMetalChildSelected{
                        filter.isSelected = false;
                        for child in filter.child{
                            child.isSelected = false;
                        }
                    }
                    theCell?.filter?.isSelected = !(theCell?.filter?.isSelected)!;

                    self.tableVIew.reloadData();
                    return;
                }
            }
        }
        
        theCell?.filter?.isSelected = !(theCell?.filter?.isSelected)!;
        theCell?.initialize();
        
    }
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        
//        if indexPath.section == sectionIndex && sectionIndex == 1{
//            let theCell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell;
//            theCell?.filter?.isSelected = !(theCell?.filter?.isSelected)!;
//            theCell?.initialize();
//        }
//    }
    func actionHeader (_ sender : UITapGestureRecognizer){
        
        let theCell : FilterHeaderView? = sender.getCellInstance() as? FilterHeaderView;
        
//        if sectionIndex == theCell!.section{
//            return;
//        }
        
        if filterList[theCell!.section!].isHeaderSelected!{
            
            filterList[theCell!.section!].isHeaderSelected! = false;
            
        }else{

            for headerFilter in filterList{
                headerFilter.isHeaderSelected = false;
            }
            filterList[theCell!.section!].isHeaderSelected! = true;

        }

        tableVIew.reloadData();
        

    }

}
