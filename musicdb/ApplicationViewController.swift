//
//  GenreViewController.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//


import UIKit
import MarqueeLabel
import LocalAuthentication
import SVProgressHUD
import Social
import MediaPlayer

extension UISearchBar {
  var textField: UITextField? {
    return value(forKey: "_searchField") as? UITextField
  }
}
extension UITextField {
  //クリアボタン
  var rightButton: UIButton? {
    return value(forKey: "_clearButton") as? UIButton
  }
  //虫眼鏡
  var lupeImageView: UIImageView? {
    return leftView as? UIImageView
  }
}

class ApplicationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CellDelegate, MyPlayerDelegate ,UISearchBarDelegate{

  let applicationName = "musicdb"

  var GenreModel = Genres()

  var SearchGenreModel = SearchBy()

  var myPlayer = MyPlayer()

  var mode :PageType = PageType.Undefined
  var mode2 : PageType?

  var list :[MusicDTO] = [MusicDTO]();

  var genre = "";
  var artist = "";
  var album = "";
  var track = "";
  var twitter = ""
  var search = ""

  @IBOutlet weak var searchBar: UISearchBar!
  
  @IBOutlet weak var lblDisplay: MarqueeLabel!

  @IBOutlet weak var tableView: UITableView!

  @IBAction func sentTwitter5(_ sender: AnyObject) {
    tweet()
  }
  @IBAction func sentTwitter4(_ sender: AnyObject) {
    tweet()
  }

  @IBAction func sentTwitter3(_ sender: AnyObject) {
    tweet()
  }
  @IBAction func sentTwitter2(_ sender: AnyObject) {
    tweet()
  }
  @IBAction func sendTwitter(_ sender: AnyObject) {
    tweet()
  }

  @IBAction func btnPlayPauseClick(_ sender: AnyObject) {
      myPlayer.playpause()
  }
  @IBAction func btnPrev(_ sender: AnyObject) {
      myPlayer.prev()
  }
  @IBAction func bntNextClick(_ sender: AnyObject) {
      myPlayer.next()
  }

  @IBAction func btnBackClick(_ sender: AnyObject) {
    back()
  }

  func tweet(){
    let twitterPostView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
    twitterPostView.setInitialText(self.twitter + "  #NowPlaying #musicdb")
    self.present(twitterPostView, animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.black
    //self.tableView.estimatedRowHeight = 300
    //self.tableView.rowHeight = UITableViewAutomaticDimension;

    NotificationCenter.default.addObserver(self, selector: #selector(ApplicationViewController.enterBackground(_:)), name:NSNotification.Name(rawValue: "applicationDidEnterBackground"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ApplicationViewController.enterForeground(_:)), name:NSNotification.Name(rawValue: "applicationWillEnterForeground"), object: nil)

    tableView.delegate = self
    tableView.dataSource = self

    myPlayer.delegate = self

    self.searchBar.delegate = self
    self.searchBar.placeholder = "Search"
    self.searchBar.autocapitalizationType = UITextAutocapitalizationType.none
    

    let nib = UINib(nibName: "CustomCellTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "Cell")
    self.tableView.rowHeight = CGFloat(109.0)

    //self.lblDisplay.text = self.applicationName

    if(self.mode2 == nil ){
      self.mode = PageType.Genre
    }else{
      self.mode = self.mode2!
    }
    makeGenreTable()

    self.lblDisplay.text = self.twitter
    //self.serchBar.removeFromSuperview()

    //１個上のサブビュー取得
    for subview1 in self.searchBar.subviews {
      //２個上のサブビュー取得
      for subview2 in subview1.subviews {
        //UIImageViewかどうか判定
        if(subview2.isKind(of: UIImageView.self)){
          let imageView:UIImageView = subview2 as! UIImageView
          //透明にする
          imageView.alpha = 0
        }
      }
    }
    searchBar.textField?.rightButton?.tintColor = UIColor.white

  }

  func dispatch_async_main(_ block: @escaping () -> ()) {
    DispatchQueue.main.async(execute: block)
  }

  func dispatch_async_global(_ block: @escaping () -> ()) {
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: block)
  }

  @objc func enterBackground(_ notification: Notification){
    print("バック")
    //myPlayer.pause()
  }

  @objc func enterForeground(_ notification: Notification){
    print("ふぉあ")
    //myPlayer.pause()
  }

  func makeGenreTable(){
    if(self.mode == PageType.Genre){
      GenreModel.execute()
    }
  }

  func play(_ cell:CustomCellTableViewCell) {
    startplay(cell)
    print("play:")
  }

  func next(_ cell: CustomCellTableViewCell) {
    SVProgressHUD.show(withStatus: "処理中")
    //dispatch_async_global {
    dispatch_async_main {
      switch cell.pageType {
      case .Genre:
        let s = Date()
        self.go2Artist(cell.title)
        self.mode = PageType.Artist
        print("next")
        //self.tableView.reloadData()
        print("next-" + Date().timeIntervalSince(s).description)
        self.go2("Artist")
      case .Artist:
        self.go2Album(cell.artist)
        self.mode = PageType.Album
        print("next")
        //self.tableView.reloadData()
        self.go2("Album")
      case .Album:
        self.go2Track(cell.album)
        self.mode = PageType.Track
        print("next")
        //self.tableView.reloadData()
        self.go2("Track")
      case .Track:
        self.startplay(cell)
        self.mode = PageType.Track
      case .Search:
        self.startplay(cell)
        self.mode = PageType.Search
      case .Undefined:
        break
      }

      //self.lblDisplay.text = mode.rawValue

    }

  }

  func back(){
    SVProgressHUD.show(withStatus: "処理中")
    //dispatch_async_global {
    dispatch_async_main {
      switch self.mode {
      case .Track:
        //print(mode.rawValue + ":genre-" + genre + ":artist-" + artist + ":album-" + album)
        self.mode = PageType.Album
        self.go2Album(self.artist)
        //self.tableView.reloadData()
        self.go2("Album")
      case .Album:
        //print(mode.rawValue + ":genre-" + genre + ":artist-" + artist + ":album-" + album)
        self.mode = PageType.Artist
        self.go2Artist(self.genre)
        //self.tableView.reloadData()
        self.go2("Artist")
      case .Artist:
        //print(mode.rawValue + ":genre-" + genre + ":artist-" + artist + ":album-" + album)
        self.mode = PageType.Genre
        //self.tableView.reloadData()
        self.go2("Main")
      case .Search:
        //print(mode.rawValue + ":genre-" + genre + ":artist-" + artist + ":album-" + album)
        self.mode = PageType.Genre
        //self.tableView.reloadData()
        self.go2("Main")
      case .Genre:
        //print(mode.rawValue + ":genre-" + genre + ":artist-" + artist + ":album-" + album)
        self.mode = PageType.Genre
        SVProgressHUD.dismiss()
      case .Undefined: break
      }
      //lblDisplay.text = mode.rawValue
      //self.lblDisplay.text = mode.rawValue

    }

  }

  func go2Artist(_ gnr:String){
    SVProgressHUD.show(withStatus: "処理中")
    self.genre  = gnr
    list = SearchGenreModel.byGenre(gnr)
  }

  func go2Album(_ artist:String){
    SVProgressHUD.show(withStatus: "処理中")
    self.artist = artist
    list = SearchGenreModel.byArtist(artist)
  }

  func go2Track(_ album:String){
    SVProgressHUD.show(withStatus: "処理中")
    self.album = album
    list = SearchGenreModel.byAlbum(album)
  }

  func startplay(_ cell:CustomCellTableViewCell){
    SVProgressHUD.show(withStatus: "処理中")
    let l = self.SearchGenreModel.makeTrackList(self.mode,c:cell,_id:cell._id)
    self.myPlayer.setPlaylist(l)
    print("set playlist")
    self.myPlayer.play()
    SVProgressHUD.dismiss()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
    print("count")
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
    case .Undefined:
      return GenreModel.genres!.count
    }

  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let s = Date()
    let c = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomCellTableViewCell
    c?.clear()
    c?.delegate = self
    print("invoke cell:" + Date().timeIntervalSince(s).description)
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
    case .Undefined:
      c?.clear()
    }
    c?.setValues()
    print("set cell:" + Date().timeIntervalSince(s).description)
    SVProgressHUD.dismiss()
    return c!

  }

  func display(_ str:String) {
    //self.lblDisplay.text = mode.rawValue + " - " + str
    self.lblDisplay.text = str
    self.twitter = str
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //self.view.endEditing(true)
    searchBar.resignFirstResponder()
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let t = searchBar.text {
      self.search = t
      list = SearchGenreModel.bySearch(t)
      mode = PageType.Search
      //tableView.reloadData()
      go2("Search")
    }
    searchBar.resignFirstResponder()
  }

  func go2(_ sceneName:String){
    SVProgressHUD.dismiss()
    let c :ApplicationViewController = self.storyboard?.instantiateViewController(withIdentifier: sceneName) as! ApplicationViewController
    c.genre = self.genre
    c.artist = self.artist
    c.album = self.album
    c.track = self.track
    c.GenreModel = self.GenreModel
    c.SearchGenreModel = self.SearchGenreModel
    c.myPlayer = self.myPlayer
    c.mode2 = self.mode
    c.list = self.list
    c.twitter = self.twitter
    c.search = self.search
    self.present(c, animated: true, completion: nil)
  }

  // MARK: Remote Command Event
  func addRemoteCommandEvent() -> MPRemoteCommandCenter {
    let commandCenter = MPRemoteCommandCenter.shared()
    commandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(type(of: self).remoteTogglePlayPause(_:)))
    commandCenter.playCommand.addTarget(self, action: #selector(type(of: self).remotePlay(_:)))
    commandCenter.pauseCommand.addTarget(self, action: #selector(type(of: self).remotePause(_:)))
    commandCenter.nextTrackCommand.addTarget(self, action: #selector(type(of: self).remoteNextTrack(_:)))
    commandCenter.previousTrackCommand.addTarget(self, action: #selector(type(of: self).remotePrevTrack(_:)))
    return commandCenter
  }

  @objc func remoteTogglePlayPause(_ event: MPRemoteCommandEvent) {
    print("remoteTogglePlayPause")
    // イヤホンのセンターボタンを押した時の処理
    print("イヤホンのセンターボタンを押した時の処理")
    // （今回は再生中なら停止、停止中なら再生をおこなっています）
    myPlayer.playpause()

  }

  @objc func remotePlay(_ event: MPRemoteCommandEvent) {
    print("remotePlay")
    // プレイボタンが押された時の処理
    myPlayer.playplay()
  }

  @objc func remotePause(_ event: MPRemoteCommandEvent) {
    print("remotePause")
    // ポーズボタンが押された時の処理
    print("ポーズが押された時の処理")
    myPlayer.pause()
  }
  var nextGamaned = false
  @objc func remoteNextTrack(_ event: MPRemoteCommandEvent) {
    // 「次へ」ボタンが押された時の処理
    print("remoteNextTrack")
//    if(nextGamaned){
      myPlayer.next()
//    }
    nextGamaned = !nextGamaned
  }
  var prevGamaned = false
  @objc func remotePrevTrack(_ event: MPRemoteCommandEvent) {
    // 「前へ」ボタンが押された時の処理
    print("remotePrevTrack")
//    if(prevGamaned){
      myPlayer.prev()
//    }
    prevGamaned = !prevGamaned
  }

  override func viewDidAppear(_ animated: Bool) {
    addRemoteCommandEvent()
  }
  override func viewWillDisappear(_ animated: Bool) {
    let commandCenter = MPRemoteCommandCenter.shared()
    commandCenter.togglePlayPauseCommand.removeTarget(self)
    commandCenter.playCommand.removeTarget(self)
    commandCenter.pauseCommand.removeTarget(self)
    commandCenter.nextTrackCommand.removeTarget(self)
    commandCenter.previousTrackCommand.removeTarget(self)
    //[commandCenter.nextTrackCommand removeTarget:self];
    //[commandCenter.previousTrackCommand removeTarget:self];
  }

}



