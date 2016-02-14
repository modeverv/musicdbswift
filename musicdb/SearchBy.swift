//
//  SearchByGenre.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchBy {
  var allList:[MusicDTO] = [MusicDTO](); // contain dtos from server
  var genreList:[MusicDTO] = [MusicDTO]() // contain dtos in same genre
  var artistList:[MusicDTO] = [MusicDTO]() // contain dtos in same genre ,artist
  var albumList:[MusicDTO] = [MusicDTO]() // contain dtos in same genre,artist,album
  var searchList:[MusicDTO] = [MusicDTO]() // contain dtos in same search
  var trackList:[MusicDTO] = [MusicDTO]() // contain dtos to play

  let api = Api()

  func isOkExt(ext:String) -> Bool {
    return (
      ext == ""     ||
      ext == "ape"  ||
      ext == "flac" ||
      ext == "mka"  ||
      ext == "tta"  ||
      ext == "tak"
    );
  }

  func isSameGenre(genre:String,json:JSON) -> Bool {
    let gnre:String = json["genre"].string!
    return genre == gnre;
  }

  // by Genre -> Artist List
  func byGenre(genre:String) -> [MusicDTO] {
    let start = NSDate()
    genreList = [MusicDTO]()
    allList = [MusicDTO]()
    print("1:" + NSDate().timeIntervalSinceDate(start).description)
    var data = api.getSearchByGenre(genre)
    print("2:" + NSDate().timeIntervalSinceDate(start).description)
    let json = data[1]
    for(var i = 0; i < json.count ; i++) {
      var ext:String
      if json[i]["ext"].string == nil {
        ext = ""
      }else {
        ext = json[i]["ext"].string!
      }

      if(
        isOkExt(ext)
        ) {
          print("not add:" + ext)
      } else {
        let d = MusicDTO()
        d.genre = json[i]["genre"].string!
        d.artist = json[i]["artist"].string!
        d.album = json[i]["album"].string!
        d.title = json[i]["title"].string!
        d.ext = json[i]["ext"].string!
        d._id = json[i]["_id"].string!
        allList.append(d)
        if (isSameGenre(genre,json:json[i])){
          genreList.append(d)
        }
      }
    }
    print("3:" + NSDate().timeIntervalSinceDate(start).description)
    var gDic:[String:MusicDTO] = [:]
    var gList:[MusicDTO] = [MusicDTO]()
    for var i = 0 ; i < genreList.count ; i++ {
      let d = genreList[i]
      gDic[d.artist] = d
    }
    print("4:" + NSDate().timeIntervalSinceDate(start).description)
    for (_,d) in gDic {
      gList.append(d)
    }
    print("5:" + NSDate().timeIntervalSinceDate(start).description)
    return gList
  }

  // by Artist -> Album List
  func byArtist(artist:String) -> [MusicDTO]{
    artistList = [MusicDTO]()
    var aDic:[String:MusicDTO] = [:]
    for var i=0;i < genreList.count ; i++ {
      let d = genreList[i]
      if( artist == d.artist){
        aDic[d.album] = d
        artistList.append(d)
      }
    }
    var aList:[MusicDTO] = [MusicDTO]()
    for (_,d) in aDic {
      aList.append(d)
    }
    return aList
  }

  // by Album -> Track List
  func byAlbum(album:String) -> [MusicDTO] {
    albumList = [MusicDTO]()
    for var i = 0 ; i < artistList.count ; i++ {
      let d = artistList[i]
      if d.album == album {
        albumList.append(d)
      }
    }
    return albumList
  }

  func bySearch(qs:String) -> [MusicDTO] {
    searchList = [MusicDTO]()
    var data = api.getSearch(qs)
    let json = data[1]
    for var i=0 ; i < json.count ; i++ {
      let ext = json[i]["ext"].string!
      if(
        isOkExt(ext)
        ) {
          print("not add:" + ext)
      } else {
          let d = MusicDTO()
          d.genre = json[i]["genre"].string!
          d.artist = json[i]["artist"].string!
          d.album = json[i]["album"].string!
          d.title = json[i]["title"].string!
          d.ext = json[i]["ext"].string!
          d._id = json[i]["_id"].string!
          searchList.append(d)
      }

    }
    return searchList
  }

  func makeTrackList(type:PageType,c:CustomCellTableViewCell,_id:String = "") -> [MusicDTO] {
    trackList = [MusicDTO]()
    var targetList:[MusicDTO]
    switch type {
    case .Genre:
      byGenre(c.title)
      targetList = genreList
    case .Artist:
      byGenre(c.genre)
      byArtist(c.artist)
      targetList = artistList
    case .Album:
      byGenre(c.genre)
      byArtist(c.artist)
      byAlbum(c.album)
      targetList = albumList
    case .Search:
      targetList = searchList
    case .Track:
      byAlbum(c.album)
      targetList = albumList
    case .Undefined:
      targetList = genreList
    }
    var skiped = false
    var i = 0
    for  ; i < targetList.count ; i++ {
      let d = targetList[i]
        if( _id == d._id || skiped) {
          trackList.append(d)
          skiped = true
        }
    }
    for var j = 0 ; j < i ; j++ {
      let d = targetList[j]
      trackList.append(d)
    }
    return trackList
  }

}