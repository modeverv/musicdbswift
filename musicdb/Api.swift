//
//  Api.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit
import SwiftyJSON

class Api {
  //let urlBase = "https://seijiro:hoge@lovesaemi.daemon.asia/musicdb_dev/"
  let urlBase = "https://seijiro:hoge@lovesaemi.daemon.asia/musicdb_dev/"
  let urlBase2 = "https://seijiro:hoge@lovesaemi.daemon.asia/"
  let pathGenre = "api/genres"
  let pathSearchByGenre = "api/search_by_genre"
  let pathSearch = "api/search"

  func getGenre() -> JSON {
    let url:URL = URL(string: self.urlBase + self.pathGenre)!
    let request = URLRequest(url: url)
     do {
      let data = try NSURLConnection.sendSynchronousRequest(request, returning: nil)
      let jsondata = try JSON(data: data)
      return jsondata
    }catch {
      print(error)
    }
    return JSON()
  }

  func getSearchByGenre(  qs:String) -> JSON {
    let qqs = qs.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
    let request = URLRequest(url: URL(string: self.urlBase + self.pathSearchByGenre + "?p=1&per=10000000000&qs=" + qqs)!)
     do {
      let data = try NSURLConnection.sendSynchronousRequest(request, returning: nil)
      let jsondata = try JSON(data: data)
      return jsondata
    } catch {
      print(error)
    }
    return JSON()
  }

  func getSearch(_ qs:String) -> JSON {
    let qqs = qs.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
    let request = URLRequest(url: URL(string: self.urlBase + self.pathSearch + "?p=1&per=10000000000&qs=" + qqs)!)
     do {
      let data = try NSURLConnection.sendSynchronousRequest(request, returning: nil)
      let jsondata = try JSON(data: data)
      return jsondata
    }catch {
      print(error)
    }
    return JSON()
  }

  func getStreamURLString(_ dto:MusicDTO) -> String {
    print(urlBase2 + "stream/musicdb/" + dto._id + "/file." + dto.ext)
    return urlBase2 + "stream/musicdb/" + dto._id + "/file." + dto.ext
  }

}
