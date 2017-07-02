//
//  RatingViewController.swift
//  IIF
//
//  Created by Dipak on 26/06/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController ,FloatRatingViewDelegate{

    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    var appName : String = "";
    var appId:String = "";
    var rating : String = "2.5";
    
    fileprivate var ratingSerivce : RatingService = RatingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTitle.text = appName;
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 2.5
        self.floatRatingView.editable = true
        self.floatRatingView.delegate = self
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
        webServiceCallback();
        
        

    }
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
        
    }
    func webServiceCallback(){
        
                ratingSerivce.success = {
                    SVProgressHUD.dismiss()
        
                    self.actionBack(UIButton());
                }
        ratingSerivce.failure = {
            SVProgressHUD.dismiss();
        }
        
    }
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        self.rating = NSString(format: "%.2f", self.floatRatingView.rating) as String
        print(rating);
    }

    @IBAction func actionSave(_ sender: Any) {
        SVProgressHUD.show()
        ratingSerivce.send(id:appId,rating:rating);
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
