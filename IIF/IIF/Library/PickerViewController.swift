//
//  PickerViewController.swift
//  Walkins Seller
//
//  Created by System Administrator on 10/28/16.
//  Copyright © 2016 onehop. All rights reserved.
//

import UIKit

@objc public protocol PickerViewControllerDelegate : class  {
    
    @objc optional func PickerSelectedItem(title:String,index:Int);
    @objc optional func DatePickerSelectedItem(date:Date);

}
public enum PickerType : String {
    case PickerView = "default",Date = "date",PopUp = "popup";
}



class PickerViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewBottomContainer: UIView!
    
    var listItems : [String]? = [];
    var selectedIndex : Int? = nil;
    var delegate : PickerViewControllerDelegate? = nil;
    var tag:Int = 0;
    var type : PickerType = PickerType.PickerView;
    var currentDate : Date? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    
        switch type {
        case .PickerView:
            datePicker.isHidden = true;
            break;
        case .Date:
            datePicker.minimumDate = Date();
            pickerView.isHidden = true;
            break;
        case .PopUp:
                datePicker.isHidden = true;
                pickerView.isHidden = true;
            break;
        }
        if let date = currentDate{
            datePicker.setDate(date, animated: true);
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if delegate != nil && selectedIndex != nil{
            pickerView.selectRow(selectedIndex!, inComponent: 0, animated: true)
        }
    
        datePicker.backgroundColor = UIColor.white;
    }
    
    // UIPickerViewDataSource
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if let item = listItems?.count{
            return item;
        }
        return 0;
    }
    
    /// UIPickerViewDelegate
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel!
        if label == nil {
            label = UILabel();
            label!.textAlignment = .center;
            label!.font = UIUtil.getBoldFont(13);
        }
        
        let title = listItems?[row]
        label!.text = title;
        return label!;
    }
    
    @IBAction func actionDone(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: {
            
            if self.delegate != nil {
                
                switch self.type {
                    
                case .PickerView:
                    let selectedRow = self.pickerView.selectedRow(inComponent: 0)
                    self.delegate?.PickerSelectedItem!(title:(self.listItems![selectedRow]),index:selectedRow);
                    break;
                case .Date:
                    self.delegate?.DatePickerSelectedItem!(date: self.datePicker.date);
                    break;
                case .PopUp:
                    break;
                }
                
              
            }
        })
    }
    
    @IBAction func actionCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
