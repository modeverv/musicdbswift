//
//  Player.swift
//  musicdb
//
//  Created by norainu on 2016/01/31.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class MyPlayer {
  var playList:[MusicDTO] = [MusicDTO]()
  var cursor = 0
  let api = Api()
  var isPlaying = false
  var timer:Timer = Timer()
  var player :AVPlayer = AVPlayer(url: URL(string: "https://lovesaemi.daemon.asia/stream/musicdb/5b8ab8c11d41c8b93e000072/file.m4a")!)
  var dur = 0.0

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

  func playplay() {
    player.play()
  }

  func pause() {
/*
    print(self.player.currentTime().seconds)
    let m = playList[cursor]
    self.dur = self.player.currentTime().seconds
    var duration = CMTimeGetSeconds(self.player.currentItem!.duration)
    let time = CMTimeGetSeconds(self.player.currentTime())
    MPNowPlayingInfoCenter.default().nowPlayingInfo = [
      MPMediaItemPropertyTitle: m.title,
      MPMediaItemPropertyArtist : m.album + " / " + m.artist,
      MPNowPlayingInfoPropertyPlaybackRate : NSNumber(value: 1.0), //再生レート
      MPMediaItemPropertyPlaybackDuration : NSNumber(value: duration), //シークバー
      MPNowPlayingInfoPropertyElapsedPlaybackTime: self.player.currentTime().seconds
    ]
*/
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

//      MPNowPlayingInfoCenter.default().nowPlayingInfo = [
//        MPMediaItemPropertyTitle: m.title,
//        MPMediaItemPropertyArtist : m.album + " / " + m.artist,
//      ]

      if let url:URL = URL(string: urlString) {
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
print("2")

        player.allowsExternalPlayback = true
        /// バックグラウンドでも再生できるカテゴリに設定する
        let session = AVAudioSession.sharedInstance()
        do {
          try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch  {
          // エラー処理
          print("カテゴリ設定バックグランド失敗")
          fatalError("カテゴリ設定失敗")
        }

print("3")
        // sessionのアクティブ化
        do {
          try session.setActive(true)
        } catch {
          // audio session有効化失敗時の処理
          // (ここではエラーとして停止している）
          fatalError("session有効化失敗")
        }

print("4")

        let time = CMTimeMake(60, 60)

        player.addPeriodicTimeObserver(forInterval: time,queue: nil) { (time) -> Void in
          var duration = CMTimeGetSeconds(self.player.currentItem!.duration)
          let time = CMTimeGetSeconds(self.player.currentTime())
          if(duration - 2 <= time){
            self.next()
          }

          var nowPlayingInfo: [String: Any] = [:]
          let metadataList = item.asset.metadata
          nowPlayingInfo[MPMediaItemPropertyTitle] = m.title
          nowPlayingInfo[MPMediaItemPropertyArtist] = m.album + " / " + m.artist
          nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: 1.0) //再生レート
          nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = NSNumber(value: duration) //シークバー
          nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentTime().seconds


          for i in metadataList {
              switch i.commonKey {
              case .commonKeyArtwork?:
                  if let data = i.dataValue,
                      let image = UIImage(data: data) {
                    if #available(iOS 10.0, *) {
                      nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
                    } else {
                      // Fallback on earlier versions
                    }
                  }
              case .none: break
              default: break
              }
          }
          let audioInfo = MPNowPlayingInfoCenter.default()
          audioInfo.nowPlayingInfo = nowPlayingInfo
        }

print("5")

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
