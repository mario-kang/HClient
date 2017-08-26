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
    var URL1 = ""
    var ViewerURL = ""
    var anime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityController = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        var overlay:UIView
        if self.splitViewController != nil {
            activityController?.center = (self.splitViewController?.view.center)!
            overlay = UIView(frame: (self.splitViewController?.view.frame)!)
        }
        else {
            activityController?.center = self.view.center
            overlay = UIView(frame: self.view.frame)
        }
        activityController?.activityIndicatorViewStyle = .whiteLarge
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.8
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
                    self.ViewerURL = (str?.components(separatedBy: "file: \"")[1].components(separatedBy: "\",")[0])!
                }
                else {
                    title = (str?.components(separatedBy: "</a></h1>")[0].components(separatedBy: "<h1>")[3].components(separatedBy: ".html\">")[1])!
                    self.ViewerURL = (str?.components(separatedBy: "<div class=\"cover\"><a href=\"")[1].components(separatedBy: "\"><img src=")[0])!
                    pic = (str?.components(separatedBy: ".html\"><img src=\"")[1].components(separatedBy: "\"></a></div>")[0])!
                }
                let artist1 = str?.components(separatedBy: "</h2>")[0].components(separatedBy: "<h2>")[1]
                var artist = NSLocalizedString("Artist: ", comment: "")
                let artistlist = artist1?.components(separatedBy: "</a></li>")
                if (artist1?.contains("N/A"))! {
                    artist.append("N/A")
                }
                else {
                    for i in 0...(artistlist?.count)!-2 {
                        artist.append(Strings.decode(artistlist?[i].components(separatedBy: ".html\">")[1]))
                        if i != (artistlist?.count)! - 2 {
                            artist.append(", ")
                        }
                    }
                }
                var language = NSLocalizedString("Language: ", comment: "")
                let lang = str?.components(separatedBy: "Language")[1].components(separatedBy: "</a></td>")[0]
                if (lang?.contains("N/A"))! {
                    language.append("N/A")
                }
                else {
                    language.append(Strings.decode(lang?.components(separatedBy: ".html\">")[1]))
                }
                var type = NSLocalizedString("Type: ", comment: "")
                let type1 = str?.components(separatedBy: "<td>Type")[1].components(separatedBy: "</a></td>")[0]
                if (type1?.contains("N/A"))! {
                    type.append("N/A")
                }
                else {
                    type.append(Strings.decode(type1?.components(separatedBy: ".html\">")[1].replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "CG", with: " CG").replacingOccurrences(of: "\n", with: "")))
                }
                var series = NSLocalizedString("Series: ", comment: "")
                let series1 = str?.components(separatedBy: "<td>Series</td>")[1].components(separatedBy: "</ul>")[0]
                let series2 = series1?.components(separatedBy: "</a></li>")
                if (series1?.contains("N/A"))! {
                    series.append("N/A")
                }
                else {
                    for i in 0...(series2?.count)!-2 {
                        series.append(Strings.decode(series2?[i].components(separatedBy: ".html\">")[1]))
                        if i != (series2?.count)! - 2 {
                            series.append(", ")
                        }
                    }
                }
                var tags = NSLocalizedString("Tags: ", comment: "")
                let tags1 = str?.components(separatedBy: "Tags")[1].components(separatedBy: "</td>")[1]
                let tags2 = tags1?.components(separatedBy: "</a></li>")
                if tags2?.count == 1 {
                    tags.append("N/A")
                }
                else {
                    for i in 0...(tags2?.count)!-2 {
                        tags.append(Strings.decode(tags2?[i].components(separatedBy: ".html\">")[1]))
                        if i != (tags2?.count)! - 2 {
                            tags.append(", ")
                        }
                    }
                }
                var characters = NSLocalizedString("Character: ", comment: "")
                let characters1 = str?.components(separatedBy: "Characters")[1].components(separatedBy: "</td>")[1]
                let characters2 = characters1?.components(separatedBy: "</a></li>")
                if characters2?.count == 1 {
                    characters.append("N/A")
                }
                else {
                    for i in 0...(characters2?.count)!-2 {
                        characters.append(Strings.decode(characters2?[i].components(separatedBy: ".html\">")[1]))
                        if i != (characters2?.count)!-2 {
                            characters.append(", ")
                        }
                    }
                }
                var groups = NSLocalizedString("Groups: ", comment: "")
                let groups1 = str?.components(separatedBy: "<td>Group")[1].components(separatedBy: "</td>")[1]
                let groups2 = groups1?.components(separatedBy: "</a></li>")
                if groups2?.count == 1 {
                    groups.append("N/A")
                }
                else {
                    for i in 0...(groups2?.count)!-2 {
                        groups.append(Strings.decode(groups2?[i].components(separatedBy: ".html\">")[1]))
                        if i != (groups2?.count)!-2 {
                            groups.append(", ")
                        }
                    }
                }
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
                            overlay.removeFromSuperview()
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
                    overlay.removeFromSuperview()
                }
            }
        }
        task.resume()
    }
    
    @IBAction func Action(_ sender: Any) {
        let favorites = UserDefaults.standard
        var favoriteslist:[String]
        if let a = favorites.array(forKey: "favorites") as? [String] {
            favoriteslist = a
        }
        else {
            favoriteslist = []
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
        if !(favoriteslist.contains {$0 == self.URL1} ) {
            bookmark = UIAlertAction(title: NSLocalizedString("Add to favorites", comment: ""), style: .default, handler: { (_) in
                favoriteslist.append(self.URL1)
                favorites.set(favoriteslist, forKey: "favorites")
                favorites.synchronize()
            })
        }
        else {
            bookmark = UIAlertAction(title: NSLocalizedString("Remove from favorites", comment: ""), style: .default, handler: { (_) in
                if let index = favoriteslist.index(of: self.URL1) {
                    favoriteslist.remove(at: index)
                    favorites.set(favoriteslist, forKey: "favorites")
                    favorites.synchronize()
                }
            })
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        sheet.addAction(activity)
        sheet.addAction(open)
        sheet.addAction(bookmark)
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
        if (anime.contains("anime")) {
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
        if (anime.contains("anime")) {
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
            UIApplication.shared.delegate?.window??.rootViewController?.showDetailViewController(b, sender: nil)
        }
    }
}
