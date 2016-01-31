//
//  Genres.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//

import Foundation
import SwiftyJSON

class Genres {
  var data :JSON?
  let api = Api()
  var genres :JSON?

  func execute() -> Void {
    if data == nil {
      data = api.getGenre()
    }
    genres = data![1]
  }

}
