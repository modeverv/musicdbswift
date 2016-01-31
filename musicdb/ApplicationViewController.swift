//
//  GenreViewController.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//


import UIKit
import MarqueeLabel

class ApplicationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CellDelegate, MyPlayerDelegate ,UISearchBarDelegate{

  let applicationName = "musicdb"

  let GenreModel = Genres()

  let SearchGenreModel = SearchBy()

  var mode :PageType = PageType.Genre

  var list :[MusicDTO] = [MusicDTO]();

  var myPlayer = MyPlayer()

  var genre = "";
  var artist = "";
  var album = "";
  var track = "";

  @IBOutlet weak var serchBar: UISearchBar!
  
  //@IBOutlet weak var lblDisplay: UILabel!
  @IBOutlet weak var lblDisplay: MarqueeLabel!

  @IBOutlet weak var tableView: UITableView!


  @IBAction func btnPlayPauseClick(sender: AnyObject) {
      myPlayer.playpause()
  }
  @IBAction func btnPrev(sender: AnyObject) {
      myPlayer.prev()
  }
  @IBAction func bntNextClick(sender: AnyObject) {
      myPlayer.next()
  }

  @IBAction func btnBackClick(sender: AnyObject) {
    back()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.blackColor()
    self.tableView.estimatedRowHeight = 300
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    tableView.delegate = self
    tableView.dataSource = self

    myPlayer.delegate = self

    self.serchBar.delegate = self

    let nib = UINib(nibName: "CustomCellTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
    makeGenreTable()
    self.lblDisplay.text = self.applicationName
  }

  func makeGenreTable(){
    GenreModel.execute()
    mode = PageType.Genre
  }

  func play(cell:CustomCellTableViewCell) {
    startplay(cell)
    print("play:")
  }

  func next(cell: CustomCellTableViewCell) {
    switch cell.pageType {
    case .Genre:
      go2Artist(cell.title)
      mode = PageType.Artist
      print("next")
      self.tableView.reloadData()
    case .Artist:
      go2Album(cell.artist)
      mode = PageType.Album
      print("next")
      self.tableView.reloadData()
    case .Album:
      go2Track(cell.album)
      mode = PageType.Track
      print("next")
      self.tableView.reloadData()
    case .Track:
      startplay(cell)
      mode = PageType.Track
    case .Search:
      startplay(cell)
      mode = PageType.Search
    }
    //self.lblDisplay.text = mode.rawValue
  }

  func back(){
    switch mode {
    case .Track:
      print(mode.rawValue + ":genre-" + genre + ":artist-" + artist + ":album-" + album)
      mode = PageType.Album
      go2Album(self.artist)
      self.tableView.reloadData()
    case .Album:
      print(mode.rawValue + ":genre-" + genre + ":artist-" + artist + ":album-" + album)
      mode = PageType.Artist
      go2Artist(self.genre)
      self.tableView.reloadData()
    case .Artist:
      print(mode.rawValue + ":genre-" + genre + ":artist-" + artist + ":album-" + album)
      mode = PageType.Genre
      self.tableView.reloadData()
    case .Search:
      print(mode.rawValue + ":genre-" + genre + ":artist-" + artist + ":album-" + album)
      mode = PageType.Genre
      self.tableView.reloadData()
    case .Genre:
      print(mode.rawValue + ":genre-" + genre + ":artist-" + artist + ":album-" + album)
      mode = PageType.Genre
    }
    //lblDisplay.text = mode.rawValue
    print("back")
    //self.lblDisplay.text = mode.rawValue
  }

  func go2Artist(gnr:String){
    self.genre  = gnr
    list = SearchGenreModel.byGenre(gnr)
  }
  func go2Album(artist:String){
    self.artist = artist
    list = SearchGenreModel.byArtist(artist)
  }
  func go2Track(album:String){
    self.album = album
    list = SearchGenreModel.byAlbum(album)
  }
  func startplay(cell:CustomCellTableViewCell){
    print("startplay:" + cell.pageType.rawValue)
    let l = SearchGenreModel.makeTrackList(mode,c:cell,_id:cell._id)
    myPlayer.setPlaylist(l)
    myPlayer.play()
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
    switch mode {
    case .Genre :
      return GenreModel.genres!.count
    case .Search:
      return list.count
    case .Artist:
      return list.count
    case .Album:
      return list.count
    case .Track:
      return list.count
    }
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let c = tableView.dequeueReusableCellWithIdentifier("Cell") as? CustomCellTableViewCell
    
    c?.clear()
    c?.delegate = self

    let i = indexPath.row
    switch mode {
    case .Genre:
      let m = GenreModel
      c?.title = m.genres![i]["name"].string!
      c?.genre = m.genres![i]["name2"].string!
      c?.delegate = self
      c?.pageType = .Genre
    case .Artist:
      if list.count > i {
      c?.title = list[i].artist
      c?.genre = list[i].genre
      c?.artist = list[i].artist
      c?._id = list[i]._id
      c?.pageType = .Artist
      }
    case .Album:
      if list.count > i {
      c?.title = list[i].album
      c?.genre = list[i].genre
      c?.artist = list[i].artist
      c?.album = list[i].album
      c?._id = list[i]._id
      c?.pageType = .Album
      }
    case .Track:
      if list.count > i {
      c?.title = list[i].title
      c?.genre = list[i].genre
      c?.artist = list[i].artist
      c?.album = list[i].album
      c?._id = list[i]._id
      c?.pageType = .Track
      }
    case .Search:
      if list.count > i {
      c?.title = list[i].title
      c?.genre = list[i].genre
      c?.artist = list[i].artist
      c?.album = list[i].album
      c?._id = list[i]._id
      c?.pageType = .Search
      }
    }
    c?.setValues()
    return c!
  }

  func display(str:String) {
    self.lblDisplay.text = mode.rawValue + " - " + str
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
  }

  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    self.view.endEditing(true)
    searchBar.resignFirstResponder()
  }

  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    if let t = searchBar.text {
      list = SearchGenreModel.bySearch(t)
      mode = PageType.Search
      tableView.reloadData()
    }
    searchBar.resignFirstResponder()
  }
}
