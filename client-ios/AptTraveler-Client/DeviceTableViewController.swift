//
//  DeviceTableViewController.swift
//  AptTraveler-Client
//
//  Created by Francis Escuadro on 1/3/16.
//  Copyright © 2016 AptTraveler. All rights reserved.
//

import UIKit
import Alamofire

class DeviceTableViewController: UITableViewController {
  
  var devices = [JSON]()
  
  func loadDevices() {
    //    devices.removeAll();
    
    Alamofire.request(.GET, "https://apttraveler.mybluemix.net/api/Homes/24d7a939f333408a42dfbe2a3f1cdb78/devices", parameters: nil)
      .responseJSON { response in
        if let value: AnyObject = response.result.value {
          self.devices = JSON(value).arrayValue
          self.tableView.reloadData();
        }
    }
  }
  
  func updateDevice(deviceID: String, gateway: String, type: String, sender: DeviceTableViewCell?) {
    
    let parameters = [
      "userId": "552494308",
      "password": "NO-PASSWD",
      "appKey": "TE_CE2568549A16C9F0_1",
      "domain": "DL",
      "rememberMe": false
    ];
    
    Alamofire.request(.POST, "https://systest.digitallife.att.com/penguin/api/authtokens", parameters: parameters)
      .responseJSON { response in
        
        if let value: AnyObject = response.result.value {
          let authToken = JSON(value)["content"]["authToken"].stringValue
          let requestToken = JSON(value)["content"]["requestToken"].stringValue
          
          let headers = [
            "Authtoken": authToken,
            "Requesttoken": requestToken,
            "Appkey": "TE_CE2568549A16C9F0_1"
          ]
          
          let gatewayId = JSON(value)["content"]["gateways"][0]["id"]
          
          if type == "door-lock" {
            Alamofire.request(.GET, "https://systest.digitallife.att.com/penguin/api/\(gatewayId)/devices/\(deviceID)/lock", headers: headers)
              .responseJSON { response in
                
                if let value = response.result.value {
                  let lockStatus = JSON(value)["content"]["value"].stringValue
                  print("lockStatus: \(lockStatus)")
                  if lockStatus == "lock" {
                    sender?.lockButton?.setTitle("Locked", forState: UIControlState.Normal)
                  } else {
                    sender?.lockButton?.setTitle("Unlocked", forState: UIControlState.Normal)
                  }
                }
            }
          } else if type == "thermostat"{
            Alamofire.request(.GET, "https://systest.digitallife.att.com/penguin/api/\(gatewayId)/devices/\(deviceID)/temperature", headers: headers)
              .responseJSON { response in
                
                if let value = response.result.value {
                  let temperature = JSON(value)["content"]["value"].intValue
                  let Celsius = temperature / 2 - 40
                  let Fahrenheit = Celsius * 9/5 + 32
                  sender?.temperatureInput?.text = "\(Fahrenheit)°"
                  //                  C = X/2 - 40
                }
            }
            
          }
        }
    }
  }
  
  @IBAction func handleSwitch(sender: UISwitch) {
    var device = devices[sender.tag];
    if sender.on {
      let headers = [
        "Authorization": "Bearer 57d7bec7-af4b-4382-8733-a30c923b0d77"
      ]
      
      Alamofire.request(.GET, "https://graph.api.smartthings.com/api/smartapps/installations/0fdb46dc-c87a-4414-bb26-5811d0a94d71/devices/\(device["id"].stringValue)/switch", headers: headers)
        .responseJSON { response in
          debugPrint(response)
      }
    } else {
      
    }
  }
  
  @IBAction func unlockDoor(sender: UIButton) {
    //    var deviceID = "DL00000027"
    var device = devices[sender.tag];
    let deviceID = device["id"].stringValue
    let parameters = [
      "userId": "552494308",
      "password": "NO-PASSWD",
      "appKey": "TE_CE2568549A16C9F0_1",
      "domain": "DL",
      "rememberMe": false
    ];
    
    Alamofire.request(.POST, "https://systest.digitallife.att.com/penguin/api/authtokens", parameters: parameters)
      .responseJSON { response in
        //        print(response.request)  // original URL request
        //        print(response.response) // URL response
        //        print(response.data)     // server data
        //        print(response.result)   // result of response serialization
        
        if let value: AnyObject = response.result.value {
          let authToken = JSON(value)["content"]["authToken"].stringValue
          let requestToken = JSON(value)["content"]["requestToken"].stringValue
          
          let headers = [
            "authToken": authToken,
            "requestToken": requestToken,
            "appKey": "TE_CE2568549A16C9F0_1"
          ]
          
          let gatewayId = JSON(value)["content"]["gateways"][0]["id"]
          
          var updateParameters: [String: String];
          
          if (sender.titleLabel?.text == "Locked") {
            Alamofire.request(.POST, "https://systest.digitallife.att.com/penguin/api/\(gatewayId)/devices/\(deviceID)/lock/unlock", headers: headers)
              .responseJSON { response in
                
                //        print(response.request)  // original URL request
                //        print(response.response) // URL response
                //        print(response.data)     // server data
                //        print(response.result)   // result of response serialization
                
                if let value = response.result.value {
                  let status = JSON(value)["status"].intValue
                  if status == 0 {
                    sender.setTitle("Unlocked", forState: UIControlState.Normal)
                  } else {
                    print("unlock error");
                  }
                }
            }
          } else {
            Alamofire.request(.POST, "https://systest.digitallife.att.com/penguin/api/\(gatewayId)/devices/\(deviceID)/lock/lock", headers: headers)
              .responseJSON { response in
                if let value = response.result.value {
                  let status = JSON(value)["status"].intValue
                  if status == 0 {
                    sender.setTitle("Locked", forState: UIControlState.Normal)
                  } else {
                    print("lock error");
                  }
                }
            }
          }
        }
    }
  }

  @IBAction func changeTemperature(sender: UITextField) {
    var device = devices[sender.tag];
    let deviceID = device["id"].stringValue
    let parameters = [
      "userId": "552494308",
      "password": "NO-PASSWD",
      "appKey": "TE_CE2568549A16C9F0_1",
      "domain": "DL",
      "rememberMe": false
    ];
    
    Alamofire.request(.POST, "https://systest.digitallife.att.com/penguin/api/authtokens", parameters: parameters)
      .responseJSON { response in
        if let value: AnyObject = response.result.value {
          let authToken = JSON(value)["content"]["authToken"].stringValue
          let requestToken = JSON(value)["content"]["requestToken"].stringValue
          
          let headers = [
            "authToken": authToken,
            "requestToken": requestToken,
            "appKey": "TE_CE2568549A16C9F0_1"
          ]
          
          let gatewayId = JSON(value)["content"]["gateways"][0]["id"]
          
          // Auto A/C
          Alamofire.request(.POST, "https://systest.digitallife.att.com/penguin/api/\(gatewayId)/devices/\(deviceID)/thermostat-mode/auto", headers: headers)
            .responseJSON { response in
              if let value = response.result.value {
                let status = JSON(value)["status"].intValue
                if status == 0 {

                } else {
                  print("thermostat error");
                }
              }
            }
        
        }
      }
    }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadDevices();
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.devices.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("deviceCell", forIndexPath: indexPath) as! DeviceTableViewCell
    
    let device = self.devices[indexPath.row]
    
    if device["gateway"].stringValue != "" {
      //      print("Gateway!: \(device["gateway"].stringValue)")
      updateDevice(device["id"].stringValue, gateway: device["gateway"].stringValue, type:device["type"].stringValue, sender: cell)
      //      if device["type"] == "thermostat" {
      ////        updateDevice(<#T##deviceID: String##String#>, gateway: <#T##String#>)
      ////        C = X/2 - 40
      //      }
    }
    cell.deviceLabel?.text = device["name"].stringValue
    if device["type"].stringValue == "thermostat" {
      cell.temperatureInput?.hidden = false
      cell.temperatureInput?.text = "68°"
      cell.temperatureInput?.tag = indexPath.row
      cell.deviceStatus?.hidden = true
      cell.deviceSwitch?.hidden = true
      cell.lockButton?.hidden = true
    } else if device["type"].stringValue == "switch" { // device["state"].stringValue == "on" || device["state"].stringValue == "off" {
      cell.temperatureInput?.hidden = true
      cell.deviceStatus?.hidden = true
      cell.deviceSwitch?.hidden = false
      cell.deviceSwitch?.on = device["state"].stringValue == "on"
      cell.deviceStatus?.text = device["state"].stringValue;
      cell.deviceSwitch?.tag = indexPath.row;
      cell.lockButton?.hidden = true
    } else if device["type"].stringValue == "door-lock" {
      cell.lockButton?.tag = indexPath.row;
      cell.deviceStatus?.text = "Locked"
      cell.temperatureInput?.hidden = true
      cell.deviceStatus?.hidden = true
      cell.deviceSwitch?.hidden = true
      cell.lockButton?.hidden = false
      //      cell.deviceStatus?.text = device["state"].stringValue;
    } else {
      cell.temperatureInput?.hidden = true
      cell.deviceStatus?.hidden = false
      cell.deviceStatus?.text = device["state"].stringValue
      cell.deviceSwitch?.hidden = true
      cell.lockButton?.hidden = true
    }
    return cell
  }
  
  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the specified item to be editable.
  return true
  }
  */
  
  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
  if editingStyle == .Delete {
  // Delete the row from the data source
  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
  } else if editingStyle == .Insert {
  // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }
  }
  */
  
  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
  
  }
  */
  
  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
  // Return false if you do not want the item to be re-orderable.
  return true
  }
  */
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
