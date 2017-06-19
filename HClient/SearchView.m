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
@synthesize djURL;
@synthesize pages;
@synthesize page;
@synthesize hitomiNumber;
@synthesize numbered;
@synthesize numberDic;

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activityController = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [activityController setCenter:self.view.center];
    [activityController setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if (!numbered)
        [self.navigationItem setTitle:[String decodes:[NSString stringWithFormat:@"%@:%@",type,tag]]];
    else {
        NSInteger numb = [hitomiNumber integerValue];
        [self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(@"Hitomi number %ld", *),(long)numb]];
    }
    pages = NO;
    arr = [[NSMutableArray alloc]init];
    arr2 = [[NSMutableArray alloc]init];
    numberDic = [[NSMutableDictionary alloc]init];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:154.0f];
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
        NSString *list = [arr objectAtIndex: indexPath.row];
        NSArray *ar = [list componentsSeparatedByString:@"</a></h1>"];
        NSString *title = [[[ar objectAtIndex:0]componentsSeparatedByString:@".html\">"]objectAtIndex:2];
        NSArray *etc = [[ar objectAtIndex:1]componentsSeparatedByString:@"</div>"];
        NSString *artlist = [[[etc objectAtIndex:0]componentsSeparatedByString:@"list\">"]objectAtIndex:1];
        NSMutableString *artist = [[NSMutableString alloc]init];
        if ([artlist containsString:@"N/A"])
            [artist appendString:@"N/A"];
        else {
            NSArray *a = [artlist componentsSeparatedByString:@"</a></li>"];
            NSInteger b = a.count - 2;
            for (NSInteger i = 0; i <= b; i++) {
                [artist appendString:[[[a objectAtIndex:i]componentsSeparatedByString:@".html\">"]objectAtIndex:1]];
                if (i != b)
                    [artist appendString:@", "];
            }
        }
        NSArray *etc1 = [[etc objectAtIndex:1]componentsSeparatedByString:@"</td>"];
        NSMutableString *series = [[NSMutableString alloc]initWithString:NSLocalizedString(@"Series: ",nil)];
        if ([[etc1 objectAtIndex:1] containsString:@"N/A"])
            [series appendString:@"N/A"];
        else {
            NSArray *a = [[etc1 objectAtIndex:1] componentsSeparatedByString:@"</a></li>"];
            NSInteger b = a.count - 2;
            for (NSInteger i = 0; i <= b; i++) {
                [series appendString:[[[a objectAtIndex:i]componentsSeparatedByString:@".html\">"]objectAtIndex:1]];
                if (i != b)
                    [series appendString:@", "];
            }
        }
        NSMutableString *language = [[NSMutableString alloc]initWithString:NSLocalizedString(@"Language: ",nil)];
        if ([[etc1 objectAtIndex:5] containsString:@"N/A"])
            [language appendString:@"N/A"];
        else
            [language appendString:[[[[[etc1 objectAtIndex:5]componentsSeparatedByString:@".html\">"]objectAtIndex:1]componentsSeparatedByString:@"</a>"]objectAtIndex:0]];
        NSMutableString *tag1 = [[NSMutableString alloc]initWithString:NSLocalizedString(@"Tags: ",nil)];
        NSArray *taga = [[etc1 objectAtIndex:7]componentsSeparatedByString:@"</a></li>"];
        NSInteger tagb = taga.count;
        if (tagb == 1)
            [tag1 appendString:@"N/A"];
        else
            for (NSInteger i = 0; i <= tagb - 2; i++) {
                [tag1 appendString:[[[taga objectAtIndex:i]componentsSeparatedByString:@".html\">"]objectAtIndex:1]];
                if (i != tagb - 2)
                    [tag1 appendString:@", "];
            }
        [cell.DJImage setContentMode:UIViewContentModeScaleAspectFit];
        [cell.DJTitle setText:[String decode:[NSMutableString stringWithString:title]]];
        [cell.DJArtist setText:[String decode:artist]];
        [cell.DJSeries setText:[String decode:series]];
        [cell.DJLang setText:[String decode:language]];
        [cell.DJTag setText:[String decode:tag1]];
        if (arr2.count != 0 && arr2 != nil && [arr2 objectAtIndex:indexPath.row] != nil && [arr2 objectAtIndex:indexPath.row] != [NSNull null]) {
            [cell.DJImage setImage:[UIImage imageWithData:[arr2 objectAtIndex:indexPath.row]]];
        }
        return cell;
    }
    else {
        [cell.DJImage setContentMode:UIViewContentModeScaleAspectFit];
        [cell.DJTitle setText:[String decode:[numberDic objectForKey:@"title"]]];
        [cell.DJArtist setText:[String decode:[numberDic objectForKey:@"artist"]]];
        [cell.DJSeries setText:[String decode:[numberDic objectForKey:@"series"]]];
        [cell.DJLang setText:[String decode:[numberDic objectForKey:@"language"]]];
        [cell.DJTag setText:[String decode:[numberDic objectForKey:@"tag"]]];
        if (arr2.count != 0 && arr2 != nil && [arr2 objectAtIndex:indexPath.row] != nil && [arr2 objectAtIndex:indexPath.row] != [NSNull null]) {
            [cell.DJImage setImage:[UIImage imageWithData:[arr2 objectAtIndex:indexPath.row]]];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row + 1 == arr2.count && !pages && !numbered) {
        page++;
        [self downloadTask:page];
        pages = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"djDetail3"] && !numbered) {
        InfoDetail *segued = segue.destinationViewController;
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        NSString *title1 = [arr objectAtIndex:path.row];
        NSString *title2 = [[title1 componentsSeparatedByString:@".html\">"]objectAtIndex:0];
        NSString *title3 = [[title2 componentsSeparatedByString:@"<a href=\""]objectAtIndex:1];
        djURL = [NSString stringWithFormat:@"https://hitomi.la%@.html",title3];
        segued.URL = djURL;
    }
    else if ([segue.identifier isEqualToString:@"djDetail3"] && numbered) {
        InfoDetail *segued = segue.destinationViewController;
        NSInteger numb = [hitomiNumber integerValue];
        djURL = [NSString stringWithFormat:@"https://hitomi.la/galleries/%ld.html",(long)numb];
        segued.URL = djURL;
    }
}

-(void)downloadTask:(NSUInteger)ind {
    UIView *overlay = [[UIView alloc]initWithFrame:[[self tableView]frame]];
    [overlay setBackgroundColor:[UIColor blackColor]];
    [overlay setAlpha:0.8f];
    [self.view addSubview:overlay];
    [overlay addSubview:activityController];
    activityController.hidden = NO;
    [activityController startAnimating];
    NSMutableString *taga = [NSMutableString stringWithString:tag];
    [taga replaceOccurrencesOfString:@" " withString:@"%20" options:(NSStringCompareOptions)nil range:NSMakeRange(0, [taga length])];
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
        if (error == nil && [(NSHTTPURLResponse *)response statusCode] == 200) {
            NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            str = [String replacingOccurrences:str];
            NSArray *temp = [str componentsSeparatedByString:@"<div class=\"dj\">"];
            for (int i = 1; i < temp.count; i++)
                [arr addObject:[temp objectAtIndex:i]];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t loopForGroup = dispatch_group_create();
            for (NSInteger i = 1; i < temp.count; i++)
                [arr2 addObject:[NSNull null]];
            for (NSInteger i = 0; i < temp.count-1; i++) {
                dispatch_group_async(loopForGroup, queue, ^{
                    NSString *list = [temp objectAtIndex:i];
                    NSString *img = [[list componentsSeparatedByString:@"\"> </div>"]objectAtIndex:0];
                    NSString *imga = [[img componentsSeparatedByString:@"<img src=\""]objectAtIndex:1];
                    NSString *urlString = [NSString stringWithFormat:@"https:%@",imga];
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
                    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data2, NSURLResponse * _Nullable response2, NSError * _Nullable error2) {
                        if (error2 == nil) {
                            [arr2 replaceObjectAtIndex:arr2.count-temp.count+i withObject:data2];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tableView reloadData];
                            });
                        }
                    }];
                    [sessionTask resume];
                });
            }
            dispatch_group_wait(loopForGroup, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                activityController.hidden = YES;
                [activityController stopAnimating];
                [overlay removeFromSuperview];
                pages = NO;
            });
        }
        else if (error == nil && [(NSHTTPURLResponse *)response statusCode] != 200) {
            activityController.hidden = YES;
            [activityController stopAnimating];
            [overlay removeFromSuperview];
            pages = YES;
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

-(void)downloadNumber {
    UIView *overlay = [[UIView alloc]initWithFrame:[[self tableView]frame]];
    [overlay setBackgroundColor:[UIColor blackColor]];
    [overlay setAlpha:0.8f];
    [self.view addSubview:overlay];
    [overlay addSubview:activityController];
    activityController.hidden = NO;
    [activityController startAnimating];
    NSInteger numb = [hitomiNumber integerValue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/galleries/%ld.html",(long)numb]];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSession *session1 = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    NSURLSessionTask *task1 = [session1 dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && [(NSHTTPURLResponse *)response statusCode] == 200) {
            [arr2 addObject:[NSNull null]];
            NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *anime = [[[[str componentsSeparatedByString:@"<td>Type</td><td>"]objectAtIndex:1]componentsSeparatedByString:@"</a></td>"]objectAtIndex:0];
            if ([anime containsString:@"anime"]) {
                arr2 = nil;
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
                NSString *title1 = [[str componentsSeparatedByString:@"</a></h1>"]objectAtIndex:0];
                NSString *title2 = [[[[title1 componentsSeparatedByString:@"<h1>"]objectAtIndex:3]componentsSeparatedByString:@".html\">"]objectAtIndex:1];
                NSString *artist1 = [[[[str componentsSeparatedByString:@"</h2>"]objectAtIndex:0]componentsSeparatedByString:@"<h2>"]objectAtIndex:1];
                NSMutableString *artist = [NSMutableString stringWithString:NSLocalizedString(@"Artist: ",nil)];
                NSArray *artistlist = [artist1 componentsSeparatedByString:@"</a></li>"];
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
                dispatch_group_t loopForGroup = dispatch_group_create();
                NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:picurl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
                NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request2 completionHandler:^(NSData * _Nullable data2, NSURLResponse * _Nullable response2, NSError * _Nullable error2) {
                    if (error2 == nil)
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [numberDic setObject:[String decodes:title2] forKey:@"title"];
                            [numberDic setObject:artist forKey:@"artist"];
                            [numberDic setObject:language forKey:@"language"];
                            [numberDic setObject:series forKey:@"series"];
                            [numberDic setObject:tags forKey:@"tag"];
                            [arr2 replaceObjectAtIndex:0 withObject:data2];
                            activityController.hidden = YES;
                            [activityController stopAnimating];
                            [overlay removeFromSuperview];
                            [self.tableView reloadData];
                        });
                }];
                [sessionTask resume];
                dispatch_group_wait(loopForGroup, DISPATCH_TIME_FOREVER);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    activityController.hidden = YES;
                    [activityController stopAnimating];
                    [overlay removeFromSuperview];
                    pages = YES;
                });
            }
        }
        else if (error == nil && [(NSHTTPURLResponse *)response statusCode] != 200) {
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
        [taga replaceOccurrencesOfString:@" " withString:@"%20" options:(NSStringCompareOptions)nil range:NSMakeRange(0, [taga length])];
        if ([type isEqualToString:@"male"] || [type isEqualToString:@"female"])
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/tag/%@:%@-all-1.html",type,taga]];
        else
            url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/%@/%@-all-1.html",type,taga]];
    }
    else {
        NSInteger numb = [hitomiNumber integerValue];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/galleries/%ld.html",(long)numb]];
    }
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *open = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open in Safari",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:url];
            [self presentViewController:safari animated:YES completion:nil];
        }
        else
            [[UIApplication sharedApplication]openURL:url];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:open];
    [sheet addAction:cancel];
    [self presentViewController:sheet animated:YES completion:nil];
}

@end
