# musicdb swift interface

## [swift]2016年1月版swift初心者がアプリを作るまで
swift初心者がゴニョゴニョしながら20時間ぐらいで作りました。  
swiftらしさとか知りません。存分に汚いですが、とりあえず動きます。  
拙いけれど、頑張って作りました。  
このアプリケーションは既存のAPIを利用し音楽を楽しむものです。  
従前からPC用のインターフェースがあり、そこにスマホ用のインターフェースを追加し、楽しんでいましたが、iPhoneのSafariですとスリープしてしまうと音楽が続かないという問題がありました。  
今回、swiftでアプリとして作ることでこの問題に対応しようとしました。  
以下の仕組みについて調べながらつくっていたメモを記述します。  

- 巷のswift情報について、swift2の習得
- ログイン
- そもそもライブラリのインストール方法がわからん
- JSONの取り扱い
- httpリクエストする方法がわからない。
- TouchIDについて
- 型変換まとめ
- MarqueeLabel
- 音楽のバックグランド再生
- バックグラウンド次へ
- UITableViewのCellの自作
- ストーリボード画面遷移
- スリーブさせない
- 検索機能
- バックグラウンド・フォアグラウンド時のフック
- Xcodeがこなれていない

## 巷のswift情報について、swift2の習得
swiftは現在swift2になり、書籍を一冊購入していましたがswift1系で、使い物になりません。
WEBの情報もswift1時代のものが多く、混乱します。
そこで、

- https://github.com/hatena/Hatena-Textbook/blob/master/swift-programming-language.md

を参照し、詳しく知りたいときは各要素について更にググる方針にしました。  
文法を覚えるのではなく、やりたいことをやるために必要な文法を拾い上げる方式にしました。

## ログイン
storyboardにテキストフィールドとパスワード用のテキストフィールドを配置し、ボタンを配置し、ボタンアクションをつなげた。

```swift

  // ログインアクション
  @IBAction func loginAction(sender: AnyObject) {
    let user = User();
    if let username = textFieldUserName.text {
      if let password = textFiledPassword.text {
        loginok = user.login(username, password: password);
      }
    }
    // 次のストーリーボードに遷移するメソッド。loginokで遷移の可否を判定
    nextPage() 
  }
  
```

## そもそもライブラリのインストール方法わからん
cocoapodsというrubyのbundleみたいな仕組みがあるようです。利用しました。
- http://qiita.com/satoken0417/items/479bcdf91cff2634ffb1

```sh
$ pod init
$ emacs Podfile
$ pod install / update
$ open musicdb.xcworkspace # コレ便利
```

## JSONの取り扱い
- http://qiita.com/susieyy/items/6cd0a2293555d5abb9c1
- https://github.com/SwiftyJSON/SwiftyJSON
下記のような感じになります
>|swift|
let json = JSON(data: "[{genre:1}]")
let hoge = json[0]["genre"].string!
||<

## httpリクエストする方法がわからない。
JSONライブラリはSwiftyJSONを選択しました。  
```swift
import SwiftyJSON
...
   let qs = "日本語の文字列"
   let qqs = qs.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!
   let request = NSURLRequest(URL: NSURL(string: "https://hoge.com/api/aaa"+ "?p=1&per=10000000000&qs=" + qqs)!)
   let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
   let jsondata = JSON(data: data)
```

## TouchID
```swift
import LocalAuthentication
..
  let myAuthContext = LAContext()
..
  func loginCheckWithTouch() {
    if myAuthContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: nil) {
      myAuthContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "認証", reply: {
        success, error in
        if success {
          // ここの入力が非常に時間がかかる。今のところ原因不明
          self.textFieldUserName.text = "user"
          self.textFiledPassword.text = "pass"
          self.lblLogin.text = "ログインできます"
        }
      })
    }
  }
```
## 型変換まとめ
- http://qiita.com/Braian/items/ba8a19f84a830f229e1b
- http://stackoverflow.com/questions/26350977/how-to-round-a-double-to-the-nearest-int-in-swift
FloatからIntに落としてStringとかかなり難しそう。30分ぐらい調べたができなかった。
あきらめました。

## MarqueeLabel
cocoapodsだけではダメだった
swiftファイルをzipでダウンロードしてきてLibとかのグループ掘ってswiftファイル
を配置しないと上手く動かなかった。

## 音楽のバックグランド再生
youtubeアプリがバックグランドでポーズになりますよね。このアプリでもその挙動に合わせました。ちょっと時間がなかったのもありますが。
- http://nackpan.net/blog/2015/09/24/ios-swift-play-in-background/
使ってない
## バックグラウンド次へ
- http://nackpan.net/blog/2015/09/24/ios-swift-play-in-background/
使ってない

## UITableViewのCellの自作
- http://gaku3601.hatenablog.com/entry/2015/05/10/215959

デリゲートも必要。デリゲートは本当に必要。そして便利

- http://nukenuke.hatenablog.com/entry/2015/09/17/120749

```swift
// xibに対応するswiftファイル
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

  var delegate : CellDelegate? // delegate
  ..
// delegate
import UIKit

// CellDelegate プロトコルを記述
@objc protocol CellDelegate {
  // デリゲートメソッド定義
  func play(cell:CustomCellTableViewCell)
  func next(cell:CustomCellTableViewCell)
}
// 通知される側(コントローラー)
class ApplicationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CellDelegate/*コレ*/, MyPlayerDelegate ,UISearchBarDelegate{
..
  override func viewDidLoad() {
    super.viewDidLoad()
    // delegate系
    tableView.delegate = self
    tableView.dataSource = self
    myPlayer.delegate = self
    self.serchBar.delegate = self
    // cellの登録
    let nib = UINib(nibName: "CustomCellTableViewCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    let c = tableView.dequeueReusableCellWithIdentifier("Cell") as? CustomCellTableViewCell
   
    c?.clear() // セルの内容をクリアする自作メソッド
    c?.delegate = self // delegateを取得
```

## ストーリボード画面遷移
- http://mt.hatenadiary.com/entry/2015/07/19/023142

ストリーボードのファイル名とストリーボードにつけた名前で遷移する
```swift
      let sb:UIStoryboard = UIStoryboard(name: "Application",bundle:NSBundle.mainBundle())
      let applicationViewController = sb.instantiateViewControllerWithIdentifier("Main") as! ApplicationViewController
      self.presentViewController(applicationViewController, animated: true, completion: nil)
```

## スリーブさせない
-http://kappa-game.hatenadiary.jp/entry/2015/11/24/swift2.0_%E3%81%A7%E3%82%B2%E3%83%BC%E3%83%A0%E3%83%97%E3%83%AC%E3%82%A4%E4%B8%AD%E3%81%AB%E3%82%B9%E3%83%AA%E3%83%BC%E3%83%97%E3%81%95%E3%81%9B%E3%81%AA%E3%81%84%E3%82%88%E3%81%86%E3%81%AB%E3%81%99

```swift
    // スリープさせない
    UIApplication.sharedApplication().idleTimerDisabled = true
```

## 検索機能
- https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/uikit/025-uisearchbarno-biao-shi

入力キーボードを消すにはUISearchBarのキャンセルボタンを表示させるようにさせて
```swift
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder() // これでキーボード収まる
  }

  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    if let t = searchBar.text {
      list = SearchGenreModel.bySearch(t) // 検索処理
      mode = PageType.Search // 検索処理
      tableView.reloadData() // テーブルをリセット
    }
    searchBar.resignFirstResponder() // これでキーボード収まる
  }
```
とする。

## バックグラウンド・フォアグラウンド時のフック
AppDelegateで通知を発行してそれをViewControllerで取得する感じ
```swift
// @AppDelegate.swift
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSNotificationCenter.defaultCenter().postNotificationName("applicationWillResignActive", object: nil)
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSNotificationCenter.defaultCenter().postNotificationName("applicationDidEnterBackground", object: nil)
  }
// @ViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterBackground:", name:"applicationDidEnterBackground", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterForeground:", name:"applicationWillEnterForeground", object: nil)
..
  func enterBackground(notification: NSNotification){
    print("バックグラウンド")
    myPlayer.pause()
  }

  func enterForeground(notification: NSNotification){
    print("フォアグラウンド")
    myPlayer.pause()
  }
```

## Xcodeがこなれていない感じ
Java+Eclipseに比べるとちょっと拙い感触がした。かゆいところに手がとどかない感じ。
リファクタリングできませんし。。
