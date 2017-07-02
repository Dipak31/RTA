//
//  MenuCell.swift
//  Walkins Seller
//
//  Created by System Administrator on 10/26/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit

let MenuCellIdentifier = "MenuCell"

class MenuCell: UITableViewCell {

    @IBOutlet weak var strip: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var icon: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var isfirstInit : Bool = true;
    
    func initialize(){
        
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
