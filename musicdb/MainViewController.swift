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
    if myAuthContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
      myAuthContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "認証", reply: {
        success, error in
        if success {

          // 遷移するViewを定義する.このas!はswift1.2では as?だったかと。
          //let main2ViewController : Main2ViewController = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as! Main2ViewController
          // アニメーションを設定する.
          //secondViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
          // 値渡ししたい時 hoge -> piyo
          //secondViewController.piyo = self.hoge
          // Viewの移動する.
          //self.present(main2ViewController, animated: true, completion: nil)

          self.textFieldUserName.text = "seijiro"
          self.textFiledPassword.text = "hoge"
          //self.lblLogin.text = "ログインできます"
          let user = User();

          self.loginok = user.login("seijiro", password: "hoge");
          self.nextPage()
        }
        print(success)
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

