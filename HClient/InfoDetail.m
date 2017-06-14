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

@synthesize Image;
@synthesize Title;
@synthesize Artist;
@synthesize Series;
@synthesize Language;
@synthesize Tag;
@synthesize activityController;

@synthesize URL;
@synthesize ViewerURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    activityController = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [activityController setCenter:self.view.center];
    [activityController setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    UIView *overlay = [[UIView alloc]initWithFrame:[[self view]frame]];
    [overlay setBackgroundColor:[UIColor blackColor]];
    [overlay setAlpha:0.8f];
    [self.view addSubview:overlay];
    [overlay addSubview:activityController];
    activityController.hidden = NO;
    [activityController startAnimating];
    NSURL *url = [NSURL URLWithString:URL];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSession *session1 = [NSURLSession sharedSession];
    NSURLSessionTask *task1 = [session1 dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if (error == nil) {
             NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
             NSString *title1 = [[str componentsSeparatedByString:@"</a></h1>"]objectAtIndex:0];
             NSString *title2 = [[[[title1 componentsSeparatedByString:@"<h1>"]objectAtIndex:3]componentsSeparatedByString:@".html\">"]objectAtIndex:1];
             NSString *artist1 = [[[[str componentsSeparatedByString:@"</h2>"]objectAtIndex:0]componentsSeparatedByString:@"<h2>"]objectAtIndex:1];
             NSMutableString *artist = [NSMutableString stringWithString:NSLocalizedString(@"Artist: ",nil)];
             NSArray *artistlist = [artist1 componentsSeparatedByString:@"</a></li>"];
             ViewerURL = [[[[str componentsSeparatedByString:@"<div class=\"cover\"><a href=\""]objectAtIndex:1]componentsSeparatedByString:@"\"><img src="]objectAtIndex:0];
             if ([artist1 containsString:@"N/A"])
                 [artist appendString:@"N/A"];
             else
                 for (int i=0; i<artistlist.count-1; i++) {
                      [artist appendString:[String decodes:[[[artistlist objectAtIndex:i]componentsSeparatedByString:@".html\">"]objectAtIndex:1]]];
                     if (i != artistlist.count-2)
                         [artist appendString:@", "];
                 }
             NSMutableString *language = [NSMutableString stringWithString:NSLocalizedString(@"Language: ",nil)];
             NSString *lang = [[[[str componentsSeparatedByString:@"Language"]objectAtIndex:1]componentsSeparatedByString:@"</a></td>"]objectAtIndex:0];
             if ([lang containsString:@"N/A"])
                 [language appendString:@"N/A"];
             else
                 [language appendString:[String decodes:[[lang componentsSeparatedByString:@".html\">"]objectAtIndex:1]]];
             NSMutableString *series = [NSMutableString stringWithString:NSLocalizedString(@"Series: ",nil)];
             NSString *series1 = [[[[str componentsSeparatedByString:@"Series"]objectAtIndex:1]componentsSeparatedByString:@"</td>"]objectAtIndex:1];
             NSArray *series2 = [series1 componentsSeparatedByString:@"</a></li>"];
             if ([series1 containsString:@"N/A"])
                 [series appendString:@"N/A"];
             else
                 for (int i=0; i<series2.count-1; i++) {
                     [series appendString:[String decodes:[[[series2 objectAtIndex:i]componentsSeparatedByString:@".html\">"]objectAtIndex:1]]];
                     if (i != series2.count-2)
                         [series appendString:@", "];
                 }
             NSMutableString *tags = [NSMutableString stringWithString:NSLocalizedString(@"Tags: ",nil)];
             NSString *tags1 = [[[[str componentsSeparatedByString:@"Tags"]objectAtIndex:1]componentsSeparatedByString:@"</td>"]objectAtIndex:1];
             NSArray *tags2 = [tags1 componentsSeparatedByString:@"</a></li>"];
             if (tags2.count == 1)
                 [tags appendString:@"N/A"];
             else
                 for (int i=0; i<tags2.count-1; i++) {
                     [tags appendString:[String decodes:[[[tags2 objectAtIndex:i]componentsSeparatedByString:@".html\">"]objectAtIndex:1]]];
                     if (i != tags2.count-2)
                         [tags appendString:@", "];
                 }
             NSString *pic = [[[[str componentsSeparatedByString:@".html\"><img src=\""]objectAtIndex:1]componentsSeparatedByString:@"\"></a></div>"]objectAtIndex:0];
             NSString *picurl = [NSString stringWithFormat:@"https:%@", pic];
             NSURLSession *session = [NSURLSession sharedSession];
             NSURLSessionDataTask *sessionTask = [session dataTaskWithURL:[NSURL URLWithString:picurl] completionHandler:^(NSData * _Nullable data2, NSURLResponse * _Nullable response2, NSError * _Nullable error2) {
                 if (error2 == nil)
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.navigationItem setTitle:[String decodes:title2]];
                         [Image setContentMode:UIViewContentModeScaleAspectFit];
                         [Title setText:[String decodes:title2]];
                         [Artist setText:artist];
                         [Language setText:language];
                         [Series setText:series];
                         [Tag setText:tags];
                         [Image setImage:[UIImage imageWithData:data2]];
                         activityController.hidden = YES;
                         [activityController stopAnimating];
                         [overlay removeFromSuperview];
                     });
             }];
             [sessionTask resume];
             
        }
        else {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error Occured.",nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                activityController.hidden = YES;
                [activityController stopAnimating];
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
    UIAlertAction *open = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open in Safari",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:URL]];
            [self presentViewController:safari animated:YES completion:nil];
        }
        else
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URL]];
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
    [sheet addAction:open];
    [sheet addAction:bookmark];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Viewer"]) {
        Viewer *segued = [segue destinationViewController];
        segued.URL = ViewerURL;
    }
}

@end
