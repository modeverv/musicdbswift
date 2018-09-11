//
//  Player.swift
//  musicdb
//
//  Created by norainu on 2016/01/31.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit
import AVFoundation

class MyPlayer {
  var playList:[MusicDTO] = [MusicDTO]()
  var cursor = 0
  let api = Api()
  var isPlaying = false
  var timer:Timer = Timer()
  var player :AVPlayer = AVPlayer(url: URL(string: "https://lovesaemi.daemon.asia/stream/musicdb/5b8ab8c11d41c8b93e000072/file.m4a")!)

  weak var delegate : MyPlayerDelegate?
  
  func setPlaylist(_ pl:[MusicDTO]){
    print("set playlist is called")
    self.playList = [MusicDTO]()
    for i in 0  ..< pl.count {
      print(pl[i].title)
      self.playList.append(pl[i])
    }
    cursor = 0
  }

  func playpause() {
    if(playList.count != 0){
      if isPlaying {
        player.pause()
        isPlaying = false
      } else {
        player.play()
        isPlaying = true
      }
    }
  }

  func pause() {
    player.pause()
    isPlaying = false
  }

  func play() -> MusicDTO {
    print("play is called")
    //for var i = 0 ; i < playList.count ; i++ {
    //  print(playList[i].toString())
    //}

    let m = playList[cursor]
    let urlString = api.getStreamURLString(m)

print("1")
    print(urlString)
    do {
      player.pause()
    }
    isPlaying = false

    do {
      self.delegate?.display(m.artist + " - " + m.album + " - " + m.title)
      if let url:URL = URL(string: urlString) {
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
print("2")
        player.allowsExternalPlayback = false

        let time = CMTimeMake(60, 60)

        player.addPeriodicTimeObserver(forInterval: time,queue: nil) { (time) -> Void in
          let duration = CMTimeGetSeconds(self.player.currentItem!.duration)
          let time = CMTimeGetSeconds(self.player.currentTime())
          if(duration - 2 <= time){
            self.next()
          }
        }
        player.play()
        isPlaying = true
      }
    }
    return m
  }

  func next(){
    if(playList.count != 0){
      cursor += 1
      if cursor > playList.count - 1 {
        cursor = 0
      }
      play()
    }
  }
  func prev(){
    if(playList.count != 0){
      cursor -= 1
      if cursor < 0 {
        cursor = playList.count - 1
      }
      play()
    }
  }
  
}
