//
//  TutorialViewController.swift
//  Casting Finder
//
//  Created by Dipak on 01/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit
import SafariServices

class TutorialViewController: UIViewController {

    @IBOutlet var imgTutorialHeader: UIImageView!
    @IBOutlet var webViewTutorial: UIWebView!
    @IBOutlet var imgAdvertise: UIImageView!
    @IBOutlet weak var constraintBtnDemoCenter: NSLayoutConstraint!
    @IBOutlet weak var btnCreateProfile: UIButton!
    
    var indentifierValue : Int!
    
    fileprivate var tutorialService : TutorialService = TutorialService()
    public var actionCallBack : (()->())?
    public var tutorial : Tutorial? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doIntialize()
    }
    
    //MARK: - Class Functions
    func doIntialize(){
        
        
        webServiceCallback()
        
        if indentifierValue == 1{
            imgTutorialHeader.image = UIImage(named:"tutorial_foundry_techmate")
            constraintBtnDemoCenter.constant = -145;
            btnCreateProfile.isHidden = true;
        }else if indentifierValue == 2{
            imgTutorialHeader.image = UIImage(named:"tutorial_foundry_castingfinder")
        }else{
            imgTutorialHeader.image = UIImage(named:"tutorial_foundry_matequip")
        }
        
        if tutorial == nil{
            SVProgressHUD.show()
            tutorialService.send(id: "\(indentifierValue!)")
        }else{
            renderUI();
        }
        
    }
    
    @IBAction func actionBannerClick(_ sender: Any) {
        
        if tutorial?.advertiseUrl != nil{
            UIApplication.shared.openURL(tutorial!.advertiseUrl!);
        }
        

    }
    //MARK: - Button Actions
    
    @IBAction func actionBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            self.actionCallBack?();

        });

    }
    @IBAction func actionCreateProfile(_ sender: Any) {
        
        if let url = tutorial?.createProfileUrl{
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                // pdfUrl = UrlConstants.GOOGLE_DOC_VIEW_PDF + pdfUrl;
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func actionVIdeo(_ sender: Any) {
        
        if let url = tutorial?.videoUrl{
            
            if #available(iOS 9.0, *) {
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                // pdfUrl = UrlConstants.GOOGLE_DOC_VIEW_PDF + pdfUrl;
                UIApplication.shared.openURL(url)
            }
        }
    }
    //MARK :- Web Service
    func renderUI(){
        self.webViewTutorial.loadHTMLString(tutorial!.descrip!, baseURL: nil)
        
        // Advertisement
        if let url = NSURL(string: (tutorial!.advImg!)) {
            if let data = NSData(contentsOf: url as URL) {
                self.imgAdvertise.image = UIImage(data: data as Data)
            }
        }
    }
    func webServiceCallback(){
        
//        tutorialService.success = { (tutorial:Tutorial) in
//            SVProgressHUD.dismiss()
//            
//            self.webViewTutorial.loadHTMLString(tutorial.descrip!, baseURL: nil)
//            
//            // Advertisement
//            if let url = NSURL(string: tutorial.advImg!) {
//                if let data = NSData(contentsOf: url as URL) {
//                    self.imgAdvertise.image = UIImage(data: data as Data)
//                }        
//            }
//        }
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
