//
//  DisclaimerViewController.swift
//  SMTP
//
//  Created by Dipak on 06/07/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController,UIWebViewDelegate{

    @IBOutlet weak var webView: UIWebView!
    @IBAction func actionBack(_ sender: Any) {
        self.actionDisMiss();

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SVProgressHUD.show();
        webView.loadRequest(URLRequest(url:URL(string:"http://tennispro.co.in/disclaimer.html")!));
        
    }

    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss();
        
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
