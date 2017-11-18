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
    var favoriteslist:[Any] = []
    var favoriteslistData:[[String:String]] = [[:]]
    var favoritesPics:[Data] = []
    var favoriteskeys:[Any] = []
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
        favoriteslistData.removeAll()
        favoritesPics.removeAll()
        if favoriteslist.count != 0 {
            let fileManage = FileManager()
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentPath = dirPath[0]
            fileManage.changeCurrentDirectoryPath(documentPath)
            for a in 0...self.favoriteslist.count-1 {
                let number = (favoriteslist[a] as! String).components(separatedBy: "/galleries/")[1].components(separatedBy: ".html")[0]
                let txt = fileManage.contents(atPath: "\(number).txt")
                let txtString = String(data: txt!, encoding: .utf8)?.components(separatedBy: "\n")
                let title = txtString![0]
                var artist = txtString![1]
                var series = txtString![5]
                var language = txtString![4]
                var tags = txtString![6]
                artist = NSLocalizedString("Artist: ", comment: "") + artist
                series = NSLocalizedString("Series: ", comment: "") + series
                language = NSLocalizedString("Language: ", comment: "") + language
                tags = NSLocalizedString("Tags: ", comment: "") + tags
                let datas = ["title":title, "artist":artist, "series":series, "language":language, "tags":tags]
                favoriteslistData.append(datas)
                let picData = fileManage.contents(atPath: "\(number).jpg")
                favoritesPics.append(picData!)
            }
        }
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        activityController = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        activityController?.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
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
            let a = favoriteslistData[indexPath.row]
            cell.DJTitle.text = a["title"]
            cell.DJArtist.text = a["artist"]
            cell.DJSeries.text = a["series"]
            cell.DJLang.text = a["language"]
            cell.DJTag.text = a["tags"]
            let image = UIImage(data: favoritesPics[indexPath.row])
            cell.DJImage.image = image
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
                let fileManage = FileManager()
                let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let documentPath = dirPath[0]
                fileManage.changeCurrentDirectoryPath(documentPath)
                let number = (favoriteslist[indexPath.row] as! String).components(separatedBy: "/galleries/")[1].components(separatedBy: ".html")[0]
                do {
                    try fileManage.removeItem(atPath: "\(number).txt")
                    try fileManage.removeItem(atPath: "\(number).jpg")
                }
                catch {
                    
                }
                do {
                    try fileManage.removeItem(atPath: number)
                }
                catch {
                    
                }
                favoriteslistData.remove(at: indexPath.row)
                favoritesPics.remove(at: indexPath.row)
                favoriteslist.remove(at: indexPath.row)
                favorites.set(favoriteslist, forKey: "favorites")
                favorites.synchronize()
                tableView.deleteRows(at: [indexPath], with: .fade)
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
            let data = favoriteslistData[sourceIndexPath.row]
            let pic = favoritesPics[sourceIndexPath.row]
            favoriteslist.remove(at: sourceIndexPath.row)
            favoriteslist.insert(url, at: destinationIndexPath.row)
            favoriteslistData.remove(at: sourceIndexPath.row)
            favoriteslistData.insert(data, at: destinationIndexPath.row)
            favoritesPics.remove(at: sourceIndexPath.row)
            favoritesPics.insert(pic, at: destinationIndexPath.row)
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
