//
//  TechPaperCell.swift
//  Foundry Tech-Mate
//
//  Created by System Administrator on 12/21/16.
//  Copyright © 2016 IIF. All rights reserved.
//

import UIKit

let FoundaryListCellIdentifier = String(describing:FoundaryListCell.self);

class FoundaryListCell: UITableViewCell {

    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var btnView: FancyButton!
    @IBOutlet weak var btnShare: FancyButton!
    
    
    var foundary : Foundary? = nil;
    var isActionViewSet : Bool = false;
    var isActionShareSet : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initialize(){
    
        if let name = foundary?.companyName {
            lblCompanyName.text = name;
        }else{
            lblCompanyName.text = "";
        }
        if let city = foundary?.city{
            lblCity.text = city;
        }else{
            lblCity.text = "";
        }
        if let state = foundary?.state{
            lblState.text =  state;
        }else{
            lblState.text = "";
        }
        if let region = foundary?.region{
            lblRegion.text =  region;
        }else{
            lblRegion.text = "";
        }
        if let year = foundary?.year{
            lblYear.text =  year;
        }else{
            lblYear.text = "";
        }
        if let capacity = foundary?.capacity{
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
