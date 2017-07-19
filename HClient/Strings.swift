//
//  String.swift
//  HClient
//
//  Created by 강희찬 on 2017. 7. 17..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

import UIKit

public class Strings: NSObject {
    
    static func replacingOccurrences(_ str:String!) -> String {
        var str1 = str
        str1 = str1!.replacingOccurrences(of: "\"acg", with: "\"dj")
        str1 = str1!.replacingOccurrences(of: "\"acg", with: "\"dj")
        str1 = str1!.replacingOccurrences(of: "\"acg", with: "\"dj")
        return str1!
    }
    
    static func decode(_ str:String!) -> String {
        var str1 = str
        str1 = str1!.replacingOccurrences(of: "&amp;", with: "&")
        str1 = str1!.replacingOccurrences(of: "&quot;", with: "\"")
        str1 = str1!.replacingOccurrences(of: "&#39;", with: "'")
        str1 = str1!.replacingOccurrences(of: "&gt;", with: ">")
        str1 = str1!.replacingOccurrences(of: "&lt;", with: "<")
        return str1!
    }
    
}
