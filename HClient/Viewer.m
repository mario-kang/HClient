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
                NSString *galleries = [[[list objectAtIndex:i+1]componentsSeparatedByString:@"</div>"]objectAtIndex:0];
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

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error Occured.",nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
}

- (IBAction)Action:(id)sender {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *open = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open in Safari",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *ViewerURL = [NSString stringWithFormat:@"https://hitomi.la%@",URL];
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:ViewerURL]];
            [self presentViewController:safari animated:YES completion:nil];
        }
        else
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ViewerURL]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:open];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:nil];
}

@end
