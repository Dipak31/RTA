//
//  TechPaperCell.swift
//  Foundry Tech-Mate
//
//  Created by System Administrator on 12/21/16.
//  Copyright © 2016 IIF. All rights reserved.
//

import UIKit

let TechPaperCellIdentifier = String(describing:TechPaperCell.self);

class TechPaperCell: UITableViewCell {

    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblPublishedDate: UILabel! 
    @IBOutlet weak var lblPublicationName: UILabel!
    @IBOutlet weak var btnShare: FancyButton!
    @IBOutlet weak var btnView: FancyButton!
    
    
    var techPaper : TechPaper? = nil;
    var isActionShareSet : Bool = false;
    var isActionViewSet : Bool = false;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initialize(){
    
        if let subject = techPaper?.subject {
            lblSubject.text = subject;
        }else{
            lblSubject.text = "";
        }
        if let publishDate = techPaper?.pubMonth{
            lblPublishedDate.text =  publishDate;
        }else{
            lblPublishedDate.text = "";
        }
        if let publishName = techPaper?.pubName{
            lblPublicationName.text =  publishName;
        }else{
            lblPublicationName.text = "";
        }
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
