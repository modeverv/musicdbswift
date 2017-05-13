//
//  CellDelegate.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit

// CellDelegate プロトコルを記述
@objc protocol CellDelegate {
  // デリゲートメソッド定義
  func play(_ cell:CustomCellTableViewCell)
  func next(_ cell:CustomCellTableViewCell)
}
