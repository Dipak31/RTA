//
//  MatEquipFinderVC.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/2/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit
import SafariServices

class MatEquipFinderVC: UIViewController,UITextFieldDelegate {
    
    static let applicationIdentify = 3
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var techPaperTblView: UITableView!
    @IBOutlet var txtSearch: UITextField!
  
    @IBOutlet var lblNoRecord: UILabel!
    @IBOutlet var imgAdvertisment: UIImageView!
    @IBOutlet var segFilter: UISegmentedControl!
    
    fileprivate var keyWordList : [KeywordEquip] = [];
    fileprivate var searchKeyWord : [KeywordEquip] = [];
    fileprivate var currentKeyWord : KeywordEquip? = nil;
    
    fileprivate var techPapers : [MatEquipment] = [];
    fileprivate var allTechPapers : [MatEquipment] = [];
    fileprivate var searchTechPapers : [MatEquipment] = [];
    
    fileprivate var isSearch = false
    
    fileprivate var searchRefreshControl:UIRefreshControl? = nil;
    fileprivate var refreshControl:UIRefreshControl? = nil;
    
    fileprivate var keywordEquipService : KeywordEquipService = KeywordEquipService()
    fileprivate var matEquipmentService : MatEquipmentService = MatEquipmentService()
    fileprivate lazy var socialSharing:SocialSharing? = SocialSharing(vc:self);
    
    fileprivate var advertisementService : AdvertisementService = AdvertisementService()
    public var tutorial : Tutorial? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
     
        
        //set resfress controllers
        refreshControl = UIRefreshControl();
        refreshControl!.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged);
        techPaperTblView!.addSubview(refreshControl!);
        
        searchRefreshControl = UIRefreshControl();
        searchRefreshControl!.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged);
        searchTableView!.addSubview(searchRefreshControl!);
        
        searchTableView.keyboardDismissMode = .onDrag;
        
        techPaperTblView.rowHeight = UITableViewAutomaticDimension
        techPaperTblView.estimatedRowHeight = 90
        
        txtSearch.addTarget(self, action: #selector(actionText), for:.editingChanged);
        txtSearch.addTarget(self, action: #selector(actionFoucusOnText), for:.editingDidBegin);
        showSearchKeyword(isAnimate:false);
        
        //tutorial screen
        if !AppLifeState.getCastingFinderSplash()!{
            //AppLifeState.setCastingFinderSplash(true); // first time tutorial screen
            self.showTutorial(indentifierValue: 3,tutorial:tutorial!);
        }
        
        webServiceCallback()
    }
    
    var isFirstAppear : Bool = true;
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        if isFirstAppear{
            
            isFirstAppear = false;
           // SVProgressHUD.show();
           // keywordEquipService.send();
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated);
        
    }
    public func showTutorial(indentifierValue : Int,tutorial:Tutorial){
        
        
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:TutorialViewController.self)) as!  TutorialViewController
        vc.indentifierValue = indentifierValue
        vc.tutorial = tutorial;
        vc.actionCallBack = {
            print("CallBack");
                if AppLifeState.isShowMatQuipAppReview(){
                    self.showRatingView(appName: Constants.IIF_FOUNDRY_Mat_EQUIP_SUBTIT,appId: "3");
                }
        }
        let navVc = UINavigationController(rootViewController: vc);
        navVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navVc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        navVc.navigationBar.isHidden = true;
        APP_DELEGATE?.rootViewController().present(navVc, animated: false, completion: nil);
    }
    @IBAction func actionFilter(_ sender: Any) {
        showSearchKeyword(isAnimate:true);

    }
    func showSearchKeyword(isAnimate:Bool){
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:KeywordSearchViewController.self)) as!  KeywordSearchViewController
        vc.actionSearchKeyword = { (_ keyword:KeywordEquip) in
            self.currentKeyWord = keyword;
            SVProgressHUD.show();
            self.refreshTechPapers();
           
        }
        let navVc = UINavigationController(rootViewController: vc);
        navVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navVc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        navVc.navigationBar.isHidden = true;
        APP_DELEGATE?.rootViewController().present(navVc, animated: isAnimate, completion: nil);
    }
    // MARK: - FUNCTION
    func refreshPull(){
        
        if NetworkReachability.isConnectedToNetwork(){
            refreshTechPapers();
            
        }else{
            refreshControl?.endRefreshing();
            searchRefreshControl?.beginRefreshing();
        }
    }
    
    func refreshTechPapers(){
        
        if currentKeyWord == nil{
            matEquipmentService.send(id: "0");
        }else{
            matEquipmentService.send(id:currentKeyWord!.id!);
        }
        
    }
    func refreshAdvertisment(){
        
        if currentKeyWord == nil{
            advertisementService.send(appId: "\(MatEquipFinderVC.applicationIdentify)", inpIdA: "0", inpIdB: "0")
        }else{
            advertisementService.send(appId: "\(MatEquipFinderVC.applicationIdentify)", inpIdA: "\(currentKeyWord!.id!)", inpIdB: "0")
        }
    }
    
    
    func isSearchViewHide(_ flag : Bool){
        searchTableView.isHidden = flag;
        techPaperTblView.isHidden = !flag;
        //showSortingBarItem(flag);
    }
    
    //MARK :- Web Service
    var advertiseList : [Advertisement] = [];
    var index : Int = 0;
    
    func webServiceCallback(){
        
        keywordEquipService.success = { (keywordList:[KeywordEquip]) in
            self.searchRefreshControl?.endRefreshing();
            
            self.keyWordList = keywordList
            self.searchTableView.reloadData()
            self.refreshPull()
        }
        keywordEquipService.failure = { (errorMessage:String) in
            SVProgressHUD.dismiss();
            self.searchRefreshControl?.endRefreshing();
            
            print(errorMessage)
        }
        
        matEquipmentService.success = { (resultList:[MatEquipment]) in
            SVProgressHUD.dismiss();
            self.refreshControl?.endRefreshing();
            self.txtSearch.resignFirstResponder()
            self.techPapers = resultList

            if self.allTechPapers.isEmpty{
                self.allTechPapers =  self.techPapers;
            }
            self.techPaperTblView.reloadData()
            
            if resultList.count > 0{
                self.lblNoRecord.isHidden = true
            }else{
                self.lblNoRecord.isHidden = false
            }
            
            // for Advertisment
            self.refreshAdvertisment()
        }
        
        matEquipmentService.failure = { (errorMessage:String) in
            print(errorMessage)
            SVProgressHUD.dismiss();
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
            //_eduledTimerWithTimeInterval(0.5, target: self, selector: Selector("imageAnimation"), userInfo: nil, repeats: true)
            
            if advertList.count > 0{
                Timer.scheduledTimer(timeInterval:5, target: self, selector: #selector(self.imageAnimation), userInfo: nil, repeats: true)
            }

        }
        
        advertisementService.failure = { (errorMessage:String) in
            print(errorMessage)
            //SVProgressHUD.dismiss();
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
    func getArrayFromSelectedSegment(index: NSInteger) -> [MatEquipment]{
        
        switch index {
        case 0:
            return techPapers.filter{$0.companyName.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace())}
            //break
            
        case 1:
            return techPapers.filter{$0.city.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace())}
            //break
            
        case 2:
            return techPapers.filter{$0.state.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace())}
            // break
            
        case 3:
            return techPapers.filter{$0.region.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace())}
            //break
            
        default:
            return techPapers
            //break
        }
    }
    
    //MARK : - Textfield Actions
    
    func actionText() {
        
        if txtSearch.text!.characters.count > 0{
            isSearch = true
            //isSearchViewHide(false);
            searchTechPapers = getArrayFromSelectedSegment(index: segFilter.selectedSegmentIndex)
            if searchTechPapers.count == 0{
                lblNoRecord.isHidden = false
            }else{
                lblNoRecord.isHidden = true
            }
            self.techPaperTblView.reloadData()
            return
        }
        //isSearchViewHide(true);
        isSearch = false;
        lblNoRecord.isHidden = true
        //techPapers = allTechPapers;
        techPaperTblView.reloadData();
    }
    
    func actionFoucusOnText(){
        
        if txtSearch.text!.characters.count > 0{
            txtSearch.text = ""
            //isSearchViewHide(true);
            isSearch = false;
            lblNoRecord.isHidden = true
            //techPapers = allTechPapers;
            techPaperTblView.reloadData();
        }
    }
    
    @IBAction func segChangeFilter(_ sender: UISegmentedControl) {
        
        if txtSearch.text!.characters.count > 0{
            isSearch = true
            //isSearchViewHide(false);
            searchTechPapers = getArrayFromSelectedSegment(index: segFilter.selectedSegmentIndex)
            if searchTechPapers.count == 0{
                lblNoRecord.isHidden = false
            }else{
                lblNoRecord.isHidden = true
            }
            self.techPaperTblView.reloadData()
        }
    }
    @IBAction func btnSearchPressed(_ sender: Any) {
        self.view.endEditing(true)
        actionText()
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true);
    }
    @IBAction func btnHomePressed(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true);
    }
    @IBAction func actionExportCSV(_ sender: Any) {
        var records = techPapers;
        
        if isSearch{
            records = searchTechPapers
        }
        CSVExporter.generateCSVFor(records,self,"MatQuipFinder");
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MatEquipFinderVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if tableView == self.searchTableView{
//            
//            if isSearch{
//                return searchKeyWord.count;
//            }
//            return keyWordList.count
//        }
        if isSearch{
            return searchTechPapers.count;
        }
        return techPapers.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        if tableView == self.searchTableView{
//            
//            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchEquipKeywordCell")! as UITableViewCell
//            
//            cell.textLabel?.text = isSearch ? searchKeyWord[indexPath.row].name : keyWordList[indexPath.row].name;
//            cell.textLabel?.adjustsFontSizeToFitWidth = true
//            cell.textLabel?.minimumScaleFactor = 0.5
//            
//            return cell;
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MatEquipmentCellIdentifier, for: indexPath) as! MatEquipmentCell
        
        if isSearch{
           cell.matEquipment = searchTechPapers[indexPath.row];
        }else{
           cell.matEquipment = techPapers[indexPath.row];
        }
        
        
        if !cell.isActionViewSet{
            cell.isActionViewSet = true;
            cell.btnView.addTarget(self, action: #selector(actionViewPDFFile), for: .touchUpInside)
        }
        if !cell.isActionShareSet{
            cell.isActionShareSet = true;
            cell.btnShare.addTarget(self, action: #selector(actionShare), for: .touchUpInside)
        }
        
        cell.initialize();
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if tableView == self.searchTableView{
//            let keyWord = isSearch ? searchKeyWord[indexPath.row] : keyWordList[indexPath.row];
//            //searchBarSearch.text = keyWord.name;
//            //searchBarTechPaperTbl.text = searchBarSearch.text
//             txtSearch.text = keyWord.name
//            currentKeyWord = keyWord;
//            //searchBarSearch.showsCancelButton = false;
//            //searchBarSearch.resignFirstResponder();
//            isSearchViewHide(true)
//            SVProgressHUD.show();
//            refreshTechPapers();
//        }
    }
    func actionViewPDFFile(sender:UIButton){
        
        let theCell : TechPaperCell? = sender.getCellInstance() as? TechPaperCell;
        
        if theCell != nil{
            
            let pdfUrl = theCell!.techPaper!.getPDFUrl();
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: pdfUrl)
                self.present(svc, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                // pdfUrl = UrlConstants.GOOGLE_DOC_VIEW_PDF + pdfUrl;
                UIApplication.shared.openURL(pdfUrl)
            }
        }
    }
    func actionShare(sender:UIButton){
        
        let theCell : TechPaperCell? = sender.getCellInstance() as? TechPaperCell;
        
        if theCell != nil{
            
            let pdfUrl = UrlConstants.PDF_FILE_BASEAPI + theCell!.techPaper!.fileName!.encodeURL()!
            socialSharing?.shareFile(file: pdfUrl);
        }
    }
    
    
}
