//
//  Main2ViewController.swift
//  musicdb
//
//  Created by norainu on 2016/02/14.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit

class Main2ViewController: UIViewController {

  @IBAction func loginAction(_ sender: AnyObject) {
      nextPage()
  }

  func nextPage(){
      let sb:UIStoryboard = UIStoryboard(name: "Application",bundle:Bundle.main)
      let applicationViewController = sb.instantiateViewController(withIdentifier: "Main") as! ApplicationViewController
      self.present(applicationViewController, animated: true, completion: nil)

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}


