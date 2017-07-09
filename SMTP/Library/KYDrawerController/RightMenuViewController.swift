//
//  RightMenuViewController.swift
//  Walkins Seller
//
//  Created by System Administrator on 10/26/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit

public enum MenuItem : String {
    case Share = "Share"
    case Purchase = "Purchase Strokes"
    case Restore = "Restore"
    case Desclaimer = "Disclaimer"
}

class RightMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
       
    let menuList : [MenuItem] = [.Share,.Purchase,.Restore,.Desclaimer];
    let image : [String] = ["share","purchase","restore","info"];
    var dashBoardViewController: UIViewController!
    
    
    var selectedIndex : Int = 0;
    var vcStack : [Any] = [];
    fileprivate lazy var socialSharing:SocialSharing? = SocialSharing(vc:self);

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

      // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCellIdentifier, for: indexPath) as! MenuCell
        
        cell.lblTitle.text = menuList[indexPath.row].rawValue;
        cell.icon.image = UIImage(named:image[indexPath.row])
        cell.initialize();
        
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let drawerController = self.navigationController?.parent as? KYDrawerController
        let navigationController = drawerController?.childViewControllers[0] as? UINavigationController;
        
        if indexPath.row == 0{
            
            socialSharing?.shareFile(file: "Hey! Check out the Slow Motion Tennis Pros app.  You can filter and play slow motion videos by player name, stroke type, and even camera angle.  It’s really easy to use!\nitms-apps://itunes.apple.com/app/id1211124737");
            
        }else if indexPath.row == 1{
            
            let storyBoard = StoryBoard.MAIN.Instance();
            let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:PurchaseController.self)) as!  PurchaseController
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
            vc.disMissHandler = { isStrokePurchased in
                //print("Purchased");
                if let homeVc = navigationController?.viewControllers[0] as? HomeViewController{
                    //print("Got it");
                    homeVc.hideAdvertiseIfAnyStrokeIsPurchasedOrOffline();
                    homeVc.startSyncing();
                }
            }
            APP_DELEGATE?.rootViewController().present(vc, animated: true, completion: nil);

            
        }else if indexPath.row == 2{
            //print("Restore");
            // In app Purchase Receipt
            //check In App Receipt is valid or not
            SVProgressHUD.show(withStatus: "Please wait while we synchronize your purchased strokes.");
            AppLifeState.refreshAndStoreLocallyReceipt(completationHandler: { isSuccess in
                //print("Success Block");
                SVProgressHUD.dismiss();
                if isSuccess{
                    if let homeVc = navigationController?.viewControllers[0] as? HomeViewController{
                        //print("Got it");
                        let syncHelper : SyncHelper = SyncHelper();
                        syncHelper.syncStrokeList(delegate:nil);
                        homeVc.startSyncing();
                    }
                }
            });
            
        }else if indexPath.row == 3{
            let storyBoard = StoryBoard.MAIN.Instance();
            let vc = storyBoard.instantiateViewController(withIdentifier: String(describing:DisclaimerViewController.self)) as!  DisclaimerViewController
            APP_DELEGATE?.rootViewController().present(vc, animated: true, completion: nil);

        }
            //drawerController?.mainViewController = dashBoardViewController;

            
        drawerController?.setDrawerState(.closed, animated: true);
        self.tableView.reloadData();
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
