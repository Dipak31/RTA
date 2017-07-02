//
//  StrokeCell.swift
//  SMTP
//
//  Created by Dipak on 04/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit

let StrokeCellIdentifier = String(describing:StrokeCell.self);

class StrokeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!

    var isFirstInit : Bool = false;
    var stroke : Stroke? = nil;
    
    func initialize(){
    
        if let name = stroke?.name{
            lblName.text = name;
        }else{
            lblName.text = "";
        }
        var image : String? = stroke?.image;
        if APP_DELEGATE!.filter.gender == .men{
            image = stroke?.menImage;
        }else if APP_DELEGATE!.filter.gender == .women{
            image = stroke?.womenImage;
        }
        if image != nil{
            let url = URL(string: image!)
            imageView.kf.setImage(with: url)
        }
//        if let image = stroke?.lockImage{
//            let url = URL(string: image)
//            lockImageView.kf.setImage(with: url)
//        }

        if !stroke!.isPurchased{
            //If accountTypeId value is 2 then stroke will be consider as paid
            if stroke!.accountTypeId == 2{
                if let imageUrlSt = stroke?.lockImage{
//                    let url = URL(string: imageUrlSt)
//                    lockImageView.kf.setImage(with: url)
                }
                lockImageView.isHidden = false;
            }else{
                lockImageView.isHidden = true;
            }
        }else{
            lockImageView.isHidden = true;
        }
       
    }
}
