//
//  Viewer.h
//  HClient
//
//  Created by 강희찬 on 2017. 6. 10..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Webkit/Webkit.h>
#import <SafariServices/SafariServices.h>

@interface Viewer : UIViewController <WKNavigationDelegate>

@property (strong) NSString *URL;
@property (strong) WKWebView *web;

@end
