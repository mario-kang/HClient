//
//  Viewer.m
//  HClient
//
//  Created by 강희찬 on 2017. 6. 10..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import "Viewer.h"

@interface Viewer ()

@end

@implementation Viewer

@synthesize URL;
@synthesize web;

- (void)loadView {
    [super loadView];
    web = [[WKWebView alloc]init];
    self.view = web;
    web.navigationDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *ViewerURL = [NSString stringWithFormat:@"https://hitomi.la%@",URL];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSession *session1 = [NSURLSession sharedSession];
    NSURLSessionTask *task1 = [session1 dataTaskWithURL:[NSURL URLWithString:ViewerURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSMutableString *HTMLString = [NSMutableString stringWithString:@"<!DOCTYPE HTML><style>img{width:100%;}</style>"];
            NSArray *list = [str componentsSeparatedByString:@"<div class=\"img-url\">//g"];
            for (int i=0; i<list.count-1; i++) {
                NSString *galleries = [list[i+1]componentsSeparatedByString:@"</div>"][0];
                [HTMLString appendString:[NSString stringWithFormat:@"<img src=\"https://ba%@\" >",galleries]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [web loadHTMLString:HTMLString baseURL:nil];
                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            });
        }
        else {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error Occured.",nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
            }];
        }
    }];
    [task1 resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error Occured.",nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
}

- (IBAction)Action:(id)sender {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *ViewerURL = [NSString stringWithFormat:@"https://hitomi.la%@",URL];
    UIAlertAction *activity = [UIAlertAction actionWithTitle:NSLocalizedString(@"Share URL", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:ViewerURL];
        UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
        activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
        [self presentViewController:activityController animated:YES completion:nil];
    }];
    UIAlertAction *open = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open in Safari",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:ViewerURL]];
        if (@available(iOS 10.0, *))
            safari.preferredBarTintColor = [UIColor colorWithHue:235.0f/360.0f saturation:0.77f brightness:0.47f alpha:1.0f];
        [self presentViewController:safari animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:activity];
    [sheet addAction:open];
    [sheet addAction:cancel];
    sheet.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    [self presentViewController:sheet animated:YES completion:nil];
}

@end
