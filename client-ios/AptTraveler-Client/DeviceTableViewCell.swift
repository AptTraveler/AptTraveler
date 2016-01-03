//
//  DeviceTableViewCell.swift
//  AptTraveler-Client
//
//  Created by Francis Escuadro on 1/3/16.
//  Copyright © 2016 AptTraveler. All rights reserved.
//

import UIKit
import Alamofire

class DeviceTableViewCell: UITableViewCell {
  
  @IBOutlet var deviceLabel: UILabel?
  @IBOutlet var deviceStatus: UILabel?
  @IBOutlet var deviceSwitch: UISwitch?
  
  @IBOutlet weak var temperatureInput: UITextField?;
  @IBOutlet var temperatureConstraint: NSLayoutConstraint?;
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
    let picker = UIPickerView(frame: CGRect(x: 0, y: 50, width: 100, height: 150));
    picker.delegate = self;
    picker.dataSource = self;
    temperatureInput?.inputView = picker;
    temperatureInput?.text = "75";
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
}

extension DeviceTableViewCell : UIPickerViewDataSource {
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 5
  }
}

extension DeviceTableViewCell : UIPickerViewDelegate {
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    temperatureInput?.text = "77";
    temperatureInput?.resignFirstResponder();
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "75"
  }
  
}