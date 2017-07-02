//
//  CityListVC.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 2/2/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class CityListVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tblCityList: UITableView!
    @IBOutlet var txtSearchCity: UITextField!
    
    var objSignUp : SignUpVC!
    
    var mutArrCity = [City]()
    var mutArrSearchCity = [City]()
    
    fileprivate var isSearch = false
    
    fileprivate var cityService : CityService = CityService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webServiceCallback()
        doinitialize()
    }
    
    func doinitialize(){
        SVProgressHUD.show()
        cityService.send()
    }

    //MARK : - Button Actins
    @IBAction func actionBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func txtSearchCity(_ sender: Any) {
        
        if txtSearchCity.text!.characters.count > 0{
            isSearch = true
            mutArrSearchCity = mutArrCity.filter{$0.city!.lowercased().removeSpace().contains(txtSearchCity.text!.lowercased().removeSpace())}
            self.tblCityList.reloadData()
            return
        }
        isSearch = false
    }
    
    //MARK: - Tablde delagate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch{
            return mutArrSearchCity.count
        }
        return mutArrCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        
        cell.textLabel?.text = isSearch ? mutArrSearchCity[indexPath.row].city : mutArrCity[indexPath.row].city;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        objSignUp.mutArrRegister[2]["value"] = isSearch ? mutArrSearchCity[indexPath.row].city : mutArrCity[indexPath.row].city
        objSignUp.mutArrRegister[2]["cityId"] = isSearch ? mutArrSearchCity[indexPath.row].id : mutArrCity[indexPath.row].id
        
        objSignUp.tblRegister.reloadData()
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK :- Web Service
    
    func webServiceCallback(){
        
        cityService.success = { (cityList:[City]) in
            SVProgressHUD.dismiss()
            self.mutArrCity = cityList
            self.tblCityList.reloadData()
        }
        cityService.failure = { (errorMessage:String) in
            SVProgressHUD.dismiss();
            
            print(errorMessage)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
