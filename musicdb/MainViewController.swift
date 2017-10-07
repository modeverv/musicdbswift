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

  @IBOutlet weak var lblLogin: UILabel!

  var loginok:Bool = false;
  let myAuthContext = LAContext()

  override func viewDidLoad() {
    super.viewDidLoad()
    textFiledPassword.isSecureTextEntry = true;
    lblLogin.text = ""
    loginCheckWithTouch()

  }
  func setLoginOK(){
    self.loginok = true
  }

  // ログインアクション
  @IBAction func loginAction(_ sender: AnyObject) {
    let user = User();
    if let username = textFieldUserName.text {
      if let password = textFiledPassword.text {
        loginok = user.login(username, password: password);
      }
    }
    nextPage()
  }

  func loginCheckWithTouch() {
    print("touch")
    if myAuthContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
      myAuthContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "認証", reply:
        { (success, error) in
          if success {
          DispatchQueue.main.async {
            self.loginok = true
            self.nextPage()
            }
          }
      })
    }
  }

  func nextPage(){
    if loginok {
      print("OK")
      let sb:UIStoryboard = UIStoryboard(name: "Application",bundle:Bundle.main)
      let applicationViewController = sb.instantiateViewController(withIdentifier: "Main") as! ApplicationViewController
      self.present(applicationViewController, animated: true, completion: nil)

    }else{
      print("NG")
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

