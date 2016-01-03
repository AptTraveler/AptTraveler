//
//  ViewController.swift
//  AptTraveler-Client
//
//  Created by Francis Escuadro on 1/3/16.
//  Copyright © 2016 AptTraveler. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var scrollView: UIScrollView?;
  @IBOutlet var rootStackView: UIStackView?;

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView!.contentSize = CGSize(width: rootStackView!.frame.width, height: rootStackView!.frame.height)
  }


}

