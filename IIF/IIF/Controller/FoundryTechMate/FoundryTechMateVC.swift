//
//  FoundryTechMateVC.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/2/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit
import SafariServices

class FoundryTechMateVC: UIViewController,UITextFieldDelegate {
    
    static let applicationIdentify = 1

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var techPaperTblView: UITableView!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var imgAdvertise: UIImageView!
    @IBOutlet var lblNoRecord: UILabel!
    @IBOutlet var segFilter: UISegmentedControl!
    
    fileprivate var keyWordList : [Keyword] = [];
    fileprivate var searchKeyWord : [Keyword] = [];
    fileprivate var currentKeyWord : Keyword? = nil;
    
    fileprivate var techPapers : [TechPaper] = [];
    fileprivate var allTechPapers : [TechPaper] = [];
    
    fileprivate var isSearch = false
    
    fileprivate var searchRefreshControl:UIRefreshControl? = nil;
    fileprivate var refreshControl:UIRefreshControl? = nil;
    
    fileprivate var getKeywordListService : GetKeywordListService = GetKeywordListService()
    fileprivate var findTechPapaerService : FindTechPapaerService = FindTechPapaerService()
    fileprivate lazy var socialSharing:SocialSharing? = SocialSharing(vc:self);
    
    fileprivate var advertisementService : AdvertisementService = AdvertisementService()
    
    fileprivate var categoryName = ["Kwd","Author","PubMonth"]
    public var tutorial : Tutorial? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblTitle.text = Constants.IIF_FOUNDRY_TECH_MATE_TITLE
        lblSubTitle.text = Constants.IIF_FOUNDRY_TECH_MATE_SUBTIT
        
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
        
        // tutorial screen
        if !AppLifeState.getTechMateSplash()!{
            //AppLifeState.setTechMateSplash(true); // first time tutorial screen
            self.showTutorial(indentifierValue: 1,tutorial:tutorial!);
        }
        
        webServiceCallback()
    }
    
    var isFirstAppear : Bool = true;
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        if isFirstAppear{
            
            isFirstAppear = false;
           // SVProgressHUD.show();
             getKeywordListService.send();
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated);
        
        
    }
    public func showTutorial(indentifierValue : Int,tutorial:Tutorial){
        
        
        let storyBoard = StoryBoard.MAIN.Instance();
        let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:TutorialViewController.self)) as!  TutorialViewController
        vc.indentifierValue = indentifierValue;
        vc.tutorial = tutorial;
        vc.actionCallBack = {
            print("CallBack");
            if AppLifeState.isShowTechMateAppReview(){
                self.showRatingView(appName: Constants.IIF_FOUNDRY_TECH_MATE_TITLE,appId:"1");
            }
        }
        let navVc = UINavigationController(rootViewController: vc);
        navVc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        navVc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        navVc.navigationBar.isHidden = true;
        APP_DELEGATE?.rootViewController().present(navVc, animated: false, completion: nil);
    }
    // MARK: - FUNCTION
    
    func refreshPull(){
        
        if NetworkReachability.isConnectedToNetwork(){
            
            if techPaperTblView.isHidden{
                searchRefreshControl?.beginRefreshing();
                getKeywordListService.send();
            }else{
                currentKeyWord = nil
                refreshControl?.beginRefreshing();
                refreshTechPapers();
            }
        }else{
            refreshControl?.endRefreshing();
            searchRefreshControl?.beginRefreshing();
        }
    }
    
    func refreshTechPapers(){
        
        if currentKeyWord == nil{
            findTechPapaerService.send(id: "0");
        }else{
            findTechPapaerService.send(id:currentKeyWord!.id!);
        }
        
    }
    
    func refreshAdvertisment(){
        
        if currentKeyWord == nil{
            advertisementService.send(appId: "\(FoundryTechMateVC.applicationIdentify)", inpIdA: "0", inpIdB: "")
        }else{
            advertisementService.send(appId: "\(FoundryTechMateVC.applicationIdentify)", inpIdA: "\(currentKeyWord!.id!)", inpIdB: "")
        }
    }
    
    func isSearchViewHide(_ flag : Bool){
        searchTableView.isHidden = flag;
        techPaperTblView.isHidden = !flag;
        //showSortingBarItem(flag);
    }

    //MARK: - Web Service
    
    func webServiceCallback(){
        
        getKeywordListService.success = { (keywordList:[Keyword]) in
            self.searchRefreshControl?.endRefreshing();
            
            self.keyWordList = keywordList
            self.searchTableView.reloadData()
            self.refreshPull()
            
        }
        getKeywordListService.failure = { (errorMessage:String) in
            SVProgressHUD.dismiss();
            self.searchRefreshControl?.endRefreshing();
            
            print(errorMessage)
        }
        
        findTechPapaerService.success = { (resultList:[TechPaper]) in
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
            
            
            // get advertisment service call
            self.refreshAdvertisment()
        }
        
        findTechPapaerService.failure = { (errorMessage:String) in
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
//            self.imgAdvertise.animationImages = aryImage
//            self.imgAdvertise.animationDuration = Double(aryImage.count)*5.0
//            self.imgAdvertise.startAnimating()

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
    var advertiseList : [Advertisement] = [];
    var index : Int = 0;
    func imageAnimation(){
        print(index);
        
        
        if let url = NSURL(string: advertiseList[index].advtImg!) {
            if let data = NSData(contentsOf: url as URL) {
                self.imgAdvertise.image = UIImage(data:data as Data);
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
    
    //MARK: - Textfield Actions
  
    func actionText() {
        
        if txtSearch.text!.characters.count > 0{
            isSearch = true
            isSearchViewHide(false);
            searchKeyWord = keyWordList.filter{$0.name!.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace()) && $0.catName!.lowercased().removeSpace().contains(categoryName[segFilter.selectedSegmentIndex].lowercased().removeSpace())}
            self.searchTableView.reloadData()
            return
        }
        isSearchViewHide(true);
        isSearch = false;
        lblNoRecord.isHidden = true
        techPapers = allTechPapers;
        techPaperTblView.reloadData();
    }
    
    func actionFoucusOnText(){
        
        if txtSearch.text!.characters.count > 0{
            txtSearch.text = ""
            isSearchViewHide(true);
            isSearch = false;
            lblNoRecord.isHidden = true
            techPapers = allTechPapers;
            techPaperTblView.reloadData();
        }
    }
    
    @IBAction func segChangeFilter(_ sender: UISegmentedControl) {
        
        if txtSearch.text!.characters.count > 0{
            isSearch = true
            isSearchViewHide(false);
            searchKeyWord = keyWordList.filter{$0.name!.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace()) && $0.catName!.lowercased().removeSpace().contains(categoryName[segFilter.selectedSegmentIndex].lowercased().removeSpace())}
            self.searchTableView.reloadData()
        }
    }
    
    @IBAction func actiontest(_ sender: Any) {
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true);
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

extension FoundryTechMateVC : UITableViewDelegate,UITableViewDataSource{
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.searchTableView{
            
            if isSearch{
                return searchKeyWord.count;
            }
            return keyWordList.count
        }
        
        return techPapers.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == self.searchTableView{
            
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchKeywordCell")! as UITableViewCell
            
            cell.textLabel?.text = isSearch ? searchKeyWord[indexPath.row].name : keyWordList[indexPath.row].name;
            
            return cell;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TechPaperCellIdentifier, for: indexPath) as! TechPaperCell
        
        cell.techPaper = techPapers[indexPath.row];
        
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
        
        if tableView == self.searchTableView{
            let keyWord = isSearch ? searchKeyWord[indexPath.row] : keyWordList[indexPath.row];
            //searchBarSearch.text = keyWord.name;
            //searchBarTechPaperTbl.text = searchBarSearch.text
            txtSearch.text = keyWord.name
            currentKeyWord = keyWord;
            //searchBarSearch.showsCancelButton = false;
            //searchBarSearch.resignFirstResponder();
            isSearchViewHide(true)
            SVProgressHUD.show();
            refreshTechPapers();
        }
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
