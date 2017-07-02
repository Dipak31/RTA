//
//  ViewController.swift
//  Casting Finder
//
//  Created by Dipak on 10/12/16.
//  Copyright © 2016 Dipak. All rights reserved.
//

import UIKit
import SafariServices

class FoundaryListController: UIViewController{
    
    static let applicationIdentify = 2
    
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet var imgAvertisment: UIImageView!
    @IBOutlet var lblNoRecord: UILabel!
    @IBOutlet var segFilter: UISegmentedControl!
    
    fileprivate var foundarys : [Foundary] = [];
    fileprivate var searchFoundarys : [Foundary] = [];
    fileprivate var refreshControl:UIRefreshControl? = nil;
    
    fileprivate var getFoundaryListService : GetFoundaryListService = GetFoundaryListService()
    fileprivate var advertisementService : AdvertisementService = AdvertisementService()
    fileprivate lazy var socialSharing:SocialSharing? = SocialSharing(vc:self);
    
     fileprivate var isSearch = false
    fileprivate var categoryName = ["Kwd","Author","PubMonth"]
    
    var metalIds : String = ""
    var combinationIds : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Foundary List";
        
        refreshControl = UIRefreshControl();
        refreshControl!.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged);
        tableVIew!.addSubview(refreshControl!);
        webServiceCallback();
        
        let backBarItem = UIUtil.getBackViewForBarItem(self, action: #selector(actionBack));
        self.navigationItem.leftBarButtonItem = backBarItem;
        
        tableVIew.rowHeight = UITableViewAutomaticDimension
        tableVIew.estimatedRowHeight = 120
        
        txtSearch.addTarget(self, action: #selector(actionText), for:.editingChanged);
        txtSearch.addTarget(self, action: #selector(actionFoucusOnText), for:.editingDidBegin);

        
//        let sharBarItem = UIUtil.getImageViewForBarItem(self, action:#selector(FoundaryListController.actionFilter), image: "filter.png");
//        self.navigationItem.rightBarButtonItem = sharBarItem;
        
    }
    var isFirstAppear : Bool = true;
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        if isFirstAppear{
            
            isFirstAppear = false;
            SVProgressHUD.show();
            refreshPull();
            
        }
    }
    
    //MARK: -Button Actions

    @IBAction func btnHomePressed(_ sender: Any) {
        
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            if vc is DashboardVC {
                _ = self.navigationController?.popToViewController(vc as! DashboardVC, animated: true)
            }
        }
    }
    @IBAction func buttonBackPressed(_ sender: Any) {
        actionBack()
    }
    @IBAction func buttonSearchPressed(_ sender: Any) {
        self.view.endEditing(true)
        actionText()
    }
    @IBAction func actionExportCSV(_ sender: Any) {
        var records = foundarys;
        
        if isSearch{
            records = searchFoundarys;
        }
        CSVExporter.generateCSVFor(records,self,"IndianCastingFinder");
    }
    //MARK: - Textfield Actions
    
    func actionText() {
        
        if txtSearch.text!.characters.count > 0{
            isSearch = true
            //isSearchViewHide(false);
            searchFoundarys = getArrayFromSelectedSegment(index: segFilter.selectedSegmentIndex)
            if searchFoundarys.count == 0{
                lblNoRecord.isHidden = false
            }else{
                lblNoRecord.isHidden = true
            }
            self.tableVIew.reloadData()
            return
        }
        //isSearchViewHide(true);
        isSearch = false;
        lblNoRecord.isHidden = true
        //techPapers = allTechPapers;
        self.tableVIew.reloadData();
    }
    
    func actionFoucusOnText(){
        
        if txtSearch.text!.characters.count > 0{
            txtSearch.text = ""
            //isSearchViewHide(true);
            isSearch = false;
            lblNoRecord.isHidden = true
            //techPapers = allTechPapers;
            self.tableVIew.reloadData();
        }
    }
    
    func getArrayFromSelectedSegment(index: NSInteger) -> [Foundary]{
        
        switch index {
        case 0:
            return foundarys.filter{$0.companyName!.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace())}
            //break
            
        case 1:
            return foundarys.filter{$0.city!.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace())}
            //break
            
        case 2:
            return foundarys.filter{$0.state!.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace())}
           // break
            
        case 3:
            return foundarys.filter{$0.region!.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace())}
            //break
            
        default:
            return foundarys
            //break
        }
    }
    
    @IBAction func segChangeFilter(_ sender: UISegmentedControl) {
        
        if txtSearch.text!.characters.count > 0{
            isSearch = true
            //isSearchViewHide(false);
            searchFoundarys = getArrayFromSelectedSegment(index: segFilter.selectedSegmentIndex)
            if searchFoundarys.count == 0{
                lblNoRecord.isHidden = false
            }else{
                lblNoRecord.isHidden = true
            }
            self.tableVIew.reloadData()
        }
    }
    
    // MARK: - FUNCTION
    
    func refreshPull(){
        
        if NetworkReachability.isConnectedToNetwork(){
            
            refreshControl?.beginRefreshing();
            getFoundaryListService.send(metalIds:metalIds,combinationIds:combinationIds)
        }else{
            refreshControl?.endRefreshing();
            refreshControl?.beginRefreshing();
        }
    }
    
    //advertisment
    func refreshAdvertisment(metalIds:String,combinationIds:String){
        
        advertisementService.send(appId: "\(FoundaryListController.applicationIdentify)", inpIdA: metalIds, inpIdB: combinationIds)
    }

    func actionBack(){
        _ = self.navigationController?.popViewController(animated: true);
    }
    
    func actionFilter(){
    
        let actionSheet = UIAlertController(title: "", message: "Search By", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let regionAction = UIAlertAction(title: "Region", style: UIAlertActionStyle.default) { (action) -> Void in
            
          
        }
        
        let cityAction = UIAlertAction(title: "City", style: UIAlertActionStyle.default) { (action) -> Void in
        
            
        }
        

        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        actionSheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem;
        actionSheet.popoverPresentationController?.sourceView = self.view;
        actionSheet.addAction(regionAction);
        actionSheet.addAction(cityAction);
        actionSheet.addAction(dismissAction);
        
        self.present(actionSheet, animated: true, completion: nil)

    }
    
    func webServiceCallback(){
        
        getFoundaryListService.success = { (foundaryList:[Foundary]) in
            SVProgressHUD.dismiss();
            self.refreshControl?.endRefreshing();
            
            self.foundarys = foundaryList
            self.tableVIew.reloadData()
            
            if self.foundarys.count == 0{
                self.lblNoRecord.isHidden = false
            }else{
                self.lblNoRecord.isHidden = true
            }
            
            //call for Advertisment
            self.refreshAdvertisment(metalIds: self.metalIds, combinationIds: self.combinationIds)
        }
        getFoundaryListService.failure = { (errorMessage:String) in
            SVProgressHUD.dismiss();
            self.refreshControl?.endRefreshing();
            
            print(errorMessage)
        }
        
        //Advertisment service responce
        advertisementService.success = { (advertList:[Advertisement]) in
            SVProgressHUD.dismiss();
            
            var aryImage = [UIImage]()
            for advertImg in advertList{
                // Advertisement
                if let url = NSURL(string: advertImg.advtImg!) {
                    if let data = NSData(contentsOf: url as URL) {
                        aryImage.append(UIImage(data: data as Data)!)
                    }
                }
            }
            
            self.imgAvertisment.animationImages = aryImage
            self.imgAvertisment.animationDuration = Double(aryImage.count)*5.0
            self.imgAvertisment.startAnimating()
            
            
        }
        
        advertisementService.failure = { (errorMessage:String) in
            print(errorMessage)
            SVProgressHUD.dismiss();
            self.refreshControl?.endRefreshing();
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension FoundaryListController : UITableViewDelegate,UITableViewDataSource{

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch{
            return searchFoundarys.count
        }
        return foundarys.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FoundaryListCellIdentifier, for: indexPath) as! FoundaryListCell
        
        if isSearch{
            cell.foundary = searchFoundarys[indexPath.row];
        }else{
            cell.foundary = foundarys[indexPath.row];
        }
        cell.initialize();
        
        if !cell.isActionViewSet{
            cell.isActionViewSet = true;
            cell.btnView.addTarget(self, action: #selector(actionViewPDFFile), for: .touchUpInside)
        }
        if !cell.isActionShareSet{
            cell.isActionShareSet = true;
            cell.btnShare.addTarget(self, action: #selector(actionShare), for: .touchUpInside)
        }
        
        
        
        return cell;
    }
    func actionViewPDFFile(sender:UIButton){
        
        let theCell : FoundaryListCell? = sender.getCellInstance() as? FoundaryListCell;
        
        if theCell != nil{
            
            let pdfUrl = URL(string:theCell!.foundary!.url!);
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: pdfUrl!)
                self.present(svc, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                // pdfUrl = UrlConstants.GOOGLE_DOC_VIEW_PDF + pdfUrl;
                UIApplication.shared.openURL(pdfUrl!)
            }
        }
    }
    func actionShare(sender:UIButton){
        
        let theCell : FoundaryListCell? = sender.getCellInstance() as? FoundaryListCell;
        if theCell != nil{
            
            let pdfUrl = theCell!.foundary!.url!
            socialSharing?.shareFile(file: pdfUrl);
            
        }
    }

}
