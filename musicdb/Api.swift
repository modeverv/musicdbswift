//
//  Api.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit

class Api {
  let urlBase = "https://seijiro:hoge@modeverv.aa0.netvolante.jp/musicdb_dev/"
  let pathGenre = "api/genres"
  let pathSearchByGenre = "api/search_by_genre"
  let pathSearch = "api/search"

  func getGenre() -> JSON {
    let request = NSURLRequest(URL: NSURL(string: self.urlBase + self.pathGenre)!)
     do {
      let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
      let jsondata = JSON(data: data)
      return jsondata
    }catch {
      print(error)
    }
    return nil
  }

  func getSearchByGenre(qs:String) -> JSON {
    let qqs = qs.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    let request = NSURLRequest(URL: NSURL(string: self.urlBase + self.pathGenre + "?p=1&per=10000000000&qs=" + qqs)!)
     do {
      let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
      let jsondata = JSON(data: data)
      return jsondata
    }catch {
      print(error)
    }
    return nil
  }

  func getSearch(qs:String) -> JSON {
    let qqs = qs.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    let request = NSURLRequest(URL: NSURL(string: self.urlBase + self.pathGenre + "?p=1&per=10000000000&qs=" + qqs)!)
     do {
      let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
      let jsondata = JSON(data: data)
      return jsondata
    }catch {
      print(error)
    }
    return nil
  }


}