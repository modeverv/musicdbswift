//
//  MusicDTO.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit

class MusicDTO {
  var genre:String = ""
  var artist:String = ""
  var album:String = ""
  var title:String = ""
  var ext:String = ""
  var _id:String = ""

  func toString() -> String {
    return [genre,artist,album,title,ext,_id].joinWithSeparator(" - ")
  }
}