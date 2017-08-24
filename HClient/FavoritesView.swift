//
//  FavoritesView.swift
//  HClient
//
//  Created by 강희찬 on 2017. 7. 18..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

import UIKit

class FavoritesCell: UITableViewCell {
    @IBOutlet weak var DJImage: UIImageView!
    @IBOutlet weak var DJSeries: UILabel!
    @IBOutlet weak var DJTitle: UILabel!
    @IBOutlet weak var DJLang: UILabel!
    @IBOutlet weak var DJTag: UILabel!
    @IBOutlet weak var DJArtist: UILabel!
}

class FavoritesView: UITableViewController, UIViewControllerPreviewingDelegate {
    
    var activityController:UIActivityIndicatorView!
    var arr:[Any] = []
    var arr3:[Any] = []
    var celllist:[String] = []
    var favoriteslist:[Any] = []
    var favoritesdata:[Any] = []
    var favoriteskeys:[Any] = []
    var picURLs:[String] = []
    var pics = 0
    var previewingContext:Any?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 154.0
        let favorites = UserDefaults.standard
        if let a = favorites.array(forKey: "favorites") {
            favoriteslist = a
        }
        if let b = favorites.array(forKey: "favoritesKey") {
            favoriteskeys = b
        }
        favoritesdata.removeAll()
        picURLs.removeAll()
        arr.removeAll()
        arr3.removeAll()
        celllist.removeAll()
        if favoriteslist.count != 0 {
            let overlay = UIView(frame: self.splitViewController!.view.frame)
            overlay.backgroundColor = UIColor.black
            overlay.alpha = 0.8
            self.splitViewController?.view.addSubview(overlay)
            overlay.addSubview(activityController)
            activityController.isHidden = false
            activityController.startAnimating()
            for _ in 0...favoriteslist.count-1 {
                favoritesdata.append(NSNull())
                arr.append(NSNull())
                arr3.append(NSNull())
            }
            for a in 0...self.favoriteslist.count-1 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                let url = URL(string: self.favoriteslist[a] as! String)
                let session = URLSession.shared
                let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
                let task = session.dataTask(with: request, completionHandler: { (data, _, error) in
                    if error == nil {
                        let str = String(data: data!, encoding:.utf8)
                        let title1 = str?.components(separatedBy: "</a></h1>")[0]
                        let title2 = title1?.components(separatedBy: "<h1>")[3].components(separatedBy: ".html\">")[1]
                        let artist1 = str?.components(separatedBy: "</h2>")[0].components(separatedBy: "<h2>")[1]
                        var artist = NSLocalizedString("Artist: ", comment: "")
                        let artistlist = artist1?.components(separatedBy: "</a></li>")
                        if (artist1?.contains("N/A"))! {
                            artist.append("N/A")
                        }
                        else {
                            for i in 0...(artistlist?.count)!-2 {
                                artist.append(Strings.decode(artistlist?[i].components(separatedBy: ".html\">")[1]))
                                if i != (artistlist?.count)!-2 {
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
                        var series = NSLocalizedString("Series: ", comment: "")
                        let series1 = str?.components(separatedBy: "<td>Series</td>")[1].components(separatedBy: "</ul>")[0]
                        let series2 = series1?.components(separatedBy: "</a></li>")
                        if (series1?.contains("N/A"))! {
                            series.append("N/A")
                        }
                        else {
                            for i in 0...(series2?.count)!-2 {
                                series.append(Strings.decode(series2?[i].components(separatedBy: ".html\">")[1]))
                                if i != (series2?.count)!-2 {
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
                                if i != (tags2?.count)!-2 {
                                    tags.append(", ")
                                }
                            }
                        }
                        let pic = str?.components(separatedBy: ".html\"><img src=\"")[1].components(separatedBy: "\"></a></div>")[0]
                        let picurl = "https:\(pic!)"
                        self.arr[a] = data!
                        var dic:[String:String] = [:]
                        dic["title"] = Strings.decode(title2)
                        dic["artist"] = artist
                        dic["language"] = language
                        dic["series"] = series
                        dic["tags"] = tags
                        self.favoritesdata[a] = dic
                        self.picURLs.append(picurl)
                        DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            if a == self.favoriteslist.count-1 {
                                self.pics = a
                                self.activityController.isHidden = true
                                self.activityController.stopAnimating()
                                overlay.removeFromSuperview()
                                self.tableView.reloadData()
                            }
                        }
                    }
                    else {
                        OperationQueue.main.addOperation {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            let alert = UIAlertController(title: NSLocalizedString("Error Occured.", comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
                            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            self.activityController.isHidden = true
                            self.activityController.stopAnimating()
                            overlay.removeFromSuperview()
                        }
                    }
                })
                task.resume()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        activityController = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        activityController.center = (self.splitViewController?.view.center)!
        activityController.activityIndicatorViewStyle = .whiteLarge
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            self.previewingContext = self.registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: self.view)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("Hitomi Items", comment: "")
        }
        else {
            return NSLocalizedString("Hitomi Tags", comment: "")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return favoriteslist.count
        }
        else {
            return favoriteskeys.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:FavoritesCell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as! FavoritesCell
            cell.DJImage.contentMode = .scaleAspectFit
            if let a:[String:String] = favoritesdata[indexPath.row] as? [String : String] {
                cell.DJTitle.text = a["title"]
                cell.DJArtist.text = a["artist"]
                cell.DJSeries.text = a["series"]
                cell.DJLang.text = a["language"]
                cell.DJTag.text = a["tags"]
                let session = URLSession.shared
                if picURLs.count != 0 {
                    if arr3[indexPath.row] is UIImage {
                        cell.DJImage.image = arr3[indexPath.row] as? UIImage
                    }
                    else {
                        cell.DJImage.image = nil
                    }
                    if !(celllist.contains(where: {$0 == "\(indexPath.row)"})) && pics == favoriteslist.count - 1 && favoriteslist.count == picURLs.count {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                        let request = URLRequest(url: URL(string:picURLs[indexPath.row])!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
                        let sessionTask = session.dataTask(with: request, completionHandler: { (data, _, error) in
                            if error == nil {
                                let image = UIImage(data: data!)
                                self.arr3[indexPath.row] = image!
                                DispatchQueue.main.async {
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    cell.DJImage.image = image
                                }
                            }
                        })
                        sessionTask.resume()
                        if !(celllist.contains {$0 == "\(indexPath.row)"}) {
                            celllist.append("\(indexPath.row)")
                        }
                    }
                }
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listKeyword", for: indexPath)
            cell.textLabel?.text = favoriteskeys[indexPath.row] as? String
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favorites = UserDefaults.standard
            if indexPath.section == 0 {
                arr.remove(at: indexPath.row)
                favoriteslist.remove(at: indexPath.row)
                favoritesdata.remove(at: indexPath.row)
                picURLs.remove(at: indexPath.row)
                arr3.remove(at: indexPath.row)
                celllist.remove(at: celllist.count-1)
                favorites.set(favoriteslist, forKey: "favorites")
                favorites.synchronize()
                tableView.deleteRows(at: [indexPath], with: .fade)
                pics -= 1
                tableView.reloadData()
            }
            else {
                favoriteskeys.remove(at: indexPath.row)
                favorites.set(favoriteskeys, forKey: "favoritesKey")
                favorites.synchronize()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let defaults = UserDefaults.standard
        if sourceIndexPath.section == 0 {
            let url = favoriteslist[sourceIndexPath.row]
            let urls = picURLs[sourceIndexPath.row]
            let pic = arr3[sourceIndexPath.row]
            favoriteslist.remove(at: sourceIndexPath.row)
            favoriteslist.insert(url, at: destinationIndexPath.row)
            picURLs.remove(at: sourceIndexPath.row)
            picURLs.insert(urls, at: destinationIndexPath.row)
            arr3.remove(at: sourceIndexPath.row)
            arr3.insert(pic, at: destinationIndexPath.row)
            defaults.set(favoriteslist, forKey: "favorites")
            defaults.synchronize()
        }
        else {
            let obj = favoriteskeys[sourceIndexPath.row]
            favoriteskeys.remove(at: sourceIndexPath.row)
            favoriteskeys.insert(obj, at: destinationIndexPath.row)
            defaults.set(favoriteskeys, forKey: "favoritesKey")
            defaults.synchronize()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "djDetail2" {
            let segued:InfoDetail = segue.destination as! InfoDetail
            let path = self.tableView.indexPathForSelectedRow
            let djURL = favoriteslist[(path?.row)!]
            segued.URL1 = djURL as! String
        }
        else if segue.identifier == "favoritesSearch" {
            let segued:SearchView = segue.destination as! SearchView
            let path = self.tableView.indexPathForSelectedRow
            let types = favoriteskeys[(path?.row)!] as! String
            segued.type = types.components(separatedBy: ":")[0]
            segued.tag = types.components(separatedBy: ":")[1]
            segued.numbered = false
        }
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        else {
            return proposedDestinationIndexPath
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let cellPosition = self.tableView.convert(location, to: self.view)
        let path = self.tableView.indexPathForRow(at: cellPosition)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if path?.row != nil {
            if path?.section == 0 {
                let segued:InfoDetail = storyboard.instantiateViewController(withIdentifier: "io.github.mario-kang.HClient.infodetail") as! InfoDetail
                let djURL = favoriteslist[(path?.row)!]
                segued.URL1 = djURL as! String
                return segued
            }
            else {
                let segued:SearchView = storyboard.instantiateViewController(withIdentifier: "io.github.mario-kang.HClient.searchview") as! SearchView
                let types = favoriteskeys[(path?.row)!] as! String
                segued.type = types.components(separatedBy: ":")[0]
                segued.tag = types.components(separatedBy: ":")[1]
                segued.numbered = false
                return segued
            }
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.show(viewControllerToCommit, sender: nil)
    }
}
