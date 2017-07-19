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
        let item2 = UIApplicationShortcutItem(type: "io.github.mario-kang.HClient.search", localizedTitle: NSLocalizedString("Search", comment: ""), localizedSubtitle: nil, icon:UIApplicationShortcutIcon.init(templateImageName: "Search"), userInfo: nil)
        let item3 = UIApplicationShortcutItem(type: "io.github.mario-kang.HClient.favorites", localizedTitle: NSLocalizedString("Favorites", comment: ""), localizedSubtitle: nil, icon:UIApplicationShortcutIcon.init(templateImageName: "favorite"), userInfo: nil)
        UIApplication.shared.shortcutItems = [item1, item2, item3]
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        let dataType = NSSet(array: [WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: dataType as! Set<String>, modifiedSince: date) { }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let dataType = NSSet(array: [WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: dataType as! Set<String>, modifiedSince: date) { }
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
