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
      print(self.devices.count);
      return self.devices.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("deviceCell", forIndexPath: indexPath) as! DeviceTableViewCell
      
      let device = self.devices[indexPath.row]
      cell.deviceLabel?.text = device["name"].stringValue
//      if indexPath.row % 2 == 0 {
      if device["type"].stringValue == "thermostat" {
        cell.temperatureInput?.hidden = false
        cell.temperatureInput?.text = device["state"].stringValue
        cell.deviceStatus?.hidden = true
        cell.deviceSwitch?.hidden = true
      } else if device["state"].stringValue == "on" || device["state"].stringValue == "off" {
        cell.temperatureInput?.hidden = true
        cell.deviceStatus?.hidden = true
        cell.deviceSwitch?.hidden = false
        cell.deviceSwitch?.on = device["state"].stringValue == "on"
        cell.deviceStatus?.text = device["state"].stringValue;
        cell.deviceSwitch?.tag = indexPath.row;
      } else {
        cell.temperatureInput?.hidden = true
        cell.deviceStatus?.hidden = false
        cell.deviceStatus?.text = device["state"].stringValue
        cell.deviceSwitch?.hidden = true
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
