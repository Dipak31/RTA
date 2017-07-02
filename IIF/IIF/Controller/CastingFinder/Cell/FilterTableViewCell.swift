	//
//  FilterTableViewCell.swift
//  Test
//
//  Created by System Administrator on 12/13/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit

let FilterTableViewCellIdentifier =  String(describing: FilterTableViewCell.self)


class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    weak var filter : Filter? = nil;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initialize(){
        
        title.text = filter!.value;
        
        if filter!.isSelected!{
            accessoryType = .checkmark;
            title.font = UIFont.boldSystemFont(ofSize: 13.0)
        }else{
            accessoryType = .none;
            title.font = UIFont.init(name: "Nexa Light", size: 13)
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
