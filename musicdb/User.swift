//
//  User.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//

import Foundation


class User  {

  // ログインメソッド
  // @return ログイン成功:true / ログイン失敗:false
  func login(username:String,password:String) -> Bool {
    if(username == "seijiro" && password == "hoge") {
      return true;
    }
    return false;
  }
}
