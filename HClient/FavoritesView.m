//
//  FavoritesView.m
//  HClient
//
//  Created by 강희찬 on 2017. 6. 11..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import "FavoritesView.h"

@interface FavoritesCell ()

@end

@implementation FavoritesCell

@synthesize DJTag;
@synthesize DJLang;
@synthesize DJImage;
@synthesize DJTitle;
@synthesize DJArtist;
@synthesize DJSeries;

@end

@interface FavoritesView ()

@end

@implementation FavoritesView

@synthesize activityController;
@synthesize favoriteslist;
@synthesize favoritesdata;
@synthesize favoriteskeys;
@synthesize arr;
@synthesize previewingContext;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView *overlay = [[UIView alloc]initWithFrame:self.splitViewController.view.frame];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0.8f;
    [self.splitViewController.view addSubview:overlay];
    [overlay addSubview:activityController];
    activityController.hidden = NO;
    [activityController startAnimating];
    (self.tableView).rowHeight = UITableViewAutomaticDimension;
    (self.tableView).estimatedRowHeight = 154.0f;
    favoritesdata = [[NSMutableArray alloc]init];
    arr = [[NSMutableArray alloc]init];
    NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
    favoriteslist = [NSMutableArray arrayWithArray:[favorites arrayForKey:@"favorites"]];
    favoriteskeys = [NSMutableArray arrayWithArray:[favorites arrayForKey:@"favoritesKey"]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t loopForGroup = dispatch_group_create();
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    for (int a = 0; a < favoriteslist.count; a++) {
        [favoritesdata addObject:[NSNull null]];
        [arr addObject:[NSNull null]];
    }
    for (int a = 0; a < favoriteslist.count; a++) {
        dispatch_group_async(loopForGroup, queue, ^{
            NSURL *url = [NSURL URLWithString:favoriteslist[a]];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
            NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error == nil) {
                    NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
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
                    NSMutableString *series = [NSMutableString stringWithString:NSLocalizedString(@"Series: ",)];
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
                    NSMutableString *tags = [NSMutableString stringWithString:NSLocalizedString(@"Tags: ",)];
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
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:picurl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
                    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request1 completionHandler:^(NSData * _Nullable data2, NSURLResponse * _Nullable response2, NSError * _Nullable error2) {
                        if (error2 == nil) {
                            arr[a] = data2;
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                            dic[@"title"] = [String decodes:title2];
                            dic[@"artist"] = artist;
                            dic[@"language"] = language;
                            dic[@"series"] = series;
                            dic[@"tags"] = tags;
                            favoritesdata[a] = dic;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tableView reloadData];
                            });
                        }
                    }];
                    [sessionTask resume];
                }
                else {
                    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error Occured.",nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
                        [alert addAction:action];
                        [self presentViewController:alert animated:YES completion:nil];
                    }];
                }
            }];
            [task resume];
        });
    }
    dispatch_group_wait(loopForGroup, DISPATCH_TIME_FOREVER);
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    [self.tableView reloadData];
    activityController.hidden = YES;
    [activityController stopAnimating];
    [overlay removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    activityController = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    activityController.center = self.splitViewController.view.center;
    activityController.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    bool isForceTouchAvailable = false;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)])
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    if (isForceTouchAvailable) {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return NSLocalizedString(@"Hitomi Items", nil);
    else
        return NSLocalizedString(@"Hitomi Tags", nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return favoriteslist.count;
    else
        return favoriteskeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
        (cell.DJImage).contentMode = UIViewContentModeScaleAspectFit;
        if (favoritesdata[indexPath.row] != nil && favoritesdata[indexPath.row] != [NSNull null]) {
            NSDictionary *dic = favoritesdata[indexPath.row];
            (cell.DJTitle).text = dic[@"title"];
            (cell.DJArtist).text = dic[@"artist"];
            (cell.DJSeries).text = dic[@"series"];
            (cell.DJLang).text = dic[@"language"];
            (cell.DJTag).text = dic[@"tags"];
        }
        if (arr.count != 0 && arr != nil && arr[indexPath.row] != nil && arr[indexPath.row] != [NSNull null]) {
            (cell.DJImage).image = [UIImage imageWithData:arr[indexPath.row]];
        }
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listKeyword" forIndexPath:indexPath];
        (cell.textLabel).text = favoriteskeys[indexPath.row];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
        if (indexPath.section == 0) {
            [arr removeObjectAtIndex:indexPath.row];
            [favoriteslist removeObjectAtIndex:indexPath.row];
            [favoritesdata removeObjectAtIndex:indexPath.row];
            [favorites setObject:favoriteslist forKey:@"favorites"];
            [favorites synchronize];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
        }
        else {
            [favoriteskeys removeObjectAtIndex:indexPath.row];
            [favorites setObject:favoriteskeys forKey:@"favoritesKey"];
            [favorites synchronize];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (sourceIndexPath.section == 0) {
        NSString *url = favoriteslist[sourceIndexPath.row];
        [favoriteslist removeObjectAtIndex:sourceIndexPath.row];
        [favoriteslist insertObject:url atIndex:destinationIndexPath.row];
        [defaults setObject:favoriteslist forKey:@"favorites"];
        [defaults synchronize];
    }
    else {
        NSString *obj = favoriteskeys[sourceIndexPath.row];
        [favoriteskeys removeObjectAtIndex:sourceIndexPath.row];
        [favoriteskeys insertObject:obj atIndex:destinationIndexPath.row];
        [defaults setObject:favoriteskeys forKey:@"favoritesKey"];
        [defaults synchronize];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"djDetail2"]) {
        InfoDetail *segued = segue.destinationViewController;
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        NSString *djURL = favoriteslist[path.row];
        segued.URL = djURL;
    }
    else if ([segue.identifier isEqualToString:@"favoritesSearch"]) {
        SearchView *segued = segue.destinationViewController;
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        NSString *types = favoriteskeys[path.row];
        segued.type = [types componentsSeparatedByString:@":"][0];
        segued.tag = [types componentsSeparatedByString:@":"][1];
        segued.numbered = NO;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section != proposedDestinationIndexPath.section)
        return sourceIndexPath;
    else
        return proposedDestinationIndexPath;
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    CGPoint cellPosition = [self.tableView convertPoint:location toView:self.view];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPosition];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (path.section == 0) {
        InfoDetail *segued = [storyboard instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.infodetail"];
        NSString *djURL = favoriteslist[path.row];
        segued.URL = djURL;
        return segued;
    }
    else {
        SearchView *segued = [storyboard instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.searchview"];
        NSString *types = favoriteskeys[path.row];
        segued.type = [types componentsSeparatedByString:@":"][0];
        segued.tag = [types componentsSeparatedByString:@":"][1];
        segued.numbered = NO;
        return segued;
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

@end
