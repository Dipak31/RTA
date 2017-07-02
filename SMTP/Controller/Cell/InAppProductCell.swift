//
//  InAppProductCell.swift
//  demoAutoRenewalSubScription
//
//  Created by Kuldip Bhalodiya on 2/20/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import StoreKit

class InAppProductCell: UITableViewCell {
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()

    @IBOutlet var lblProductTitle: UILabel!
    @IBOutlet var btnProductBuy: UIButton!
    
    var buyButtonHandler: ((_ product: SKProduct) -> ())?
    var isAllStrokePurchase: Bool!
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            
            lblProductTitle.text = product.localizedTitle
            
            InAppProductCell.priceFormatter.locale = product.priceLocale
            let strPrice = InAppProductCell.priceFormatter.string(from: product.price)
            btnProductBuy.setTitle(strPrice, for: .normal)
            
            if AppLifeState.isVerifyProductFromIdentifier(product.productIdentifier) || isAllStrokePurchase {
                //btnProductBuy.isHidden = true
                btnProductBuy.isEnabled = false
                btnProductBuy.alpha = 0.5
            }else{
                //btnProductBuy.isHidden = false
                btnProductBuy.isEnabled = true
                btnProductBuy.alpha = 1.0
            }

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnBuyProductPressed(_ sender: Any) {
        buyButtonHandler?(product!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
