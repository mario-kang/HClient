//
//  SearchList.swift
//  HClient
//
//  Created by 강희찬 on 2017. 7. 18..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

import UIKit

class SearchList: UITableViewController, UISearchBarDelegate,UIViewControllerPreviewingDelegate {
    
    struct List {
        let name:String
        let type:String
        let count:Int
        init(name:String,type:String,count:Int) {
            self.name = name
            self.type = type
            self.count = count
        }
    }
    
    @IBOutlet weak var Search: UISearchBar!
    var allList:[List] = []
    var allList2:[List] = []
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
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
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
                    self.allList.sort {(a,b) in
                        return a.count > b.count
                    }
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
        var b = list[type] as? [AnyObject]
        for a in b! {
            name = a["s"]! as! String
            count = a["t"]! as! Int
            allList.append(List(name: name, type: type, count: count))
        }
        b = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWord = searchText
        let regex = "([a-z])*:([a-z ])*"
        let predicateRegex = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicateRegex.evaluate(with: searchText.lowercased()) {
            let ind = searchText.lowercased().components(separatedBy: ":")
            if ind[1] != "" {
                allList2 = allList.filter {a in
                return a.name.contains(ind[1]) && a.type == ind[0]}
            }
        }
        else {
            allList2 = allList.filter {a in
            a.name.contains(searchText.lowercased())}
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
            cell.textLabel?.text = allList2[indexPath.row].name
            let a = String(format: NSLocalizedString("%@, %ld item(s)",comment:""), allList2[indexPath.row].type,allList2[indexPath.row].count)
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
            segued.tag = allList2[(indexPath?.row)!].name
            segued.type = allList2[(indexPath?.row)!].type
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
                segued.tag = allList2[(path?.row)!].name
                segued.type = allList2[(path?.row)!].type
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
