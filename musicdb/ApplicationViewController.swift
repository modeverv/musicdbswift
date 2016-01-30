//
//  GenreViewController.swift
//  musicdb
//
//  Created by norainu on 2016/01/30.
//  Copyright © 2016年 norainu. All rights reserved.
//


import UIKit

class ApplicationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CellDelegate {


  @IBOutlet weak var tableView: UITableView!

  let GenreModel = Genres()
  let SearchModel = Search()
  let SearchGenreModel = SearchByGenre()

  var mode :PageType = PageType.Genre

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.blackColor()
    self.tableView.estimatedRowHeight = 300
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    tableView.delegate = self
    tableView.dataSource = self

    let nib = UINib(nibName: "CustomCellTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
    makeGenreTable()
  }

  func makeGenreTable(){
    GenreModel.execute()
  }


  func play(cell:CustomCellTableViewCell) {
    print("play:" + cell.genre)
  }

  func next(cell: CustomCellTableViewCell) {
    print("next:" + cell.genre)
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
    switch mode {
    case .Genre :
      return GenreModel.genres!.count
    case .Search:
      return 0
    case .Artist:
      return 0
    case .Album:
      return 0
    case .Track:
      return 0
    }
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let c = tableView.dequeueReusableCellWithIdentifier("Cell") as? CustomCellTableViewCell

    let m = GenreModel
    let i = indexPath.row
    switch mode {
    case .Genre:
      c?.title = m.genres![i]["name"].string!
      c?.genre = m.genres![i]["name2"].string!
      c?.delegate = self
      c?.pageType = .Genre
      //case .Artist:
      //case .Album:
      //case .Track:
      //case .Search:
    default:
      print("default")
    }
    c?.setValues()
    return c!
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
