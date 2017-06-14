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
@synthesize arr;
@synthesize djURL;

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIView *overlay = [[UIView alloc]initWithFrame:[[self tableView]frame]];
    [overlay setBackgroundColor:[UIColor blackColor]];
    [overlay setAlpha:0.8f];
    [self.view addSubview:overlay];
    [overlay addSubview:activityController];
    activityController.hidden = NO;
    [activityController startAnimating];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:154.0f];
    favoritesdata = [[NSMutableArray alloc]init];
    arr = [[NSMutableArray alloc]init];
    NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
    favoriteslist = [NSMutableArray arrayWithArray:[favorites arrayForKey:@"favorites"]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t loopForGroup = dispatch_group_create();
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    for (int a = 0; a < favoriteslist.count; a++) {
        [favoritesdata addObject:[NSNull null]];
        [arr addObject:[NSNull null]];
    }
    for (int a = 0; a < favoriteslist.count; a++) {
        dispatch_group_async(loopForGroup, queue, ^{
            NSURL *url = [NSURL URLWithString:[favoriteslist objectAtIndex:a]];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error == nil) {
                    NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
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
                    NSMutableString *series = [NSMutableString stringWithString:NSLocalizedString(@"Series: ",)];
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
                    NSMutableString *tags = [NSMutableString stringWithString:NSLocalizedString(@"Tags: ",)];
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
                        if (error2 == nil) {
                            [arr replaceObjectAtIndex:a withObject:data2];
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                            [dic setObject:[String decodes:title2] forKey:@"title"];
                            [dic setObject:artist forKey:@"artist"];
                            [dic setObject:language forKey:@"language"];
                            [dic setObject:series forKey:@"series"];
                            [dic setObject:tags forKey:@"tags"];
                            [favoritesdata replaceObjectAtIndex:a withObject:dic];
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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    activityController = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [activityController setCenter:self.view.center];
    [activityController setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (favoriteslist == nil || favoriteslist.count == 0)
        return 0;
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (favoriteslist == nil)
        return 0;
    else
        return favoriteslist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
    [cell.DJImage setContentMode:UIViewContentModeScaleAspectFit];
    if ([favoritesdata objectAtIndex:indexPath.row] != nil && [favoritesdata objectAtIndex:indexPath.row] != [NSNull null]) {
        NSDictionary *dic = [favoritesdata objectAtIndex:indexPath.row];
        [cell.DJTitle setText:[dic objectForKey:@"title"]];
        [cell.DJArtist setText:[dic objectForKey:@"artist"]];
        [cell.DJSeries setText:[dic objectForKey:@"series"]];
        [cell.DJLang setText:[dic objectForKey:@"language"]];
        [cell.DJTag setText:[dic objectForKey:@"tags"]];
    }
    if (arr.count != 0 && arr != nil && [arr objectAtIndex:indexPath.row] != nil && [arr objectAtIndex:indexPath.row] != [NSNull null]) {
        [cell.DJImage setImage:[UIImage imageWithData:[arr objectAtIndex:indexPath.row]]];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUserDefaults *favorites = [NSUserDefaults standardUserDefaults];
        [arr removeObjectAtIndex:indexPath.row];
        [favoriteslist removeObjectAtIndex:indexPath.row];
        [favoritesdata removeObjectAtIndex:indexPath.row];
        [favorites setObject:favoriteslist forKey:@"favorites"];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"djDetail2"]) {
        InfoDetail *segued = segue.destinationViewController;
        NSIndexPath *path = self.tableView.indexPathForSelectedRow;
        djURL = [favoriteslist objectAtIndex:path.row];
        segued.URL = djURL;
    }
}

@end
