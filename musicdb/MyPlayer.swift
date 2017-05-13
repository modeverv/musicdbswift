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
  var player :AVPlayer = AVPlayer()

  weak var delegate : MyPlayerDelegate?
  
  func setPlaylist(_ pl:[MusicDTO]){
    self.playList = [MusicDTO]()
    for i in 0  ..< pl.count {
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
    //for var i = 0 ; i < playList.count ; i++ {
    //  print(playList[i].toString())
    //}
    player.pause()
    isPlaying = false

    let m = playList[cursor]
    let urlString = api.getStreamURLString(m)

    do {
      self.delegate?.display(m.artist + " - " + m.album + " - " + m.title)
      if let url:URL = URL(string: urlString) {
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)

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
