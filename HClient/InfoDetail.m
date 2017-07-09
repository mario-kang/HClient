//
//  InfoDetail.m
//  HClient
//
//  Created by 강희찬 on 2017. 6. 10..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import "InfoDetail.h"

@interface InfoDetail ()

@end

@implementation InfoDetail

@synthesize actionIcon;
@synthesize bookmarkIcon;
@synthesize Image;
@synthesize Title;
@synthesize Artist;
@synthesize Series;
@synthesize Language;
@synthesize Tag;
@synthesize Group;
@synthesize Type;
@synthesize Date;
@synthesize Character;
@synthesize activityController;

@synthesize URL;
@synthesize ViewerURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    activityController = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    activityController.center = self.splitViewController.view.center;
    activityController.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    UIView *overlay = [[UIView alloc]initWithFrame:self.splitViewController.view.frame];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0.8f;
    [self.splitViewController.view addSubview:overlay];
    [overlay addSubview:activityController];
    activityController.hidden = NO;
    [activityController startAnimating];
    NSURL *url = [NSURL URLWithString:URL];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSession *session1 = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    NSURLSessionTask *task1 = [session1 dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && ((NSHTTPURLResponse *)response).statusCode == 200) {
            NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *title = [[[str componentsSeparatedByString:@"</a></h1>"][0] componentsSeparatedByString:@"<h1>"][3]componentsSeparatedByString:@".html\">"][1];
            NSString *artist1 = [[str componentsSeparatedByString:@"</h2>"][0]componentsSeparatedByString:@"<h2>"][1];
            NSMutableString *artist = [NSMutableString stringWithString:NSLocalizedString(@"Artist: ",nil)];
            NSArray *artistlist = [artist1 componentsSeparatedByString:@"</a></li>"];
            ViewerURL = [[str componentsSeparatedByString:@"<div class=\"cover\"><a href=\""][1]componentsSeparatedByString:@"\"><img src="][0];
            if ([artist1 containsString:@"N/A"])
                [artist appendString:@"N/A"];
            else
                for (int i=0; i<artistlist.count-1; i++) {
                    [artist appendString:[String decodes:[artistlist[i]componentsSeparatedByString:@".html\">"][1]]];
                    if (i != artistlist.count-2)
                        [artist appendString:@", "];
                }
            NSMutableString *language = [NSMutableString stringWithString:NSLocalizedString(@"Language: ",nil)];
            NSString *lang = [[str componentsSeparatedByString:@"Language"][1]componentsSeparatedByString:@"</a></td>"][0];
            if ([lang containsString:@"N/A"])
                [language appendString:@"N/A"];
            else
                [language appendString:[String decodes:[lang componentsSeparatedByString:@".html\">"][1]]];
            NSMutableString *type = [NSMutableString stringWithString:NSLocalizedString(@"Type: ",nil)];
            NSString *type1 = [[str componentsSeparatedByString:@"<td>Type"][1]componentsSeparatedByString:@"</a></td>"][0];
            if ([type1 containsString:@"N/A"])
                [type appendString:@"N/A"];
            else
                [type appendString:[String decodes:[[[[type1 componentsSeparatedByString:@".html\">"][1]stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"CG" withString:@" CG"]stringByReplacingOccurrencesOfString:@"\n" withString:@""]]];
            NSMutableString *series = [NSMutableString stringWithString:NSLocalizedString(@"Series: ",nil)];
            NSString *series1 = [[str componentsSeparatedByString:@"Series"][1]componentsSeparatedByString:@"</td>"][1];
            NSArray *series2 = [series1 componentsSeparatedByString:@"</a></li>"];
            if ([series1 containsString:@"N/A"])
                [series appendString:@"N/A"];
            else
                for (int i=0; i<series2.count-1; i++) {
                    [series appendString:[String decodes:[series2[i]componentsSeparatedByString:@".html\">"][1]]];
                    if (i != series2.count-2)
                        [series appendString:@", "];
                }
            NSMutableString *tags = [NSMutableString stringWithString:NSLocalizedString(@"Tags: ",nil)];
            NSString *tags1 = [[str componentsSeparatedByString:@"Tags"][1]componentsSeparatedByString:@"</td>"][1];
            NSArray *tags2 = [tags1 componentsSeparatedByString:@"</a></li>"];
            if (tags2.count == 1)
                [tags appendString:@"N/A"];
            else
                for (int i=0; i<tags2.count-1; i++) {
                    [tags appendString:[String decodes:[tags2[i]componentsSeparatedByString:@".html\">"][1]]];
                    if (i != tags2.count-2)
                        [tags appendString:@", "];
                }
            NSMutableString *characters = [NSMutableString stringWithString:NSLocalizedString(@"Character: ",nil)];
            NSString *characters1 = [[str componentsSeparatedByString:@"Characters"][1]componentsSeparatedByString:@"</td>"][1];
            NSArray *characters2 = [characters1 componentsSeparatedByString:@"</a></li>"];
            if (characters2.count == 1)
                [characters appendString:@"N/A"];
            else
                for (int i=0; i<characters2.count-1; i++) {
                    [characters appendString:[String decodes:[characters2[i]componentsSeparatedByString:@".html\">"][1]]];
                    if (i != characters2.count-2)
                        [characters appendString:@", "];
                }
            NSMutableString *groups = [NSMutableString stringWithString:NSLocalizedString(@"Groups: ",nil)];
            NSString *groups1 = [[str componentsSeparatedByString:@"<td>Group"][1]componentsSeparatedByString:@"</td>"][1];
            NSArray *groups2 = [groups1 componentsSeparatedByString:@"</a></li>"];
            if (groups2.count == 1)
                [groups appendString:@"N/A"];
            else
                for (int i=0; i<groups2.count-1; i++) {
                    [groups appendString:[String decodes:[groups2[i]componentsSeparatedByString:@".html\">"][1]]];
                    if (i != groups2.count-2)
                        [groups appendString:@", "];
                }
            NSMutableString *dates = [NSMutableString stringWithString:NSLocalizedString(@"Date: ",nil)];
            NSString *dates1 = [[str componentsSeparatedByString:@"\"date\">"][1]componentsSeparatedByString:@"</span>"][0];
            NSDateFormatter *format = [[NSDateFormatter alloc]init];
            format.dateFormat = @"yyyy-MM-dd HH:mm:ssZZ";
            NSDate *dates2 = [format dateFromString:dates1];
            NSDateFormatter *format1 = [[NSDateFormatter alloc]init];
            format1.dateStyle = NSDateFormatterMediumStyle;
            format1.timeStyle = NSDateFormatterMediumStyle;
            NSString *dates3 = [format1 stringFromDate:dates2];
            [dates appendString:dates3];
            NSString *pic = [[str componentsSeparatedByString:@".html\"><img src=\""][1]componentsSeparatedByString:@"\"></a></div>"][0];
            NSString *picurl = [NSString stringWithFormat:@"https:%@", pic];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:picurl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
            NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data2, NSURLResponse * _Nullable response2, NSError * _Nullable error2) {
                if (error2 == nil)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        (self.navigationItem).title = [String decodes:title];
                        Image.contentMode = UIViewContentModeScaleAspectFit;
                        Title.text = [String decodes:title];
                        Artist.text = artist;
                        Group.text = groups;
                        Type.text = type;
                        Language.text = language;
                        Series.text = series;
                        Tag.text = tags;
                        Character.text = characters;
                        Date.text = dates;
                        Image.image = [UIImage imageWithData:data2];
                        activityController.hidden = YES;
                        [activityController stopAnimating];
                        [overlay removeFromSuperview];
                    });
            }];
            [sessionTask resume];
            [actionIcon setEnabled:YES];
            [bookmarkIcon setEnabled:YES];
        }
        else {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                NSString *desc;
                if (error == nil)
                    desc = [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse*)response).statusCode];
                else
                    desc = error.localizedDescription;
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error Occured.",nil) message:desc preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                activityController.hidden = YES;
                [activityController stopAnimating];
                [actionIcon setEnabled:NO];
                [bookmarkIcon setEnabled:NO];
                [overlay removeFromSuperview];
            }];
        }
    }];
    [task1 resume];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}

- (IBAction)ActionMenu:(id)sender {
    NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoriteslist = [NSMutableArray arrayWithArray:[favorites arrayForKey:@"favorites"]];
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *activity = [UIAlertAction actionWithTitle:NSLocalizedString(@"Share URL", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:URL];
        UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
        activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
        [self presentViewController:activityController animated:YES completion:nil];
    }];
    UIAlertAction *open = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open in Safari",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:URL]];
        if (@available(iOS 10.0, *))
            safari.preferredBarTintColor = [UIColor colorWithHue:235.0f/360.0f saturation:0.77f brightness:0.47f alpha:1.0f];
        [self presentViewController:safari animated:YES completion:nil];
    }];
    UIAlertAction *bookmark;
    if (![favoriteslist containsObject:URL])
        bookmark = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add to favorites",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [favoriteslist addObject:URL];
            [favorites setObject:favoriteslist forKey:@"favorites"];
            [favorites synchronize];
        }];
    else
        bookmark = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remove from favorites",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [favoriteslist removeObject:URL];
            [favorites setObject:favoriteslist forKey:@"favorites"];
            [favorites synchronize];
        }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:activity];
    [sheet addAction:open];
    [sheet addAction:bookmark];
    [sheet addAction:cancel];
    sheet.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Viewer"]) {
        Viewer *segued = segue.destinationViewController;
        segued.URL = ViewerURL;
    }
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *share = [UIPreviewAction actionWithTitle:NSLocalizedString(@"Share URL", nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSURL *url = [NSURL URLWithString:URL];
        UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
        activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:activityController animated:YES completion:nil];
    }];
    UIPreviewAction *openSafari = [UIPreviewAction actionWithTitle:NSLocalizedString(@"Open in Safari",nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:URL]];
        if (@available(iOS 10.0, *))
            safari.preferredBarTintColor = [UIColor colorWithHue:235.0f/360.0f saturation:0.77f brightness:0.47f alpha:1.0f];
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:safari animated:YES completion:nil];
    }];
    UIPreviewAction *openViewer = [UIPreviewAction actionWithTitle:NSLocalizedString(@"Open in Viewer",nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Viewer *b = [storyBoard instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.viewer"];
        b.URL = ViewerURL;
        [UIApplication.sharedApplication.delegate.window.rootViewController showDetailViewController:b sender:nil];
    }];
    return @[share,openSafari,openViewer];
}

@end
