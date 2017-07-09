//
//  mainMenu.m
//  HClient
//
//  Created by 강희찬 on 2017. 6. 10..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import "mainMenu.h"

@interface MainmenuCell ()

@end

@implementation MainmenuCell

@synthesize DJTag;
@synthesize DJLang;
@synthesize DJImage;
@synthesize DJTitle;
@synthesize DJArtist;
@synthesize DJSeries;

@end

@interface mainMenu ()

@end

@implementation mainMenu

@synthesize activityController;
@synthesize arr;
@synthesize arr2;
@synthesize arr3;
@synthesize pages;
@synthesize page;
@synthesize previewingContext;
@synthesize celllist;

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
    pages = NO;
    activityController = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    activityController.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    celllist = [[NSMutableArray alloc]init];
    arr = [[NSMutableArray alloc]init];
    arr2 = [[NSMutableArray alloc]init];
    arr3 = [[NSMutableArray alloc]init];
    (self.tableView).rowHeight = UITableViewAutomaticDimension;
    (self.tableView).estimatedRowHeight = 154.0f;
    page = 1;
    bool isForceTouchAvailable = false;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)])
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    if (isForceTouchAvailable)
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    [self downloadTask:page];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (arr == nil)
        return 0;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arr == nil)
        return 0;
    else
        return arr2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainmenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
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
    NSMutableString *tag = [[NSMutableString alloc]initWithString:NSLocalizedString(@"Tags: ",nil)];
    NSArray *taga = [etc1[7]componentsSeparatedByString:@"</a></li>"];
    NSInteger tagb = taga.count;
    if (tagb == 1)
        [tag appendString:@"N/A"];
    else
        for (NSInteger i = 0; i <= tagb - 2; i++) {
            [tag appendString:[taga[i]componentsSeparatedByString:@".html\">"][1]];
            if (i != tagb - 2)
                [tag appendString:@", "];
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
                    MainmenuCell *update = (id)[tableView cellForRowAtIndexPath:indexPath];
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
    (cell.DJTag).text = [String decode:tag];
    if (![celllist containsObject:[NSString stringWithFormat:@"%lu",(unsigned long)indexPath.row]])
        [celllist addObject:[NSString stringWithFormat:@"%lu",(unsigned long)indexPath.row]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"djDetail1"]) {
        InfoDetail *segued = segue.destinationViewController;
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        NSString *title = [[arr[path.row]componentsSeparatedByString:@".html\">"][0]componentsSeparatedByString:@"<a href=\""][1];
        NSString *djURL = [NSString stringWithFormat:@"https://hitomi.la%@.html",title];
        segued.URL = djURL;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row + 1 == arr2.count && !pages) {
        page++;
        [self downloadTask:page];
        pages = YES;
    }
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://hitomi.la/index-all-%lu.html",(unsigned long)ind]];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSession *session1 = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    NSURLSessionTask *task1 = [session1 dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
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
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *activity = [UIAlertAction actionWithTitle:NSLocalizedString(@"Share URL", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"https://hitomi.la/"];
        UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
        activityController.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
        [self presentViewController:activityController animated:YES completion:nil];
    }];
    UIAlertAction *open = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open in Safari",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SFSafariViewController *safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"https://hitomi.la/"]];
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

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    CGPoint cellPosition = [self.tableView convertPoint:location toView:self.view];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPosition];
    if (path) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InfoDetail *segued = [storyboard instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.infodetail"];
        NSString *title = [[arr[path.row]componentsSeparatedByString:@".html\">"][0]componentsSeparatedByString:@"<a href=\""][1];
        NSString *djURL = [NSString stringWithFormat:@"https://hitomi.la%@.html",title];
        segued.URL = djURL;
        return segued;
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

@end
