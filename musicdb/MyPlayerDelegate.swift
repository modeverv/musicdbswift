//
//  MyPlayerDelegate.swift
//  musicdb
//
//  Created by norainu on 2016/01/31.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit

// CellDelegate プロトコルを記述
@objc protocol MyPlayerDelegate {
  // デリゲートメソッド定義
  func display(_ s:String)
}
