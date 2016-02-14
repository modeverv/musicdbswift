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
    textFiledPassword.secureTextEntry = true;
    lblLogin.text = ""
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
    if myAuthContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: nil) {
      myAuthContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "認証", reply: {
        success, error in
        if success {

          // 遷移するViewを定義する.このas!はswift1.2では as?だったかと。
          let main2ViewController : Main2ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("secondVC") as! Main2ViewController
          // アニメーションを設定する.
          //secondViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
          // 値渡ししたい時 hoge -> piyo
          //secondViewController.piyo = self.hoge
          // Viewの移動する.
          self.presentViewController(main2ViewController, animated: true, completion: nil)

          self.textFieldUserName.text = "seijiro"
          self.textFiledPassword.text = "hoge"
          //self.lblLogin.text = "ログインできます"

        }
        print(success)
        //self.nextPage()
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

