//
//  InfoDetail.swift
//  HClient
//
//  Created by 강희찬 on 2017. 7. 17..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

import UIKit
import SafariServices
import AVKit
import AVFoundation

class InfoDetail: UIViewController {
    
    @IBOutlet weak var BookmarkIcon: UIBarButtonItem!
    @IBOutlet weak var ActionIcon: UIBarButtonItem!
    @IBOutlet weak var Character: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Type1: UILabel!
    @IBOutlet weak var Group: UILabel!
    @IBOutlet weak var Tag: UILabel!
    @IBOutlet weak var Language: UILabel!
    @IBOutlet weak var Series: UILabel!
    @IBOutlet weak var Artist: UILabel!
    @IBOutlet weak var Title1: UILabel!
    @IBOutlet weak var Image: UIImageView!
    
    var activityController:UIActivityIndicatorView?
    var progressView:UIProgressView!
    var URL1 = ""
    var ViewerURL = ""
    var anime = ""
    var overlay:UIView!
    var explain = ""
    var titlePic:Data!
    var titleName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityController = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        activityController?.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        if self.splitViewController != nil {
            activityController?.center = (self.splitViewController?.view.center)!
            overlay = UIView(frame: (self.splitViewController?.view.frame)!)
            overlay.autoresizingMask = (self.splitViewController?.view.autoresizingMask)!
        }
        else {
            activityController?.center = self.view.center
            overlay = UIView(frame: self.view.frame)
            overlay.autoresizingMask = self.view.autoresizingMask
        }
        activityController?.activityIndicatorViewStyle = .whiteLarge
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.8
        
        let fileManage = FileManager()
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = dirPath[0]
        let _ = skipBackup(filePath: documentPath)
        fileManage.changeCurrentDirectoryPath(documentPath)
        let number = URL1.components(separatedBy: "galleries/")[1].components(separatedBy: ".html")[0]
        do {
            let list = try fileManage.contentsOfDirectory(atPath: documentPath)
            if (list.contains("\(number).txt")) {
                let data = fileManage.contents(atPath: "\(number).txt")
                let fileString = String(data:data!, encoding:.utf8)
                let components = fileString?.components(separatedBy: "\n")
                let title = components![0]
                var artist = components![1]
                var groups = components![2]
                var type = components![3]
                var lang = components![4]
                var series = components![5]
                var tags = components![6]
                var characters = components![7]
                let dates1 = components![8]
                self.ViewerURL = components![9]
                self.URL1 = components![10]
                self.Title1.text = Strings.decode(title)
                self.navigationItem.title = Strings.decode(title)
                artist = NSLocalizedString("Artist: ", comment: "") + artist
                self.Artist.text = artist
                groups = NSLocalizedString("Groups: ", comment: "") + groups
                self.Group.text = groups
                series = NSLocalizedString("Series: ", comment: "") + series
                self.Series.text = series
                type = NSLocalizedString("Type: ", comment: "") + type
                self.Type1.text = type
                lang = NSLocalizedString("Language: ", comment: "") + lang
                self.Language.text = lang
                tags = NSLocalizedString("Tags: ", comment: "") + tags
                self.Tag.text = tags
                characters = NSLocalizedString("Character: ", comment: "") + characters
                self.Character.text = characters
                var dates = NSLocalizedString("Date: ", comment: "")
                let format = DateFormatter()
                format.dateFormat = "yyyy-MM-dd HH:mm:ssZZ"
                let dates2 = format.date(from: dates1)
                let format1 = DateFormatter()
                format1.dateStyle = .medium
                format1.timeStyle = .medium
                let dates3 = format1.string(from: dates2!)
                dates.append(dates3)
                self.Date.text = dates
                let pic = fileManage.contents(atPath: "\(number).jpg")
                let pics = UIImage(data: pic!)
                self.Image.contentMode = .scaleAspectFit
                self.Image.image = pics
                self.explain = "\(Strings.decode(title))\n\(artist)\n\(groups)\n\(type)\n\(lang)\n\(series)\n\(tags)\n\(characters)\n\(dates)\n\(self.ViewerURL)\n\(self.URL1)"
                self.titlePic = pic
            }
            else {
                self.splitViewController?.view.addSubview(overlay)
                overlay.addSubview(activityController!)
                activityController?.isHidden = false
                activityController?.startAnimating()
                let url = URL(string: URL1)
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                let session = URLSession.shared
                let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
                let task = session.dataTask(with: request) { (data, response, error) in
                    if error == nil && (response as! HTTPURLResponse).statusCode == 200 {
                        let str = String(data: data!, encoding: .utf8)
                        self.anime = (str?.components(separatedBy: "<td>Type</td><td>")[1].components(separatedBy: "</a></td>")[0])!
                        var title:String
                        var pic:String
                        if (self.anime.contains("anime")) {
                            title = (str?.components(separatedBy: "<h1>")[2].components(separatedBy: "</h1>")[0])!
                            pic = (str?.components(separatedBy: "\"cover\"><img src=\"")[1].components(separatedBy: "\"></div>")[0])!
                            self.ViewerURL = (str?.components(separatedBy: "file: \"")[1].components(separatedBy: "\",")[0])!.replacingOccurrences(of: "\n", with: "")
                        }
                        else {
                            title = (str?.components(separatedBy: "</a></h1>")[0].components(separatedBy: "<h1>")[3].components(separatedBy: ".html\">")[1])!
                            self.ViewerURL = (str?.components(separatedBy: "<div class=\"cover\"><a href=\"")[1].components(separatedBy: "\"><img src=")[0])!
                            pic = (str?.components(separatedBy: ".html\"><img src=\"")[1].components(separatedBy: "\"></a></div>")[0])!
                        }
                        let artist1 = str?.components(separatedBy: "</h2>")[0].components(separatedBy: "<h2>")[1]
                        var artist = NSLocalizedString("Artist: ", comment: "")
                        var artista = ""
                        let artistlist = artist1?.components(separatedBy: "</a></li>")
                        if (artist1?.contains("N/A"))! {
                            artista.append("N/A")
                        }
                        else {
                            for i in 0...(artistlist?.count)!-2 {
                                artista.append(Strings.decode(artistlist?[i].components(separatedBy: ".html\">")[1]))
                                if i != (artistlist?.count)! - 2 {
                                    artista.append(", ")
                                }
                            }
                        }
                        artist.append(artista)
                        var language = NSLocalizedString("Language: ", comment: "")
                        var langa = ""
                        let lang = str?.components(separatedBy: "Language")[1].components(separatedBy: "</a></td>")[0]
                        if (lang?.contains("N/A"))! {
                            langa = "N/A"
                        }
                        else {
                            langa = Strings.decode(lang?.components(separatedBy: ".html\">")[1])
                        }
                        language.append(langa)
                        var type = NSLocalizedString("Type: ", comment: "")
                        let type1 = str?.components(separatedBy: "<td>Type")[1].components(separatedBy: "</a></td>")[0]
                        var typea = ""
                        if (type1?.contains("N/A"))! {
                            typea = "N/A"
                        }
                        else {
                            typea = Strings.decode(type1?.components(separatedBy: ".html\">")[1].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "CG", with: " CG").replacingOccurrences(of: "\n", with: ""))
                        }
                        type.append(typea)
                        var series = NSLocalizedString("Series: ", comment: "")
                        var seriesa = ""
                        let series1 = str?.components(separatedBy: "<td>Series</td>")[1].components(separatedBy: "</ul>")[0]
                        let series2 = series1?.components(separatedBy: "</a></li>")
                        if (series1?.contains("N/A"))! {
                            seriesa.append("N/A")
                        }
                        else {
                            for i in 0...(series2?.count)!-2 {
                                seriesa.append(Strings.decode(series2?[i].components(separatedBy: ".html\">")[1]))
                                if i != (series2?.count)! - 2 {
                                    seriesa.append(", ")
                                }
                            }
                        }
                        series.append(seriesa)
                        var tags = NSLocalizedString("Tags: ", comment: "")
                        var tagsa = ""
                        let tags1 = str?.components(separatedBy: "Tags")[1].components(separatedBy: "</td>")[1]
                        let tags2 = tags1?.components(separatedBy: "</a></li>")
                        if tags2?.count == 1 {
                            tagsa.append("N/A")
                        }
                        else {
                            for i in 0...(tags2?.count)!-2 {
                                tagsa.append(Strings.decode(tags2?[i].components(separatedBy: ".html\">")[1]))
                                if i != (tags2?.count)! - 2 {
                                    tagsa.append(", ")
                                }
                            }
                        }
                        tags.append(tagsa)
                        var characters = NSLocalizedString("Character: ", comment: "")
                        var charactersa = ""
                        let characters1 = str?.components(separatedBy: "Characters")[1].components(separatedBy: "</td>")[1]
                        let characters2 = characters1?.components(separatedBy: "</a></li>")
                        if characters2?.count == 1 {
                            charactersa.append("N/A")
                        }
                        else {
                            for i in 0...(characters2?.count)!-2 {
                                charactersa.append(Strings.decode(characters2?[i].components(separatedBy: ".html\">")[1]))
                                if i != (characters2?.count)!-2 {
                                    charactersa.append(", ")
                                }
                            }
                        }
                        characters.append(charactersa)
                        var groups = NSLocalizedString("Groups: ", comment: "")
                        var groupsa = ""
                        let groups1 = str?.components(separatedBy: "<td>Group")[1].components(separatedBy: "</td>")[1]
                        let groups2 = groups1?.components(separatedBy: "</a></li>")
                        if groups2?.count == 1 {
                            groupsa.append("N/A")
                        }
                        else {
                            for i in 0...(groups2?.count)!-2 {
                                groupsa.append(Strings.decode(groups2?[i].components(separatedBy: ".html\">")[1]))
                                if i != (groups2?.count)!-2 {
                                    groupsa.append(", ")
                                }
                            }
                        }
                        groups.append(groupsa)
                        var dates = NSLocalizedString("Date: ", comment: "")
                        let dates1 = str?.components(separatedBy: "\"date\">")[1].components(separatedBy: "</span>")[0]
                        let format = DateFormatter()
                        format.dateFormat = "yyyy-MM-dd HH:mm:ssZZ"
                        let dates2 = format.date(from: dates1!)
                        let format1 = DateFormatter()
                        format1.dateStyle = .medium
                        format1.timeStyle = .medium
                        let dates3 = format1.string(from: dates2!)
                        dates.append(dates3)
                        let picurl = "https:\(pic)"
                        let session1 = URLSession.shared
                        let request1 = URLRequest(url: URL(string:picurl)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
                        let sessionTask = session1.dataTask(with: request1, completionHandler: { (data1, _, error1) in
                            if error1 == nil {
                                DispatchQueue.main.async {
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    self.explain = "\(Strings.decode(title))\n\(artista)\n\(groupsa)\n\(typea)\n\(langa)\n\(seriesa)\n\(tagsa)\n\(charactersa)\n\(dates1!)\n\(self.ViewerURL)\n\(self.URL1)"
                                    self.titleName = picurl.components(separatedBy: "/")[5]
                                    self.titlePic = data1
                                    self.navigationItem.title = Strings.decode(title)
                                    self.Image.contentMode = .scaleAspectFit
                                    self.Title1.text = Strings.decode(title)
                                    self.Artist.text = artist
                                    self.Group.text = groups
                                    self.Type1.text = type
                                    self.Language.text = language
                                    self.Series.text = series
                                    self.Tag.text = tags
                                    self.Character.text = characters
                                    self.Date.text = dates
                                    self.Image.image = UIImage(data: data1!)
                                    self.activityController?.isHidden = true
                                    self.activityController?.stopAnimating()
                                    self.overlay.removeFromSuperview()
                                }
                            }
                        })
                        sessionTask.resume()
                        self.ActionIcon.isEnabled = true
                        self.BookmarkIcon.isEnabled = true
                    }
                    else {
                        OperationQueue.main.addOperation {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            var desc = ""
                            if error == nil {
                                desc = HTTPURLResponse.localizedString(forStatusCode: (response as! HTTPURLResponse).statusCode)
                            }
                            else {
                                desc = (error?.localizedDescription)!
                            }
                            let alert = UIAlertController(title: NSLocalizedString("Error Occured.", comment: ""), message: desc, preferredStyle: .alert)
                            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            self.activityController?.isHidden = true
                            self.activityController?.stopAnimating()
                            self.ActionIcon.isEnabled = false
                            self.BookmarkIcon.isEnabled = false
                            self.overlay.removeFromSuperview()
                        }
                    }
                }
                task.resume()
            }
        }
        catch {
            
        }
    }
    
    @IBAction func Action(_ sender: Any) {
        let favorites = UserDefaults.standard
        var favoriteslist:[String]
        var favoritesDownload:[String]
        let fileManager = FileManager()
        var number = ""
        number = self.URL1.components(separatedBy: "/galleries/")[1].components(separatedBy: ".html")[0]
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = dirPath[0]
        if let a = favorites.array(forKey: "favorites") as? [String] {
            favoriteslist = a
        }
        else {
            favoriteslist = []
        }
        if let a = favorites.array(forKey: "favoritesDownload") as? [String] {
            favoritesDownload = a
        }
        else {
            favoritesDownload = []
        }
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let activity = UIAlertAction(title: NSLocalizedString("Share URL", comment: ""), style: .default) { (_) in
            let url = URL(string: self.URL1)
            let activity1 = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            activity1.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activity1, animated: true, completion: nil)
        }
        let open = UIAlertAction(title: NSLocalizedString("Open in Safari", comment: ""), style: .default) { (_) in
            let safari = SFSafariViewController(url: URL(string:self.URL1)!)
            if #available(iOS 10.0, *) {
                safari.preferredBarTintColor = UIColor(hue: 235.0/360.0, saturation: 0.77, brightness: 0.47, alpha: 1.0)
            }
            self.present(safari, animated: true, completion: nil)
        }
        var bookmark:UIAlertAction
        var bookmark1:UIAlertAction? = nil
        if !(favoriteslist.contains {$0 == self.URL1} ) {
            bookmark = UIAlertAction(title: NSLocalizedString("Add to favorites", comment: ""), style: .default, handler: { (_) in
                favoriteslist.append(self.URL1)
                favorites.set(favoriteslist, forKey: "favorites")
                favorites.synchronize()
                fileManager.changeCurrentDirectoryPath(path)
                fileManager.createFile(atPath: "\(number).jpg", contents: self.titlePic, attributes: nil)
                let explainData = self.explain.data(using: .utf8)
                fileManager.createFile(atPath: "\(number).txt", contents: explainData, attributes: nil)
            })
            if !(anime.contains("anime") || ViewerURL.contains("streaming")) {
                bookmark1 = UIAlertAction(title: NSLocalizedString("Add to favorites and download", comment: ""), style: .default, handler: { (_) in
                    favoriteslist.append(self.URL1)
                    favorites.set(favoriteslist, forKey: "favorites")
                    favorites.synchronize()
                    do {
                        OperationQueue.main.addOperation {
                            self.splitViewController?.view.addSubview(self.overlay)
                            let rect = CGRect(x: 0, y: 72.0, width: 200.0, height:2.0)
                            self.progressView = UIProgressView(frame: rect)
                            self.progressView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
                            self.progressView.center = self.view.center
                            self.progressView.progress = 0.0
                            self.progressView.tintColor = UIColor.blue
                            self.overlay.addSubview(self.progressView)
                        }
                        favoritesDownload.append(self.URL1)
                        favorites.set(favoritesDownload, forKey: "favoritesDownload")
                        favorites.set(true, forKey: "isDownloading")
                        favorites.set(self.ViewerURL, forKey: "downloadingURL")
                        favorites.synchronize()
                        fileManager.changeCurrentDirectoryPath(path)
                        fileManager.createFile(atPath: "\(number).jpg", contents: self.titlePic, attributes: nil)
                        let explainData = self.explain.data(using: .utf8)
                        fileManager.createFile(atPath: "\(number).txt", contents: explainData, attributes: nil)
                        try fileManager.createDirectory(atPath: number, withIntermediateDirectories: true, attributes: nil)
                        fileManager.changeCurrentDirectoryPath(number)
                        let viewerURL = "https://hitomi.la\(self.ViewerURL)"
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                        let session = URLSession.shared
                        let task = session.dataTask(with: URL(string:viewerURL)!) { (data, _, error) in
                            if error == nil {
                                let str = String(data:data!, encoding:.utf8)
                                let list = str?.components(separatedBy: "<div class=\"img-url\">//")
                                var picList:[String] = []
                                var fileList:[String] = []
                                for i in 0...(list?.count)!-2 {
                                    let galleries:String = (list?[i+1].components(separatedBy: "</div>")[0])!
                                    let num = galleries.components(separatedBy: "/galleries/")[1].components(separatedBy: "/")[0]
                                    let numb = galleries.components(separatedBy: "/")[3]
                                    let a = String(UnicodeScalar(97 + Int(num)! % 2)!)
                                    picList.append("https://\(a)a.hitomi.la/galleries/\(num)/\(numb)")
                                    fileList.append(numb)
                                }
                                var lists = fileList
                                for i in 0...(list?.count)!-2 {
                                    let pic = picList[i]
                                    let session1 = URLSession.shared
                                    let task1 = session1.dataTask(with: URL(string:pic)!, completionHandler: { (data, _, _) in
                                        fileManager.createFile(atPath: fileList[i], contents: data, attributes: nil)
                                        let per = 1.0 - Float(lists.count) / Float(fileList.count)
                                        OperationQueue.main.addOperation {
                                            self.progressView.progress = per
                                        }
                                        if let index = lists.index(of: fileList[i]) {
                                            lists.remove(at: index)
                                            if lists.count == 0 {
                                                favorites.set(false, forKey: "isDownloading")
                                                favorites.set("", forKey: "downloadingURL")
                                                favorites.synchronize()
                                                OperationQueue.main.addOperation {
                                                    self.overlay.removeFromSuperview()
                                                }
                                            }
                                        }
                                    })
                                    task1.resume()
                                }
                                DispatchQueue.main.async {
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                }
                            }
                            else {
                                OperationQueue.main.addOperation {
                                    self.overlay.removeFromSuperview()
                                    let alert = UIAlertController(title: NSLocalizedString("Error Occured.", comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
                                    let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                }
                            }
                        }
                        task.resume()
                    }
                    catch {
                    
                    }
                })
            }
        }
        else {
            if !(favoritesDownload.contains {$0 == self.URL1}) {
                bookmark = UIAlertAction(title: NSLocalizedString("Remove from favorites", comment: ""), style: .default, handler: { (_) in
                    if let index = favoriteslist.index(of: self.URL1) {
                        favoriteslist.remove(at: index)
                        favorites.set(favoriteslist, forKey: "favorites")
                        favorites.synchronize()
                        do {
                            fileManager.changeCurrentDirectoryPath(path)
                            try fileManager.removeItem(atPath: "\(number).jpg")
                            try fileManager.removeItem(atPath: "\(number).txt")
                        }
                        catch {
                            
                        }
                    }
                })
                if !(anime.contains("anime") || ViewerURL.contains("streaming")) {
                    bookmark1 = UIAlertAction(title: NSLocalizedString("Download", comment: ""), style: .default, handler: { (_) in
                        OperationQueue.main.addOperation {
                            self.splitViewController?.view.addSubview(self.overlay)
                            let rect = CGRect(x: 0, y: 72.0, width: 200.0, height:2.0)
                            self.progressView = UIProgressView(frame: rect)
                            self.progressView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
                            self.progressView.center = self.view.center
                            self.progressView.progress = 0.0
                            self.progressView.tintColor = UIColor.blue
                            self.overlay.addSubview(self.progressView)
                        }
                        do {
                            favoritesDownload.append(self.URL1)
                            favorites.set(favoritesDownload, forKey: "favoritesDownload")
                            favorites.set(true, forKey: "isDownloading")
                            favorites.set(self.ViewerURL, forKey: "downloadingURL")
                            favorites.synchronize()
                            fileManager.changeCurrentDirectoryPath(path)
                            try fileManager.createDirectory(atPath: number, withIntermediateDirectories: true, attributes: nil)
                            fileManager.changeCurrentDirectoryPath(number)
                            let viewerURL = "https://hitomi.la\(self.ViewerURL)"
                            UIApplication.shared.isNetworkActivityIndicatorVisible = true
                            let session = URLSession.shared
                            let task = session.dataTask(with: URL(string:viewerURL)!) { (data, _, error) in
                                if error == nil {
                                    let str = String(data:data!, encoding:.utf8)
                                    let list = str?.components(separatedBy: "<div class=\"img-url\">//")
                                    var picList:[String] = []
                                    var fileList:[String] = []
                                    for i in 0...(list?.count)!-2 {
                                        let galleries:String = (list?[i+1].components(separatedBy: "</div>")[0])!
                                        let num = galleries.components(separatedBy: "/galleries/")[1].components(separatedBy: "/")[0]
                                        let numb = galleries.components(separatedBy: "/")[3]
                                        let a = String(UnicodeScalar(97 + Int(num)! % 2)!)
                                        picList.append("https://\(a)a.hitomi.la/galleries/\(num)/\(numb)")
                                        fileList.append(numb)
                                    }
                                    var lists = fileList
                                    for i in 0...(list?.count)!-2 {
                                        let pic = picList[i]
                                        let session1 = URLSession.shared
                                        let task1 = session1.dataTask(with: URL(string:pic)!, completionHandler: { (data, _, _) in
                                            fileManager.createFile(atPath: fileList[i], contents: data, attributes: nil)
                                            let per = 1.0 - Float(lists.count) / Float(fileList.count)
                                            OperationQueue.main.addOperation {
                                                self.progressView.progress = per
                                            }
                                            if let index = lists.index(of: fileList[i]) {
                                                lists.remove(at: index)
                                                if lists.count == 0 {
                                                    favorites.set(false, forKey: "isDownloading")
                                                    favorites.set("", forKey: "downloadingURL")
                                                    favorites.synchronize()
                                                    OperationQueue.main.addOperation {
                                                        self.overlay.removeFromSuperview()
                                                    }
                                                }
                                            }
                                        })
                                        task1.resume()
                                    }
                                    DispatchQueue.main.async {
                                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    }
                                }
                                else {
                                    OperationQueue.main.addOperation {
                                        self.overlay.removeFromSuperview()
                                        let alert = UIAlertController(title: NSLocalizedString("Error Occured.", comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
                                        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
                                        alert.addAction(action)
                                        self.present(alert, animated: true, completion: nil)
                                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    }
                                }
                            }
                            task.resume()
                        }
                        catch {
                            
                        }
                    })
                }
            }
            else {
                bookmark = UIAlertAction(title: NSLocalizedString("Remove from favorites and downloads", comment: ""), style: .default, handler: { (_) in
                    if let index = favoriteslist.index(of: self.URL1) {
                        favoriteslist.remove(at: index)
                        favorites.set(favoriteslist, forKey: "favorites")
                    }
                    if let index = favoritesDownload.index(of: self.URL1) {
                        favoritesDownload.remove(at: index)
                        favorites.set(favoritesDownload, forKey: "favoritesDownload")
                    }
                    favorites.synchronize()
                    do {
                        fileManager.changeCurrentDirectoryPath(path)
                        try fileManager.removeItem(atPath: "\(number).jpg")
                        try fileManager.removeItem(atPath: "\(number).txt")
                        try fileManager.removeItem(atPath: number)
                    }
                    catch {
                    }
                })
                bookmark1 = UIAlertAction(title: NSLocalizedString("Remove downloads", comment: ""), style: .default, handler: { (_) in
                    if let index = favoritesDownload.index(of: self.URL1) {
                        favoritesDownload.remove(at: index)
                        favorites.set(favoritesDownload, forKey: "favoritesDownload")
                    }
                    do {
                        fileManager.changeCurrentDirectoryPath(path)
                        try fileManager.removeItem(atPath: number)
                    }
                    catch {
                    }
                })
            }
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        sheet.addAction(activity)
        sheet.addAction(open)
        sheet.addAction(bookmark)
        if !(anime.contains("anime") || ViewerURL.contains("streaming")) {
            sheet.addAction(bookmark1!)
        }
        sheet.addAction(cancel)
        sheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        self.present(sheet, animated: true, completion: nil)
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        let share = UIPreviewAction(title: NSLocalizedString("Share URL", comment: ""), style: .default) { (_, _) in
            let url = URL(string: self.URL1)
            let activity = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            activity.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            UIApplication.shared.delegate?.window??.rootViewController?.present(activity, animated: true, completion: nil)
        }
        let openSafari = UIPreviewAction(title: NSLocalizedString("Open in Safari", comment: ""), style: .default) { (_, _) in
            let safari = SFSafariViewController(url: URL(string: self.URL1)!)
            if #available(iOS 10.0, *) {
                safari.preferredBarTintColor = UIColor(hue: 235.0/360.0, saturation: 0.77, brightness: 0.47, alpha: 1.0)
            }
            UIApplication.shared.delegate?.window??.rootViewController?.present(safari, animated: true, completion: nil)
        }
        var openViewer:UIPreviewAction
        if (anime.contains("anime") || ViewerURL.contains("streaming")) {
            openViewer = UIPreviewAction(title: NSLocalizedString("Watch Anime", comment: ""), style: .default) { (_, _) in
                let video = AVPlayerViewController()
                let url = URL(string: "https:\(Strings.decode(self.ViewerURL))")
                let player = AVPlayer(url: url!)
                video.player = player
                video.modalTransitionStyle = .coverVertical
                UIApplication.shared.delegate?.window??.rootViewController?.present(video, animated: true, completion: nil)
                player.play()
            }
        }
        else {
            openViewer = UIPreviewAction(title: NSLocalizedString("Open in Viewer", comment: ""), style: .default) { (_, _) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let b:Viewer = storyboard.instantiateViewController(withIdentifier: "io.github.mario-kang.HClient.viewer") as! Viewer
                b.URL1 = self.ViewerURL
                UIApplication.shared.delegate?.window??.rootViewController?.showDetailViewController(b, sender: nil)
            }
        }
        return [share,openSafari,openViewer]
    }
    
    @IBAction func viewerAction(_ sender: Any) {
        if (anime.contains("anime") || ViewerURL.contains("streaming")) {
            let video = AVPlayerViewController()
            let url = URL(string: "https:\(Strings.decode(ViewerURL))")
            let player = AVPlayer(url: url!)
            video.player = player
            video.modalTransitionStyle = .coverVertical
            video.allowsPictureInPicturePlayback = false
            self.splitViewController?.present(video, animated: true, completion: nil)
            player.play()
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let b:Viewer = storyboard.instantiateViewController(withIdentifier: "io.github.mario-kang.HClient.viewer") as! Viewer
            b.URL1 = self.ViewerURL
            self.navigationController?.pushViewController(b, animated: true)
        }
    }
    
    func skipBackup(filePath: String) -> Bool {
        var url = URL(fileURLWithPath: filePath)
        assert(FileManager.default.fileExists(atPath: filePath), "")
        var success:Bool
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try url.setResourceValues(resourceValues)
            success = true
        }
        catch {
            success = false
        }
        return success
    }
}
