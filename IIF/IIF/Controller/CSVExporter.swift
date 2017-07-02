//
//  CSVExporter.swift
//  IIF
//
//  Created by Dipak on 30/06/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import Foundation

class CSVExporter {
    
    
    static func generateCSVFor(_ list:[Any],_ parentVc:UIViewController,_ appName:String){
        
        SVProgressHUD.show();
        
        let fileName = "\(appName).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        print(path);
        
        var csvText = "Company Name,State,Region,City,Year,Capacity,Url\n"
        
        
        if list.count > 0 {
            
            if appName == "IndianCastingFinder"{
            
                for object in list {
                    
                    let foundary = object as! Foundary;
                    
                    let newLine = "\(foundary.companyName!),\(foundary.state!),\(foundary.region!),\(foundary.city!),\(foundary.year!),\(foundary.capacity!),\(foundary.url!)\n";
                    
                    csvText.append(newLine)
                }
                
            }else{
                
                for object in list {
                    
                    let matquip = object as! MatEquipment;
                    
                    let newLine = "\(matquip.companyName),\(matquip.state),\(matquip.region),\(matquip.city),\(matquip.year),\(matquip.capacity),\(matquip.url)\n";
                    
                    csvText.append(newLine)
                }
            }
           
            
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                
                let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
//                if #available(iOS 9.0, *) {
//                    vc.excludedActivityTypes = [
//                        UIActivityType.assignToContact,
//                        UIActivityType.saveToCameraRoll,
//                        UIActivityType.postToFlickr,
//                        UIActivityType.postToVimeo,
//                        UIActivityType.postToTencentWeibo,
//                        UIActivityType.postToTwitter,
//                        UIActivityType.postToFacebook,
//                        UIActivityType.openInIBooks
//                    ]
//                } else {
//                    // Fallback on earlier versions
//                }
                parentVc.present(vc, animated: true, completion: {
                    SVProgressHUD.dismiss();
                })
                
            } catch {
                
                print("Failed to create file")
                print("\(error)")
            }
            
        } else {
            print("There is no data to export");
        }
    }
}
