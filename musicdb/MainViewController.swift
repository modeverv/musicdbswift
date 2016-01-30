//
//  ViewController.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit
import LocalAuthentication

class MainViewController: UIViewController {

  @IBOutlet weak var textFieldUserName: UITextField!

  @IBOutlet weak var textFiledPassword: UITextField!

  var loginok:Bool = false;

  override func viewDidLoad() {
    super.viewDidLoad()
    textFiledPassword.secureTextEntry = true;
    loginCheckWithTouch()

  }

  // ログインアクション
  @IBAction func loginAction(sender: AnyObject) {
    let user = User();
    if let username = textFieldUserName.text {
      if let password = textFiledPassword.text {
        loginok = user.login(username, password: password);
      }
    }
    nextPage()
  }

  func loginCheckWithTouch() {
    let myAuthContext = LAContext()
    if myAuthContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: nil) {
      myAuthContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "認証", reply: {
        success, error in
          self.loginok = success
          self.nextPage()
      })
    }
  }

  func nextPage(){
    if loginok {
      print("OK")
      let sb:UIStoryboard = UIStoryboard(name: "Application",bundle:NSBundle.mainBundle())
      let applicationViewController = sb.instantiateViewControllerWithIdentifier("Main") as! ApplicationViewController
      self.presentViewController(applicationViewController, animated: true, completion: nil)
    }else{
      print("NG")
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

