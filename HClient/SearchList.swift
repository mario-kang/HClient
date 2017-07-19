//
//  SearchList.swift
//  HClient
//
//  Created by 강희찬 on 2017. 7. 18..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

import UIKit

class SearchList: UITableViewController, UISearchBarDelegate,UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var Search: UISearchBar!
    var allList:[[String:String]] = []
    var allList2:[[String:String]] = []
    var activityController:UIActivityIndicatorView!
    var searchWord = ""
    var previewingContext:Any!
    var tags = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            self.previewingContext = self.registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: self.view)
        }
        var overlay:UIView
        if self.splitViewController != nil {
            activityController?.center = (self.splitViewController?.view.center)!
            overlay = UIView(frame: (self.splitViewController?.view.frame)!)
            overlay.backgroundColor = UIColor.black
            overlay.autoresizingMask = self.tableView.autoresizingMask
            overlay.alpha = 0.8
            self.splitViewController?.view.addSubview(overlay)
        }
        else {
            activityController?.center = self.view.center
            overlay = UIView(frame: self.view.frame)
            overlay.backgroundColor = UIColor.black
            overlay.autoresizingMask = self.tableView.autoresizingMask
            overlay.alpha = 0.8
            self.view.addSubview(overlay)
        }
        activityController = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        activityController.center = overlay.center
        activityController.activityIndicatorViewStyle = .whiteLarge
        overlay.addSubview(activityController)
        activityController.isHidden = false
        activityController.startAnimating()
        let urlString = "https://ltn.hitomi.la/tags.json"
        Search.delegate = self
        Search.isUserInteractionEnabled = false
        let url = URL(string: urlString)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        let session = URLSession.shared
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let sessionTask = session.dataTask(with: request) { (data1, _, error1) in
            if error1 == nil {
                do {
                    var JSONList = try JSONSerialization.jsonObject(with: data1!, options: []) as? [String:AnyObject]
                    self.addAll("tag", list: JSONList!)
                    self.addAll("artist", list: JSONList!)
                    self.addAll("male", list: JSONList!)
                    self.addAll("female", list: JSONList!)
                    self.addAll("series", list: JSONList!)
                    self.addAll("group", list: JSONList!)
                    self.addAll("character", list: JSONList!)
                    self.addAll("language", list: JSONList!)
                    let sortDescriptor = NSSortDescriptor(key: "count", ascending: false)
                    let sortDescriptor2 = NSSortDescriptor(key: "name", ascending: true)
                    self.allList = (self.allList as! NSMutableArray).sortedArray(using: [sortDescriptor,sortDescriptor2]) as! [[String:String]]
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.Search.isUserInteractionEnabled = true
                        self.activityController.isHidden = true
                        self.activityController.stopAnimating()
                        overlay.removeFromSuperview()
                        JSONList = nil
                    }
                }
                catch {
                }
            }
            else {
                OperationQueue.main.addOperation {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let alert = UIAlertController(title: NSLocalizedString("Error Occured.", comment: ""), message: error1?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    self.activityController.isHidden = true
                    self.activityController.stopAnimating()
                    overlay.removeFromSuperview()
                }
            }
        }
        sessionTask.resume()
    }
    
    func addAll(_ type:String, list:[String:AnyObject]) {
        var name = ""
        var count:Int
        var dic:[String:String] = [:]
        var b = list[type] as? [AnyObject]
        for a in b! {
            name = a["s"]! as! String
            count = a["t"]! as! Int
            dic["name"] = name
            dic["count"] = String(format: "%06d", count)
            dic["type"] = type
            allList.append(dic)
        }
        b = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate:NSPredicate
        searchWord = searchText
        if searchText.lowercased().hasPrefix("tag:") {
            if !(searchText.lowercased() == "tag:") {
                let index = searchText.index(searchText.startIndex, offsetBy: 4)
                predicate = NSPredicate(format: "name CONTAINS %@ AND type LIKE 'tag'", searchText.lowercased().substring(from: index))
                allList2 = allList.filter {a in predicate.evaluate(with: a)}
            }
        }
        else if searchText.lowercased().hasPrefix("artist:") {
            if !(searchText.lowercased() == "artist:") {
                let index = searchText.index(searchText.startIndex, offsetBy: 7)
                predicate = NSPredicate(format: "name CONTAINS %@ AND type LIKE 'artist'", searchText.lowercased().substring(from: index))
                allList2 = allList.filter {a in predicate.evaluate(with: a)}
            }
        }
        else if searchText.lowercased().hasPrefix("male:") {
            if !(searchText.lowercased() == "male:") {
                let index = searchText.index(searchText.startIndex, offsetBy: 5)
                predicate = NSPredicate(format: "name CONTAINS %@ AND type LIKE 'male'", searchText.lowercased().substring(from: index))
                allList2 = allList.filter {a in predicate.evaluate(with: a)}
            }
        }
        else if searchText.lowercased().hasPrefix("female:") {
            if !(searchText.lowercased() == "female:") {
                let index = searchText.index(searchText.startIndex, offsetBy: 7)
                predicate = NSPredicate(format: "name CONTAINS %@ AND type LIKE 'female'", searchText.lowercased().substring(from: index))
                allList2 = allList.filter {a in predicate.evaluate(with: a)}
            }
        }
        else if searchText.lowercased().hasPrefix("series:") {
            if !(searchText.lowercased() == "series:") {
                let index = searchText.index(searchText.startIndex, offsetBy: 7)
                predicate = NSPredicate(format: "name CONTAINS %@ AND type LIKE 'series'", searchText.lowercased().substring(from: index))
                allList2 = allList.filter {a in predicate.evaluate(with: a)}
            }
        }
        else if searchText.lowercased().hasPrefix("group:") {
            if !(searchText.lowercased() == "group:") {
                let index = searchText.index(searchText.startIndex, offsetBy: 6)
                predicate = NSPredicate(format: "name CONTAINS %@ AND type LIKE 'group'", searchText.lowercased().substring(from: index))
                allList2 = allList.filter {a in predicate.evaluate(with: a)}
            }
        }
        else if searchText.lowercased().hasPrefix("character:") {
            if !(searchText.lowercased() == "character:") {
                let index = searchText.index(searchText.startIndex, offsetBy: 10)
                predicate = NSPredicate(format: "name CONTAINS %@ AND type LIKE 'character'", searchText.lowercased().substring(from: index))
                allList2 = allList.filter {a in predicate.evaluate(with: a)}
            }
        }
        else if searchText.lowercased().hasPrefix("language:") {
            if !(searchText.lowercased() == "langauage:") {
                let index = searchText.index(searchText.startIndex, offsetBy: 10)
                predicate = NSPredicate(format: "name CONTAINS %@ AND type LIKE 'language'", searchText.lowercased().substring(from: index))
                allList2 = allList.filter {a in predicate.evaluate(with: a)}
            }
        }
        else {
            predicate = NSPredicate(format: "name CONTAINS %@", searchText.lowercased())
            allList2 = allList.filter {a in predicate.evaluate(with: a)}
        }
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("Hitomi Tags", comment: "")
        }
        else {
            return NSLocalizedString("Hitomi Number", comment: "")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return allList2.count
        }
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath)
            cell.textLabel?.text = allList2[indexPath.row]["name"]
            let a = String(format: NSLocalizedString("%@, %ld item(s)",comment:""), allList2[indexPath.row]["type"]!,Int(allList2[indexPath.row]["count"]!)!)
            cell.detailTextLabel?.text = a
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "number", for: indexPath)
            if let hitomiNumber = Int(searchWord) {
                cell.textLabel?.text = String(format: NSLocalizedString("Find Hitomi number %ld", comment: ""), hitomiNumber)
            }
            else {
                cell.textLabel?.text = String(format: NSLocalizedString("Find Hitomi number %ld", comment: ""), 0)
            }
            return cell
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segued:SearchView = segue.destination as! SearchView
        if segue.identifier == "search" {
            let indexPath = self.tableView.indexPathForSelectedRow
            segued.tag = allList2[(indexPath?.row)!]["name"]!
            segued.type = allList2[(indexPath?.row)!]["type"]!
            segued.numbered = false
        }
        else {
            segued.hitomiNumber = searchWord
            segued.numbered = true
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let cellPosition = self.tableView.convert(location, to: self.view)
        let path = self.tableView.indexPathForRow(at: cellPosition)
        if path != nil {
            let cell = self.tableView.cellForRow(at: path!)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let segued:SearchView = storyBoard.instantiateViewController(withIdentifier: "io.github.mario-kang.HClient.searchview") as! SearchView
            if cell?.reuseIdentifier == "list" {
                segued.tag = allList2[(path?.row)!]["name"]!
                segued.type = allList2[(path?.row)!]["type"]!
                segued.numbered = false
            }
            else {
                segued.hitomiNumber = searchWord
                segued.numbered = true
            }
            return segued
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.show(viewControllerToCommit, sender: nil)
    }

}
