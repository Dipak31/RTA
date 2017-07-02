//
//  SignUpVC.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 1/31/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var isEditProfile = Bool()
    
    @IBOutlet var tblRegister: UITableView!
    @IBOutlet var lblNewUserRegister: UILabel!
    @IBOutlet var btnRegister: UIButton!
    
    var mutArrRegister = [[String:Any]]()
    var mutArrCity = [City]()
    
    fileprivate var signUpService : SignUpService = SignUpService()
    fileprivate var cityService : CityService = CityService()
    
    fileprivate var user : User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doInitialise()
    }
    
    //MARK: - Class
    func doInitialise(){
        
        webServiceCallback();
        
        user = AppLifeState.getUser()
        
        mutArrRegister = [
            ["title":"Name:*","value":""],
            ["title":"E-mail Id:*","value":""],
            ["title":"City:*","value":"","cityId":""],
            ["title":"Company Name:","value":""],
            ["title":"Designation:","value":""],
            ["title":"Mobile No:*","value":user!.phoneNumber!]
        ]
        
        if isEditProfile{
            mutArrRegister[0]["value"] = user.name
            mutArrRegister[1]["value"] = user.email
            mutArrRegister[2]["cityId"] = user.city
            mutArrRegister[3]["value"] = user.company
            mutArrRegister[4]["value"] = user.designation
            
            //set lable for register
            lblNewUserRegister.text = "USER PROFILE"
            
            //set button title
            btnRegister.setTitle("Update", for: UIControlState.normal)
            
            SVProgressHUD.show()
            cityService.send()
        }
    }
    
    func isValid() -> Bool{
        
        self.view.endEditing(true)
        
        if String(describing: mutArrRegister[0]["value"]!).isEmpty{
            AlertUtil.showCustomAlertWithMessage(Message.ENTER_NAME)
            return false
        }
        
        if String(describing: mutArrRegister[1]["value"]!).isEmpty{
            AlertUtil.showCustomAlertWithMessage(Message.ENTER_EMAIL)
            return false
        }
        else{
            if !(String(describing: mutArrRegister[1]["value"]!).isValidEmail()){
                return false
            }
        }
        
        if String(describing: mutArrRegister[2]["value"]!).isEmpty{
            AlertUtil.showCustomAlertWithMessage(Message.ENTER_CITY)
            return false
        }
        return true
    }
    
    func getCityNameFromId(id: String) -> String{
        print(id)
        let strCity = mutArrCity.filter({$0.id==id})
        if strCity.count > 0{
            return strCity[0].city!
        }
        return ""
    }
    
    //MARK: - Button Actions
    
    @IBAction func btnRegisterPressed(_ sender: Any) {
        
        if isValid(){
            SVProgressHUD.show();
            
            user.name = mutArrRegister[0]["value"] as! String?
            user.email = mutArrRegister[1]["value"] as! String?
            user.city = mutArrRegister[2]["cityId"] as! String?
            user.company = mutArrRegister[3]["value"] as! String?
            user.designation = mutArrRegister[4]["value"] as! String?
            
            signUpService.send(user: user)
        }
    }
    @IBAction func btnBackPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionHeader(_ sender: Any) {
        UIApplication.shared.openURL(URL(string:"http://indianfoundry.org")!);

    }
    //MARK: - Textfield Delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        mutArrRegister[textField.tag]["value"] = textField.text
        
    }
    
    //MARK: - TableView Delegate/Datasorce
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mutArrRegister.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignUpTableViewCell")! as! SignUpTableViewCell
        
        cell.lblTitle.text = mutArrRegister[indexPath.row]["title"] as! String?
        cell.txtValue.tag = indexPath.row
        cell.txtValue.text = mutArrRegister[indexPath.row]["value"] as! String?
        cell.txtValue.keyboardType = .default
        
        if indexPath.row == 1{
            cell.txtValue.keyboardType = .emailAddress
        }
        if indexPath.row == 2{
            cell.txtValue.isEnabled = false
            cell.txtValue.placeholder = "Select"
        }
        if indexPath.row == 5{
            cell.txtValue.isEnabled = false
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2{
            let cityVC = self.storyboard?.instantiateViewController(withIdentifier: "CityListVC") as! CityListVC
            cityVC.objSignUp = self
            self.present(cityVC, animated: false, completion: nil)
        }
    }
    
    //MARK: - Webservice
    func webServiceCallback(){
        
        signUpService.signupSuccess = { (user: User) in
            SVProgressHUD.dismiss();
            self.user.id = user.id;
            AppLifeState.setUser(self.user);
            APP_DELEGATE?.setRootViewControoler();
        }
        
        signUpService.signupFailure = { (errorMessage:String) in
            SVProgressHUD.dismiss();
            
            print(errorMessage)
        }
        
        // CITY List
        cityService.success = { (cityList:[City]) in
            SVProgressHUD.dismiss()
            self.mutArrCity = cityList
            
            self.mutArrRegister[2]["value"] = self.getCityNameFromId(id: self.user.city!)
            print("register:\(self.mutArrRegister)")
            self.tblRegister.reloadData()
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
