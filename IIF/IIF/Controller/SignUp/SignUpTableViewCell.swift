//
//  SignUpTableViewCell.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 1/31/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class SignUpTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtValue: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
