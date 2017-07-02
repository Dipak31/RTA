//
//  DashboardVC.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 1/31/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit


class DashboardVC: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet var colAppList: UICollectionView!
    @IBOutlet var imgAdvertise: UIImageView!
    
    fileprivate var tutorialService : TutorialService = TutorialService()
    
    var mutArrAppIcon = [String]()
    var appList : [Tutorial] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dointialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        colAppList.reloadData()
    }
    
    //MARK: - Class Funtions
    
    func dointialize(){
        
        webServiceCallback()
        
        mutArrAppIcon = ["foundry_tech_mate","casting_finder","mate_eqip_finder","My IIF Icon"];
        
        //get advertisement
        SVProgressHUD.show()
        tutorialService.send(id: "\(0)")
    }
    
    //MARK: - Button Actions
    @IBAction func btnUserProfilePressed(_ sender: Any) {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        signUpVC.isEditProfile = true
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    @IBAction func btnHeaderPressed(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string:"http://indianfoundry.org")! as URL)
    }
    
    
    //MARK: - Collection Delegate / datasaorce
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionCellWidth = self.colAppList.bounds.size.width/2
        return CGSize(width: collectionCellWidth, height: collectionCellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let indentifier = "AppListCollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath) as! AppListCollectionCell
        
        cell.imgAppIcon.image = UIImage(named: mutArrAppIcon[indexPath.row])
        cell.backgroundColor = UIColor.clear
        cell.lblRating.text = appList[indexPath.row].rating;
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row > 2{
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor(hex:Colors.orange)
        
        if indexPath.row <= 2{
            
            let storyBoard = StoryBoard.MAIN.Instance();
            
          
            
            if indexPath.row == 0{
                let identifier = StoryBoardID.FOUNDRY_TECHMATE
                let vc =  storyBoard.instantiateViewController(withIdentifier: identifier) as? FoundryTechMateVC;
                vc?.tutorial = appList[indexPath.row];
                self.navigationController?.pushViewController(vc!, animated: true);
            }else if indexPath.row == 1{
                let identifier = StoryBoardID.CASTING_FILTER_VC
                let vc =  storyBoard.instantiateViewController(withIdentifier: identifier) as? CastingFilterVC;
                vc?.tutorial = appList[indexPath.row];
                self.navigationController?.pushViewController(vc!, animated: true);
            }else if indexPath.row == 2{
                let identifier = StoryBoardID.MAT_EQUIP_VC
                let vc =  storyBoard.instantiateViewController(withIdentifier: identifier) as? MatEquipFinderVC;
                vc?.tutorial = appList[indexPath.row];
                self.navigationController?.pushViewController(vc!, animated: true);
            }
           
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
    }
    
    @IBAction func actionBannerClick(_ sender: Any) {
        
        if appList[3].advertiseUrl != nil{
            UIApplication.shared.openURL(appList[3].advertiseUrl!);
        }

        
    }
    //MARK :- Web Service
    
    func webServiceCallback(){
        
        tutorialService.success = { (tutorial:[Tutorial]) in
            SVProgressHUD.dismiss()
            self.appList = tutorial;
            self.colAppList.reloadData();
            // Advertisement
            if let dashboard = tutorial[3] as? Tutorial{
                if let url = NSURL(string: dashboard.advImg!) {
                    if let data = NSData(contentsOf: url as URL) {
                        self.imgAdvertise.image = UIImage(data: data as Data)
                    }
                }
            }
          
        }
        tutorialService.failure = { (errorMessage:String) in
            SVProgressHUD.dismiss();
            
            print(errorMessage)
        }
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
