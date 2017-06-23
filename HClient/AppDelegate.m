//
//  AppDelegate.m
//  HClient
//
//  Created by 강희찬 on 2017. 6. 10..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:@"io.github.mario-kang.HClient.news" localizedTitle:NSLocalizedString(@"New",nil) localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"mainmenu"] userInfo:nil];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:@"io.github.mario-kang.HClient.search" localizedTitle:NSLocalizedString(@"Search",nil) localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"search"] userInfo:nil];
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc]initWithType:@"io.github.mario-kang.HClient.favorites" localizedTitle:NSLocalizedString(@"Favorites",nil) localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"favorite"] userInfo:nil];
    [[UIApplication sharedApplication]setShortcutItems:@[item1,item2,item3]];
    return YES;
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    UIStoryboard *st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([shortcutItem.type isEqualToString:@"io.github.mario-kang.HClient.news"]) {
        UISplitViewController *s = [st instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.split"];
        UINavigationController *c = [st instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.news"];
        [s showDetailViewController:c sender:nil];
        [self.window setRootViewController:s];
        [self.window makeKeyAndVisible];
    }
    else if ([shortcutItem.type isEqualToString:@"io.github.mario-kang.HClient.search"]) {
        UISplitViewController *s = [st instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.split"];
        UINavigationController *c = [st instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.search"];
        [s showDetailViewController:c sender:nil];
        [self.window setRootViewController:s];
        [self.window makeKeyAndVisible];
    }
    else {
        UISplitViewController *s = [st instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.split"];
        UINavigationController *c = [st instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.favorites"];
        [s showDetailViewController:c sender:nil];
        [self.window setRootViewController:s];
        [self.window makeKeyAndVisible];
    }
}

@end
