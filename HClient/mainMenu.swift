//
//  mainMenu.swift
//  HClient
//
//  Created by 강희찬 on 2017. 7. 18..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

import UIKit
import SafariServices

class MainmenuCell: UITableViewCell {
    @IBOutlet weak var DJImage: UIImageView!
    @IBOutlet weak var DJSeries: UILabel!
    @IBOutlet weak var DJTitle: UILabel!
    @IBOutlet weak var DJLang: UILabel!
    @IBOutlet weak var DJTag: UILabel!
    @IBOutlet weak var DJArtist: UILabel!
}

class mainMenu: UITableViewController, UIViewControllerPreviewingDelegate {
    
    var activityController:UIActivityIndicatorView!
    var arr:[Any] = []
    var arr2:[Any] = []
    var arr3:[Any] = []
    var celllist:[String] = []
    var pages = false
    var page:UInt = 0
    var previewingContext:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityController = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        activityController?.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        activityController.activityIndicatorViewStyle = .whiteLarge
        pages = false
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 154.0
        if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            self.previewingContext = self.registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: self.view)
        }
        page = 1
        downloadTask(page)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainmenuCell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as! MainmenuCell
        let list:String = arr[indexPath.row] as! String
        let ar = list.components(separatedBy: "</a></h1>")
        let title = ar[0].components(separatedBy: ".html\">")[2]
        let etc = ar[1].components(separatedBy: "</div>")
        let artlist = etc[0].components(separatedBy: "list\">")[1]
        var artist = ""
        if artlist.contains("N/A") {
            artist.append("N/A")
        }
        else {
            let a = artlist.components(separatedBy: "</a></li>")
            let b = a.count-2
            for i in 0...b {
                artist.append(a[i].components(separatedBy: ".html\">")[1])
                if i != b {
                    artist.append(", ")
                }
            }
        }
        let etc1 = etc[1].components(separatedBy: "</td>")
        var series = NSLocalizedString("Series: ", comment: "")
        if etc1[1].contains("N/A") {
            series.append("N/A")
        }
        else {
            let a = etc1[1].components(separatedBy: "</a></li>")
            let b = a.count-2
            for i in 0...b {
                series.append(a[i].components(separatedBy: ".html\">")[1])
                if i != b {
                    series.append(", ")
                }
            }
        }
        var language = NSLocalizedString("Language: ", comment: "")
        if etc1[5].contains("N/A") {
            language.append("N/A")
        }
        else {
            language.append(etc1[5].components(separatedBy: ".html\">")[1].components(separatedBy: "</a>")[0])
        }
        var tag1 = NSLocalizedString("Tags: ", comment: "")
        let taga = etc1[7].components(separatedBy: "</a></li>")
        let tagb = taga.count
        if tagb == 1 {
            tag1.append("N/A")
        }
        else {
            for i in 0...tagb-2 {
                tag1.append(taga[i].components(separatedBy: ".html\">")[1])
                if i != tagb-2 {
                    tag1.append(", ")
                }
            }
        }
        let session = URLSession.shared
        let request = URLRequest(url: URL(string:arr2[indexPath.row] as! String)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        if arr3[indexPath.row] is UIImage {
            cell.DJImage.image = arr3[indexPath.row] as? UIImage
        }
        else {
            cell.DJImage.image = nil
        }
        if !(celllist.contains(where: {$0 == "\(indexPath.row)"})) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
        }
        cell.DJImage.contentMode = .scaleAspectFit
        cell.DJTitle.text = Strings.decode(title)
        cell.DJArtist.text = Strings.decode(artist)
        cell.DJSeries.text = Strings.decode(series)
        cell.DJLang.text = Strings.decode(language)
        cell.DJTag.text = Strings.decode(tag1)
        if !(celllist.contains {$0 == "\(indexPath.row)"}) {
            celllist.append("\(indexPath.row)")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == arr2.count && !pages {
            page += 1
            downloadTask(page)
            pages = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segued:InfoDetail = segue.destination as! InfoDetail
        let path = self.tableView.indexPathForSelectedRow
        let title = (arr[(path?.row)!] as! String).components(separatedBy: ".html\">")[0].components(separatedBy: "<a href=\"")[1]
        let djURL = "https://hitomi.la\(title).html"
        segued.URL1 = djURL
    }
    
    func downloadTask(_ ind:UInt) {
        var overlay:UIView
        overlay = UIView(frame: (self.splitViewController?.view.frame)!)
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.8
        overlay.autoresizingMask = (self.splitViewController?.view.autoresizingMask)!
        activityController.center = (self.splitViewController?.view.center)!
        self.splitViewController?.view.addSubview(overlay)
        overlay.addSubview(activityController)
        activityController.isHidden = false
        activityController.startAnimating()
        let url = URL(string: "https://hitomi.la/index-all-\(ind).html")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession.shared
        let request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && (response as! HTTPURLResponse).statusCode == 200 {
                var str = String(data:data!, encoding:.utf8)
                str = Strings.replacingOccurrences(str)
                let temp = str?.components(separatedBy: "<div class=\"dj\">")
                for i in 1...(temp?.count)!-1 {
                    let list = temp?[i]
                    let img = list?.components(separatedBy: "\"> </div>")[0]
                    let imga = img?.components(separatedBy: "<img src=\"")[1]
                    let urlString = "https:\(imga!)"
                    self.arr.append(temp![i])
                    self.arr2.append(urlString)
                    self.arr3.append(NSNull())
                }
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                    self.activityController.isHidden = true
                    self.activityController.stopAnimating()
                    overlay.removeFromSuperview()
                    self.pages = false
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
        }
        task.resume()
        self.tableView.reloadData()
    }
    
    @IBAction func Action(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let activity = UIAlertAction(title: NSLocalizedString("Share URL", comment: ""), style: .default) { (_) in
            let url = URL(string: "https://hitomi.la/")
            let activitys = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            activitys.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activitys, animated: true, completion: nil)
        }
        let open = UIAlertAction(title: NSLocalizedString("Open in Safari", comment: ""), style: .default) { (_) in
            let url = URL(string: "https://hitomi.la/")
            let safari = SFSafariViewController(url: url!)
            if #available(iOS 10.0, *) {
                safari.preferredBarTintColor = UIColor(hue: 235.0/360.0, saturation: 0.77, brightness: 0.47, alpha: 1.0)
            }
            self.present(safari, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        sheet.addAction(activity)
        sheet.addAction(open)
        sheet.addAction(cancel)
        sheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        self.present(sheet, animated: true, completion: nil)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let cellPosition = self.tableView.convert(location, to: self.view)
        let path = self.tableView.indexPathForRow(at: cellPosition)
        if path != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let segued:InfoDetail = storyboard.instantiateViewController(withIdentifier: "io.github.mario-kang.HClient.infodetail") as! InfoDetail
            let title1 = arr[(path?.row)!]
            let title2 = (title1 as! String).components(separatedBy: ".html\">")[0]
            let title3 = title2.components(separatedBy: "<a href=\"")[1]
            let djURL = "https://hitomi.la\(title3).html"
            segued.URL1 = djURL
            return segued
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.show(viewControllerToCommit, sender: nil)
    }

}
