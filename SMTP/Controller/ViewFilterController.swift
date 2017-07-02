//
//  ViewFilterController.swift
//  SMTP
//
//  Created by Dipak on 03/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit

class ViewFilterController: UIViewController {
    public var disMissHandler: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if DeviceUtil.isIpad(){
            
        }
    }

    @IBAction func actionAllView(_ sender: Any) {
        
        APP_DELEGATE!.filter.views = "ALL VIEWS";
        APP_DELEGATE!.filter.viewId = nil;

        disMissHandler?();
        self.actionDisMiss();
    }
    @IBAction func actionViewType(_ sender: UIButton) {
        
        if sender.tag == 10{
            //print("Front T");
            APP_DELEGATE!.filter.views = "FRONT";
            APP_DELEGATE!.filter.viewId = 104;

        }else if sender.tag == 20{
            //print("Fride B")
            APP_DELEGATE!.filter.views = "FRIDE B";
            APP_DELEGATE!.filter.viewId = 118;

        }else if sender.tag == 30{
            //print("FRIDE A")
            APP_DELEGATE!.filter.views = "FRIDE A";
            APP_DELEGATE!.filter.viewId = 119;

        }else if sender.tag == 40{
            //print("Side B")
            APP_DELEGATE!.filter.views = "SIDE B";
            APP_DELEGATE!.filter.viewId = 120;

        }else if sender.tag == 50{
            //print("Side A")
            APP_DELEGATE!.filter.views = "SIDE A";
            APP_DELEGATE!.filter.viewId = 121;

        }else if sender.tag == 60{
            //print("Bide B")
            APP_DELEGATE!.filter.views = "BIDE B";
            APP_DELEGATE!.filter.viewId = 116;

        }else if sender.tag == 70{
            //print("Back")
            APP_DELEGATE!.filter.views = "BACK";
            APP_DELEGATE!.filter.viewId = 122;

        }else if sender.tag == 80{
            //print("Bide A")
            APP_DELEGATE!.filter.views = "BIDE A";
            APP_DELEGATE!.filter.viewId = 117;

        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
