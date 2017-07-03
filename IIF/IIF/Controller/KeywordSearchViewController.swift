//
//  KeywordSearchViewController.swift
//  IIF
//
//  Created by Dipak on 03/07/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class KeywordSearchViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var tableVIew: UITableView!
    @IBOutlet var txtSearch: UITextField!

    fileprivate var keyWordList : [KeywordEquip] = [];
    fileprivate var searchKeyWord : [KeywordEquip] = [];
    fileprivate var currentKeyWord : KeywordEquip? = nil;
    fileprivate var searchRefreshControl:UIRefreshControl? = nil;
    fileprivate var isSearch = false

    fileprivate var keywordEquipService : KeywordEquipService = KeywordEquipService()
    public var actionSearchKeyword : ((_ keyword:KeywordEquip)->())?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        searchRefreshControl = UIRefreshControl();
        searchRefreshControl!.addTarget(self, action: #selector(refreshPull), for: UIControlEvents.valueChanged);
        tableVIew!.addSubview(searchRefreshControl!);
        
        txtSearch.addTarget(self, action: #selector(actionFoucusOnText), for:.editingChanged);
        SVProgressHUD.show();
        webServiceCallback();
        keywordEquipService.send();
    }
    func refreshPull(){
        
        if NetworkReachability.isConnectedToNetwork(){
            
            searchRefreshControl?.beginRefreshing();
            keywordEquipService.send();
        }else{
            SVProgressHUD.dismiss();
            searchRefreshControl?.endRefreshing();
        }
    }
    func webServiceCallback(){
        
        keywordEquipService.success = { (keywordList:[KeywordEquip]) in
            self.searchRefreshControl?.endRefreshing();
            SVProgressHUD.dismiss();
            self.keyWordList = keywordList
            self.tableVIew.reloadData()
        }
        keywordEquipService.failure = { (errorMessage:String) in
            SVProgressHUD.dismiss();
            self.searchRefreshControl?.endRefreshing();
            print(errorMessage)
        }

    }
    func actionFoucusOnText(){
        
        if txtSearch.text!.characters.count > 0{
            isSearch = true;
            searchKeyWord = keyWordList.filter{$0.name!.lowercased().removeSpace().contains(txtSearch.text!.lowercased().removeSpace())}
            tableVIew.reloadData();
        }else{
            isSearch = false;
        }
        self.tableVIew.reloadData()

    }
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            
        });
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension KeywordSearchViewController : UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch{
            return searchKeyWord.count;
        }
        return keyWordList.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchEquipKeywordCell")! as UITableViewCell
        
        cell.textLabel?.text = isSearch ? searchKeyWord[indexPath.row].name : keyWordList[indexPath.row].name;
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
                    let keyWord = isSearch ? searchKeyWord[indexPath.row] : keyWordList[indexPath.row];
        actionSearchKeyword?(keyWord);
        actionDismiss(UIButton);
        }

}
