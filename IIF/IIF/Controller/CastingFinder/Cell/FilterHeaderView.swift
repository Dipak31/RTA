//
//  FeedsProductHeader.swift
//  Walkins
//
//  Created by System Administrator on 2/2/16.
//  Copyright © 2016 Walkins. All rights reserved.
//

import UIKit


class FilterHeaderView: UITableViewHeaderFooterView{

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var background: UIView!
    @IBOutlet weak var arrowImgview: UIImageView!

    var actionHeader : UITapGestureRecognizer!
    var section : Int? = nil;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var firstInit:Bool = true;
    var isAnimating : Bool = false;

    func initialize() {
        
        if firstInit {
        
        }
    
    }
    func setCollapsed(collapsed: Bool) {
        arrowImgview.rotate(toValue: collapsed ? 0 : CGFloat(M_PI_4))
    }
}
