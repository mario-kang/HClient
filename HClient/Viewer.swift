//
//  Viewer.swift
//  HClient
//
//  Created by 강희찬 on 2017. 7. 17..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class Viewer: UIViewController, WKNavigationDelegate {
    
    var URL1 = ""
    var web:WKWebView!
    var progress:UIProgressView!
    
    override func loadView() {
        super.loadView()
        web = WKWebView()
        self.view = web
        web.navigationDelegate = self
        progress = UIProgressView(progressViewStyle: .bar)
        progress.translatesAutoresizingMaskIntoConstraints = false
        web.addSubview(progress)
        progress.leadingAnchor.constraint(equalTo: web.leadingAnchor).isActive = true
        progress.trailingAnchor.constraint(equalTo: web.trailingAnchor).isActive = true
        progress.bottomAnchor.constraint(equalTo: web.bottomAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.view.addSubview(progress)
        let viewerURL = "https://hitomi.la\(URL1)"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession.shared
        let task = session.dataTask(with: URL(string:viewerURL)!) { (data, _, error) in
            if error == nil {
                let str = String(data:data!, encoding:.utf8)
                var HTMLString = "<!DOCTYPE HTML><style>img{width:100%;}</style>"
                let list = str?.components(separatedBy: "<div class=\"img-url\">//")
                for i in 0...(list?.count)!-2 {
                    let galleries:String = (list?[i+1].components(separatedBy: "</div>")[0])!
                    let num = galleries.components(separatedBy: "/galleries/")[1].components(separatedBy: "/")[0]
                    let numb = galleries.components(separatedBy: "/")[3]
                    let a = String(UnicodeScalar(97 + Int(num)! % 2)!)
                    HTMLString.append("<img src=\"https://\(a)a.hitomi.la/galleries/\(num)/\(numb)\" >")
                }
                DispatchQueue.main.async {
                    self.web.loadHTMLString(HTMLString, baseURL: nil)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            else {
                OperationQueue.main.addOperation {
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
    
    deinit {
        web.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progress.setProgress(Float(web.estimatedProgress), animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        progress.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        progress.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let alert = UIAlertController(title: NSLocalizedString("Error Occured.", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        progress.isHidden = true
    }
    
    @IBAction func Action(_ sender: Any) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let ViewerURL = "https://hitomi.la\(URL1)"
        let activity = UIAlertAction(title: NSLocalizedString("Share URL", comment: ""), style: .default) { (_) in
            let url = URL(string: ViewerURL)
            let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
            activityController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activityController, animated: true, completion: nil)
        }
        let open = UIAlertAction(title: NSLocalizedString("Open in Safari", comment: ""), style: .default) { (_) in
            let safari = SFSafariViewController(url: URL(string: ViewerURL)!)
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
    
}
