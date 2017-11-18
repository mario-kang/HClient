//
//  AppDelegate.swift
//  HClient
//
//  Created by 강희찬 on 2017. 7. 17..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

import UIKit
import WebKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let item1 = UIApplicationShortcutItem(type: "io.github.mario-kang.HClient.news", localizedTitle: NSLocalizedString("New", comment: ""), localizedSubtitle: nil, icon:UIApplicationShortcutIcon.init(templateImageName: "mainmenu"), userInfo: nil)
        let item2 = UIApplicationShortcutItem(type: "io.github.mario-kang.HClient.search", localizedTitle: NSLocalizedString("Search", comment: ""), localizedSubtitle: nil, icon:UIApplicationShortcutIcon.init(templateImageName: "search"), userInfo: nil)
        let item3 = UIApplicationShortcutItem(type: "io.github.mario-kang.HClient.favorites", localizedTitle: NSLocalizedString("Favorites", comment: ""), localizedSubtitle: nil, icon:UIApplicationShortcutIcon.init(templateImageName: "favorite"), userInfo: nil)
        UIApplication.shared.shortcutItems = [item1, item2, item3]
        let type = Set([WKWebsiteDataTypeDiskCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: type, modifiedSince: date) { }
        let defaults = UserDefaults.standard
        var isDownloading = defaults.bool(forKey: "isDownloading")
        if isDownloading {
            let fileManage = FileManager()
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = dirPath[0]
            var download = defaults.array(forKey: "favoritesDownload") as! [String]
            fileManage.changeCurrentDirectoryPath(path)
            let numbera = defaults.string(forKey: "downloadingURL")
            let number = numbera?.components(separatedBy: "/reader/")[1].components(separatedBy: ".html")[0]
            do {
                try fileManage.removeItem(atPath: number!)
                isDownloading = false
                if let index = download.index(of: "https://hitomi.la/galleries/\(number!).html") {
                    download.remove(at: index)
                    defaults.set(download, forKey: "favoritesDownload")
                }
                defaults.set(isDownloading, forKey: "isDownloading")
                defaults.set("", forKey: "downloadingURL")
                defaults.synchronize()
            }
            catch {
                
            }
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let type = Set([WKWebsiteDataTypeDiskCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: type, modifiedSince: date) { }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let s = st.instantiateViewController(withIdentifier: "io.github.mario-kang.HClient.split")
        var c:UINavigationController
        if shortcutItem.type == "io.github.mario-kang.HClient.news" {
            c = st.instantiateViewController(withIdentifier: "io.github.mario-kang.HClient.news") as! UINavigationController
        }
        else if shortcutItem.type == "io.github.mario-kang.HClient.search" {
            c = st.instantiateViewController(withIdentifier: "io.github.mario-kang.HClient.search") as! UINavigationController
        }
        else {
            c = st.instantiateViewController(withIdentifier: "io.github.mario-kang.HClient.favorites") as! UINavigationController
        }
        s.showDetailViewController(c, sender: nil)
        self.window?.rootViewController = s
        self.window?.makeKeyAndVisible()
    }
    
    
}
