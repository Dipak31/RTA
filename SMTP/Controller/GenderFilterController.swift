//
//  GenderFilterController.swift
//  SMTP
//
//  Created by Dipak on 03/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit

class GenderFilterController: UIViewController {

    public var disMissHandler: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if DeviceUtil.isIpad(){
        
        }
    }

    @IBAction func actionGender(_ sender: UIButton) {
        
        if sender.tag == 10{
            APP_DELEGATE!.filter.gender = .menwomen;
        }else if sender.tag == 20{
            APP_DELEGATE!.filter.gender = .men;
        }else if sender.tag == 30{
            APP_DELEGATE!.filter.gender = .women;
        }
        APP_DELEGATE!.filter.playerId = nil;
        APP_DELEGATE!.filter.player = "ALL PLAYERS";
        
        disMissHandler?();
        self.actionDisMiss()
    }
    @IBAction func actionClose(_ sender: Any) {
        self.actionDisMiss()

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
