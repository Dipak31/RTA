//
//  TutorialViewController.swift
//  SMTP
//
//  Created by Dipak on 31/01/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    static var isDismiss :Bool = false;
    
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TutorialViewController : UICollectionViewDelegate,UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.size.width, height:  self.collectionView.bounds.size.height);
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCell", for: indexPath);
        
        if let imageView = cell.viewWithTag(10) as? UIImageView{
            
            imageView.image = indexPath.row == 4 ? UIImage(named:"spalsh") : UIImage(named:"help\(indexPath.row)");
        }
        return cell;
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
        self.pageControl.currentPage = Int(currentIndex);
        //print(currentIndex);
        
        if currentIndex >= 4{
            
            if !TutorialViewController.isDismiss{
                TutorialViewController.isDismiss = true;
                let dispatchTime = DispatchTime.now() + .seconds(0)
                DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                    AppLifeState.setTutorial(true);
                    APP_DELEGATE?.setRootViewController();
                }
            }else{
                ////print("Already Dismiss");
            }
        }
    }
 
}
