//
//  SearchView.m
//  HClient
//
//  Created by 강희찬 on 2017. 6. 11..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import "SearchView.h"

@interface SearchCell ()

@end

@implementation SearchCell

@synthesize DJTag;
@synthesize DJLang;
@synthesize DJImage;
@synthesize DJTitle;
@synthesize DJArtist;
@synthesize DJSeries;

@end

@interface SearchView ()

@end

@implementation SearchView

@synthesize activityController;
@synthesize tag;
@synthesize type;
@synthesize arr;
@synthesize arr2;
@synthesize arr3;
@synthesize celllist;
@synthesize pages;
@synthesize page;
@synthesize hitomiNumber;
@synthesize numbered;
@synthesize numberDic;
@synthesize previewingContext;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activityController = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    activityController.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    if (!numbered)
        (self.navigationItem).title = [String decodes:[NSString stringWithFormat:@"%@:%@",type,tag]];
    else {
        NSInteger numb = hitomiNumber.integerValue;
        (self.navigationItem).title = [NSString stringWithFormat:NSLocalizedString(@"Hitomi number %ld", *),(long)numb];
    }
    pages = NO;
    arr = [[NSMutableArray alloc]init];
    arr2 = [[NSMutableArray alloc]init];
    arr3 = [[NSMutableArray alloc]init];
    celllist = [[NSMutableArray alloc]init];
    numberDic = [[NSMutableDictionary alloc]init];
    (self.tableView).rowHeight = UITableViewAutomaticDimension;
    (self.tableView).estimatedRowHeight = 154.0f;
    bool isForceTouchAvailable = false;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)])
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    if (isForceTouchAvailable) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    page = 1;
    if (!numbered)
        [self downloadTask:page];
    else
        [self downloadNumber];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (arr2 == nil)
        return 0;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arr2 == nil || [arr2 isEqual:@{}])
        return 0;
    else
        return arr2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
    if (!numbered) {
        NSString *list = arr[indexPath.row];
        NSArray *ar = [list componentsSeparatedByString:@"</a></h1>"];
        NSString *title = [ar[0]componentsSeparatedByString:@".html\">"][2];
        NSArray *etc = [ar[1]componentsSeparatedByString:@"</div>"];
        NSString *artlist = [etc[0]componentsSeparatedByString:@"list\">"][1];
        NSMutableString *artist = [[NSMutableString alloc]init];
        if ([artlist containsString:@"N/A"])
            [artist appendString:@"N/A"];
        else {
            NSArray *a = [artlist componentsSeparatedByString:@"</a></li>"];
            NSInteger b = a.count - 2;
            for (NSInteger i = 0; i <= b; i++) {
                [artist appendString:[a[i]componentsSeparatedByString:@".html\">"][1]];
                if (i != b)
                    [artist appendString:@", "];
            }
        }
        NSArray *etc1 = [etc[1]componentsSeparatedByString:@"</td>"];
        NSMutableString *series = [[NSMutableString alloc]initWithString:NSLocalizedString(@"Series: ",nil)];
        if ([etc1[1] containsString:@"N/A"])
            [series appendString:@"N/A"];
        else {
            NSArray *a = [etc1[1] componentsSeparatedByString:@"</a></li>"];
            NSInteger b = a.count - 2;
            for (NSInteger i = 0; i <= b; i++) {
                [series appendString:[a[i]componentsSeparatedByString:@".html\">"][1]];
                if (i != b)
                    [series appendString:@", "];
            }
        }
        NSMutableString *language = [[NSMutableString alloc]initWithString:NSLocalizedString(@"Language: ",nil)];
        if ([etc1[5] containsString:@"N/A"])
            [language appendString:@"N/A"];
        else
            [language appendString:[[etc1[5]componentsSeparatedByString:@".html\">"][1]componentsSeparatedByString:@"</a>"][0]];
        NSMutableString *tag1 = [[NSMutableString alloc]initWithString:NSLocalizedString(@"Tags: ",nil)];
        NSArray *taga = [etc1[7]componentsSeparatedByString:@"</a></li>"];
        NSInteger tagb = taga.count;
        if (tagb == 1)
            [tag1 appendString:@"N/A"];
        else
            for (NSInteger i = 0; i <= tagb - 2; i++) {
                [tag1 appendString:[taga[i]componentsSeparatedByString:@".html\">"][1]];
                if (i != tagb - 2)
                    [tag1 appendString:@", "];
            }
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:arr2[indexPath.row]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
        if (![arr3[indexPath.row]isEqual:[NSNull null]])
            (cell.DJImage).image = arr3[indexPath.row];
        else
            [cell.DJImage setImage:nil];
        if (![celllist containsObject:[NSString stringWithFormat:@"%lu",(unsigned long)indexPath.row]]) {
            NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data2, NSURLResponse * _Nullable response2, NSError * _Nullable error2) {
                if (error2 == nil) {
                    UIImage *image = [UIImage imageWithData:data2];
                    arr3[indexPath.row] = image;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SearchCell *update = (id)[tableView cellForRowAtIndexPath:indexPath];
                        (update.DJImage).image = image;
                    });
                }
            }];
            [sessionTask resume];
        }
        (cell.DJImage).contentMode = UIViewContentModeScaleAspectFit;
        (cell.DJTitle).text = [String decode:[NSMutableString stringWithString:title]];
        (cell.DJArtist).text = [String decode:artist];
        (cell.DJSeries).text = [String decode:series];
        (cell.DJLang).text = [String decode:language];
        (cell.DJTag).text = [String decode:tag1];
        return cell;
    }
    else {
        (cell.DJImage).contentMode = UIViewContentModeScaleAspectFit;
        (cell.DJTitle).text = [String decode:numberDic[@"title"]];
        (cell.DJArtist).text = [String decode:numberDic[@"artist"]];
        (cell.DJSeries).text = [String decode:numberDic[@"series"]];
        (cell.DJLang).text = [String decode:numberDic[@"language"]];
        (cell.DJTag).text = [String decode:numberDic[@"tag"]];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:arr2[indexPath.row]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
        if (![arr3[indexPath.row]isEqual:[NSNull null]])
            (cell.DJImage).image = arr3[indexPath.row];
        else
            [cell.DJImage setImage:nil];
        if (![celllist containsObject:[NSString stringWithFormat:@"%lu",(unsigned long)indexPath.row]]) {
            NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data2, NSURLResponse * _Nullable response2, NSError * _Nullable error2) {
                if (error2 == nil) {
                    UIImage *image = [UIImage imageWithData:data2];
                    arr3[indexPath.row] = image;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SearchCell *update = (id)[tableView cellForRowAtIndexPath:indexPath];
                        (update.DJImage).image = image;
                    });
                }
            }];
            [sessionTask resume];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row + 1 == arr2.count && !pages && !numbered) {
        page++;
        [self downloadTask:page];
        pages = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *djURL;
    InfoDetail *segued = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"djDetail3"] && !numbered) {
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        NSString *title = [[arr[path.row]componentsSeparatedByString:@".html\">"][0] componentsSeparatedByString:@"<a href=\""][1];
        djURL = [NSString stringWithFormat:@"https://hitomi.la%@.html",title];
        
    }
    else if ([segue.identifier isEqualToString:@"djDetail3"] && numbered) {
        NSInteger numb = hitomiNumber.integerValue;
        djURL = [NSString stringWithFormat:@"https://hitomi.la/galleries/%ld.html",(long)numb];
        segued.URL = djURL;
    }
    segued.URL = djURL;
}

- (void)downloadTask:(NSUInteger)ind {
    UIView *overlay = [[UIView alloc]initWithFrame:self.splitViewController.view.frame];
    activityController.center = self.splitViewController.view.center;
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0.8f;
    [self.splitViewController.view addSubview:overlay];
    [overlay addSubview:activityController];
    activityController.hidden = NO;
    [activityController startAnimating];
    NSMutableString *taga = [NSMutableString stringWithString:tag];
    [taga replaceOccurrencesOfString:@" " withString:@"%20" options:(NSStringCompareOptions)nil range:NSMakeRange(0, taga.length)];
    NSURL *url;
    if ([type isEqualToString:@"male"] || [type isEqualToString:@"female"])
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/tag/%@:%@-all-%lu.html",type,taga,(unsigned long)ind]];
    else if ([type isEqualToString:@"language"])
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/index-%@-%lu.html",taga,(unsigned long)ind]];
    else
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/%@/%@-all-%lu.html",type,taga,(unsigned long)ind]];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSession *session1 = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    NSURLSessionTask *task1 = [session1 dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && ((NSHTTPURLResponse *)response).statusCode == 200) {
            NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            str = [String replacingOccurrences:str];
            NSArray *temp = [str componentsSeparatedByString:@"<div class=\"dj\">"];
            for (NSInteger i = 1; i < temp.count; i++) {
                NSString *list = temp[i];
                NSString *img = [list componentsSeparatedByString:@"\"> </div>"][0];
                NSString *imga = [img componentsSeparatedByString:@"<img src=\""][1];
                NSString *urlString = [NSString stringWithFormat:@"https:%@",imga];
                [arr addObject:temp[i]];
                [arr2 addObject:urlString];
                [arr3 addObject:[NSNull null]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                activityController.hidden = YES;
                [activityController stopAnimating];
                [overlay removeFromSuperview];
                pages = NO;
            });
        }
        else if (error == nil && ((NSHTTPURLResponse *)response).statusCode != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                activityController.hidden = YES;
                [activityController stopAnimating];
                [overlay removeFromSuperview];
                pages = YES;
            });
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
    [self.tableView reloadData];
}

- (void)downloadNumber {
    UIView *overlay = [[UIView alloc]initWithFrame:self.splitViewController.view.frame];
    activityController.center = self.splitViewController.view.center;
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0.8f;
    [self.splitViewController.view addSubview:overlay];
    [overlay addSubview:activityController];
    activityController.hidden = NO;
    [activityController startAnimating];
    NSInteger numb = hitomiNumber.integerValue;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/galleries/%ld.html",(long)numb]];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSession *session1 = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    NSURLSessionTask *task1 = [session1 dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && ((NSHTTPURLResponse *)response).statusCode == 200) {
            NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *anime = [[str componentsSeparatedByString:@"<td>Type</td><td>"][1]componentsSeparatedByString:@"</a></td>"][0];
            if ([anime containsString:@"anime"]) {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"This number is Anime.",nil) message:NSLocalizedString(@"HClient does not support Anime.",nil) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                    activityController.hidden = YES;
                    [activityController stopAnimating];
                    [overlay removeFromSuperview];
                }];
            }
            else {
                NSString *title1 = [str componentsSeparatedByString:@"</a></h1>"][0];
                NSString *title2 = [[title1 componentsSeparatedByString:@"<h1>"][3]componentsSeparatedByString:@".html\">"][1];
                NSString *artist1 = [[str componentsSeparatedByString:@"</h2>"][0]componentsSeparatedByString:@"<h2>"][1];
                NSMutableString *artist = [NSMutableString stringWithString:NSLocalizedString(@"Artist: ",nil)];
                NSArray *artistlist = [artist1 componentsSeparatedByString:@"</a></li>"];
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
                NSString *pic = [[str componentsSeparatedByString:@".html\"><img src=\""][1]componentsSeparatedByString:@"\"></a></div>"][0];
                NSString *picurl = [NSString stringWithFormat:@"https:%@", pic];
                numberDic[@"title"] = [String decodes:title2];
                numberDic[@"artist"] = artist;
                numberDic[@"language"] = language;
                numberDic[@"series"] = series;
                numberDic[@"tag"] = tags;
                [arr2 addObject:picurl];
                [arr3 addObject:[NSNull null]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    activityController.hidden = YES;
                    [activityController stopAnimating];
                    [overlay removeFromSuperview];
                    pages = YES;
                });
            }
        }
        else if (error == nil && ((NSHTTPURLResponse *)response).statusCode != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                activityController.hidden = YES;
                [activityController stopAnimating];
                [overlay removeFromSuperview];
                pages = YES;
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Could not find number %ld.",nil),(long)numb] message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                    activityController.hidden = YES;
                    [activityController stopAnimating];
                    [overlay removeFromSuperview];
                }];
            });
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
    [self.tableView reloadData];
}

- (IBAction)Action:(id)sender {
    NSURL *url;
    if (!numbered) {
        NSMutableString *taga = [NSMutableString stringWithString:tag];
        [taga replaceOccurrencesOfString:@" " withString:@"%20" options:(NSStringCompareOptions)nil range:NSMakeRange(0, taga.length)];
        if ([type isEqualToString:@"male"] || [type isEqualToString:@"female"])
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/tag/%@:%@-all-1.html",type,taga]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/%@/%@-all-1.html",type,taga]];
    }
    else {
        NSInteger numb = hitomiNumber.integerValue;
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/galleries/%ld.html",(long)numb]];
    }
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *activity = [UIAlertAction actionWithTitle:NSLocalizedString(@"Share URL", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
        activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
        [self presentViewController:activityController animated:YES completion:nil];
    }];
    UIAlertAction *open = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open in Safari",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:url];
        if (@available(iOS 10.0, *))
            safari.preferredBarTintColor = [UIColor colorWithHue:235.0f/360.0f saturation:0.77f brightness:0.47f alpha:1.0f];
        [self presentViewController:safari animated:YES completion:nil];
    }];
    NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoriteslist = [NSMutableArray arrayWithArray:[favorites arrayForKey:@"favoritesKey"]];
    UIAlertAction *bookmark;
    if (![favoriteslist containsObject:[NSString stringWithFormat:@"%@:%@",type,tag]])
        bookmark = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add to favorites",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [favoriteslist addObject:[NSString stringWithFormat:@"%@:%@",type,tag]];
            [favorites setObject:favoriteslist forKey:@"favoritesKey"];
            [favorites synchronize];
        }];
    else
        bookmark = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remove from favorites",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [favoriteslist removeObject:[NSString stringWithFormat:@"%@:%@",type,tag]];
            [favorites setObject:favoriteslist forKey:@"favoritesKey"];
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

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    CGPoint cellPosition = [self.tableView convertPoint:location toView:self.view];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPosition];
    NSString *djURL;
    if (path) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InfoDetail *segued = [storyboard instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.infodetail"];
        if (!numbered) {
            NSString *title1 = arr[path.row];
            NSString *title2 = [title1 componentsSeparatedByString:@".html\">"][0];
            NSString *title3 = [title2 componentsSeparatedByString:@"<a href=\""][1];
            djURL = [NSString stringWithFormat:@"https://hitomi.la%@.html",title3];
        }
        else {
            NSInteger numb = hitomiNumber.integerValue;
            djURL = [NSString stringWithFormat:@"https://hitomi.la/galleries/%ld.html",(long)numb];
        }
        segued.URL = djURL;
        return segued;
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    NSURL *url;
    if (!numbered) {
        NSMutableString *taga = [NSMutableString stringWithString:tag];
        [taga replaceOccurrencesOfString:@" " withString:@"%20" options:(NSStringCompareOptions)nil range:NSMakeRange(0, taga.length)];
        if ([type isEqualToString:@"male"] || [type isEqualToString:@"female"])
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/tag/%@:%@-all-1.html",type,taga]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/%@/%@-all-1.html",type,taga]];
    }
    else {
        NSInteger numb = hitomiNumber.integerValue;
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/galleries/%ld.html",(long)numb]];
    }
    UIPreviewAction *share = [UIPreviewAction actionWithTitle:NSLocalizedString(@"Share URL", nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
        activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:activityController animated:YES completion:nil];
    }];
    UIPreviewAction *open = [UIPreviewAction actionWithTitle:NSLocalizedString(@"Open in Safari",nil) style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:url];
        if (@available(iOS 10.0, *))
            safari.preferredBarTintColor = [UIColor colorWithHue:235.0f/360.0f saturation:0.77f brightness:0.47f alpha:1.0f];
        [UIApplication.sharedApplication.delegate.window.rootViewController presentViewController:safari animated:YES completion:nil];
    }];
    return @[share,open];
}

@end
