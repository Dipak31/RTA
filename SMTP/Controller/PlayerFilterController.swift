//
//  PlayerFilterController.swift
//  SMTP
//
//  Created by Dipak on 03/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit

class PlayerFilterController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    public var disMissHandler: (() -> ())?
    public var players : [Video] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if DeviceUtil.isIpad(){
            
        }
        
        if !NetworkReachability.isConnectedToNetwork(displayAlert:false){
            //players = players.filter({$0.isDownloaded == true});
        }
    }

    @IBAction func actionAllPlayer(_ sender: Any) {
        APP_DELEGATE!.filter.player = "ALL PLAYERS";
        APP_DELEGATE!.filter.playerId = nil;
        disMissHandler?();
        self.actionDisMiss();
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.actionDisMiss();

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension PlayerFilterController : UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return players.count;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.collectionView.bounds.size.width-18;
        return CGSize(width: width, height: 100);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerCellIdentifier, for: indexPath) as? PlayerCell
        cell?.player = players[indexPath.row];
        cell?.initialize();
        
        return cell!;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath){
        APP_DELEGATE!.filter.playerId = players[indexPath.row].playerId;
        APP_DELEGATE!.filter.player = players[indexPath.row].playerName!.uppercased();

        disMissHandler?();

        self.actionDisMiss();
    }
}
