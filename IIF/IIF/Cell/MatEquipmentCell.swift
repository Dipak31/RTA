//
//  MatEquipmentCell.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/4/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

let MatEquipmentCellIdentifier = String(describing:MatEquipmentCell.self);

class MatEquipmentCell: UITableViewCell {
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var btnShare: FancyButton!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var btnView: FancyButton!
    
    
    var matEquipment : MatEquipment? = nil;
    var isActionShareSet : Bool = false;
    var isActionViewSet : Bool = false;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initialize(){
        
        if let companyName = matEquipment?.companyName {
            lblCompanyName.text = companyName;
        }else{
            lblCompanyName.text = "";
        }
        if let region = matEquipment?.region{
            lblRegion.text =  region;
        }else{
            lblRegion.text = "";
        }
        if let city = matEquipment?.city{
            lblCity.text =  city;
        }else{
            lblCity.text = "";
        }
        if let state = matEquipment?.state{
            lblState.text =  state;
        }else{
            lblState.text = "";
        }
        if let year = matEquipment?.year{
            lblYear.text =  year;
        }else{
            lblYear.text = "";
        }
        if let capacity = matEquipment?.capacity{
            lblCapacity.text =  capacity;
        }else{
            lblCapacity.text = "";
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
