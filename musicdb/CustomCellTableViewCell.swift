//
//  CustomCellTableViewCell.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

  @IBOutlet weak var txtTitle: UILabel!
  @IBOutlet weak var txtGenre: UILabel!
  @IBOutlet weak var txtArtist: UILabel!
  @IBOutlet weak var txtAlbum: UILabel!

  var title = "";
  var genre = "";
  var artist = "";
  var album = "";
  var _id = "";


  var pageType:PageType = PageType.Genre

  var delegate : CellDelegate?

  @IBAction func btnNext(sender: AnyObject) {
    self.delegate?.next(self)
  }

  @IBAction func btnPlay(sender: AnyObject) {
    self.delegate?.play(self)
  }

  func clear(){
    title = "";
    genre = "";
    artist = "";
    album = "";
    _id = "";
  }

  func setValues(){

    if title == "" {
      self.txtTitle.text = ""
    }else {
      self.txtTitle.text = title;
    }

    if genre == "" {
      self.txtGenre.text = "";
    } else {
      self.txtGenre.text = "Genre:" + genre;
    }

    if artist == "" {
      self.txtArtist.text = "";
    } else {
      self.txtArtist.text = "Artist:" + artist;
    }

    if album == "" {
      self.txtAlbum.text = "";
    } else {
      self.txtAlbum.text = "Album:" + album;
    }

  }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
      //super.setSelected(selected, animated: animated)
      super.setSelected(false,animated: false)
      // Configure the view for the selected state
    }
    
}
