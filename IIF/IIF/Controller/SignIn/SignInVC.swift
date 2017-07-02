//
//  SignInVC.swift
//  IIF
//
//  Created by Kuldip Bhalodiya on 1/30/17.
//  Copyright © 2017 IIF. All rights reserved.
//

import UIKit

class SignInVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtOTP: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnChangeMobileNo: UIButton!
    
    fileprivate var loginService : LoginService = LoginService()
    
    var userModel : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        doIntialize()
        
        showMobileView(isMobileView: true)
    }
    
    //MARK :- Class Methods
    
    func doIntialize(){
        
        txtMobileNo.attributedPlaceholder =
            NSAttributedString(string: txtMobileNo.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        txtOTP.attributedPlaceholder =
            NSAttributedString(string: txtOTP.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        webServiceCallback()
    }
    
    func showMobileView(isMobileView : Bool){
        
        txtMobileNo.isHidden = !isMobileView
        txtOTP.isHidden = isMobileView
        btnChangeMobileNo.isHidden = isMobileView
        
        if isMobileView{
            btnLogin.setTitle("Login", for: UIControlState.normal)
            btnLogin.tag = 0
        }else{
            btnLogin.setTitle("Submit", for: UIControlState.normal)
            btnLogin.tag = 1
        }
    }
    
    //MARK: - TextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !(string.isEmpty){

            if (textField.text?.characters.count)! >= 10 && textField == txtMobileNo{
                
                return false
            }
            if (textField.text?.characters.count)! >= 4 && textField == txtOTP{
                
                return false
            }
        }
        return true
    }
    @IBAction func txtPhoneNumberChange(_ sender: UITextField) {
        
        if (sender.text?.characters.count)! >= 10 && sender == txtMobileNo{
            txtMobileNo.resignFirstResponder();
        }
        
    }
    
    @IBAction func txtOTPChange(_ sender: UITextField) {
        if ((sender as AnyObject).text?.characters.count)! >= 4 && sender == txtOTP{
            txtOTP.resignFirstResponder();
        }
    }
    
    
    //MARK :- Button Actions
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        
        let button = sender as! UIButton
        if button.tag == 0{
            
            if (txtMobileNo.text?.isEmpty)!{
                AlertUtil.showCustomAlertWithMessage(Message.ENTER_MOBILE)
            }else{
                if (txtMobileNo.text?.characters.count == 10){
                    SVProgressHUD.show();
                    loginService.send(phoneNumber: txtMobileNo.text!)
                }else{
                    AlertUtil.showCustomAlertWithMessage(Message.ENTER_MOBILE_VALID)
                }
            }
            
        }else{
           
            if (txtOTP.text?.isEmpty)!{
                AlertUtil.showCustomAlertWithMessage(Message.ENTER_OTP)
            }else if Int(txtOTP.text!) != (userModel?.otp)! {
                AlertUtil.showCustomAlertWithMessage(Message.ENTER_OTP_VALID)
            }else{
                AppLifeState.setUser(userModel);
                APP_DELEGATE?.setRootViewControoler();
            }
        }
    }
    
    @IBAction func btnMobileTapped(_ sender: Any) {
        txtOTP.text = ""
        showMobileView(isMobileView: true)
    }
    
    //MARK: - Webservice
    func webServiceCallback(){
        
        loginService.loginSuccess = { (user: User) in
            SVProgressHUD.dismiss();
            
            self.showMobileView(isMobileView: false)
            
            self.userModel = user;
            self.userModel.phoneNumber = self.txtMobileNo.text
            
        }
        
        loginService.loginFailure = { (errorMessage:String) in
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
