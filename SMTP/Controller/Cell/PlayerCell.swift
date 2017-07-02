//
//  PlayerCell.swift
//  SMTP
//
//  Created by Dipak on 04/02/17.
//  Copyright © 2017 Dipak. All rights reserved.
//

import UIKit
let PlayerCellIdentifier = String(describing:PlayerCell.self);

class PlayerCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var player : Video? = nil;
    
    func initialize(){
    
        if let name = player?.playerName{
            lblName.text = name;
        }else{
            lblName.text = "";
        }
        if let image = player?.playerImages{
            let url = URL(string: image)
            imageView.kf.setImage(with: url)
        }
    }
}
