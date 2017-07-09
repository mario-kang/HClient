//
//  SearchList.m
//  HClient
//
//  Created by 강희찬 on 2017. 6. 11..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import "SearchList.h"

@interface SearchList ()

@end

@implementation SearchList

@synthesize activityController;
@synthesize Search;
@synthesize searchWord;
@synthesize allList;
@synthesize allList2;

@synthesize previewingContext;

@synthesize tags;

- (void)viewDidLoad {
    [super viewDidLoad];
    bool isForceTouchAvailable = false;
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)])
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    if (isForceTouchAvailable)
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    allList = [[NSMutableArray alloc]init];
    UIView *overlay = [[UIView alloc]initWithFrame:self.splitViewController.view.frame];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.autoresizingMask = (self.tableView).autoresizingMask;
    overlay.alpha = 0.8f;
    [self.splitViewController.view addSubview:overlay];
    activityController = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    activityController.center = overlay.center;
    activityController.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [overlay addSubview:activityController];
    activityController.hidden = NO;
    [activityController startAnimating];
    NSString *urlString = @"https://ltn.hitomi.la/tags.json";
    Search.delegate = self;
    [Search setUserInteractionEnabled:NO];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    NSURLSession *Session = [NSURLSession sharedSession];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSessionTask *sessionTask = [Session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *JSONList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            [self addAll:@"tag" list:JSONList];
            [self addAll:@"artist" list:JSONList];
            [self addAll:@"male" list:JSONList];
            [self addAll:@"female" list:JSONList];
            [self addAll:@"series" list:JSONList];
            [self addAll:@"group" list:JSONList];
            [self addAll:@"character" list:JSONList];
            [self addAll:@"language" list:JSONList];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"count" ascending:NO];
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
            [allList sortUsingDescriptors:@[sortDescriptor,sortDescriptor2]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [Search setUserInteractionEnabled:YES];
                activityController.hidden = YES;
                [activityController stopAnimating];
                [overlay removeFromSuperview];
            });
        }
        else {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error Occured.", nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                activityController.hidden = YES;
                [activityController stopAnimating];
                [overlay removeFromSuperview];
            }];
        }
    }];
    [sessionTask resume];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}

- (void)addAll:(NSString *)type list:(NSDictionary *)list {
    NSString *name, *count;
    NSMutableDictionary *dic;
    for (NSDictionary *a in list[type]) {
        name = a[@"s"];
        count = a[@"t"];
        dic = [[NSMutableDictionary alloc]init];
        dic[@"name"] = name;
        dic[@"count"] = count;
        dic[@"type"] = type;
        [allList addObject:dic];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSPredicate *predicate;
    searchWord = searchText;
    if ([searchText.lowercaseString hasPrefix:@"tag:"]) {
        if (![searchText.lowercaseString isEqualToString:@"tag:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'tag'",[searchText.lowercaseString substringFromIndex:4]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([searchText.lowercaseString hasPrefix:@"artist:"]) {
        if (![searchText.lowercaseString isEqualToString:@"artist:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'artist'",[searchText.lowercaseString substringFromIndex:7]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([searchText.lowercaseString hasPrefix:@"male:"]) {
        if (![searchText.lowercaseString isEqualToString:@"male:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'male'",[searchText.lowercaseString substringFromIndex:5]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([searchText.lowercaseString hasPrefix:@"female:"]) {
        if (![searchText.lowercaseString isEqualToString:@"female:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'female'",[searchText.lowercaseString substringFromIndex:7]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([searchText.lowercaseString hasPrefix:@"series:"]) {
        if (![searchText.lowercaseString isEqualToString:@"series:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'series'",[searchText.lowercaseString substringFromIndex:7]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([searchText.lowercaseString hasPrefix:@"group:"]) {
        if (![searchText.lowercaseString isEqualToString:@"group:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'group'",[searchText.lowercaseString substringFromIndex:6]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([searchText.lowercaseString hasPrefix:@"character:"]) {
        if (![searchText.lowercaseString isEqualToString:@"character:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'character'",[searchText.lowercaseString substringFromIndex:10]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([searchText.lowercaseString hasPrefix:@"language:"]) {
        if (![searchText.lowercaseString isEqualToString:@"language:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'language'",[searchText.lowercaseString substringFromIndex:10]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@",searchText.lowercaseString];
        allList2 = [allList filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return NSLocalizedString(@"Hitomi Tags", nil);
    else
        return NSLocalizedString(@"Hitomi Number", nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (allList == nil)
        return 0;
    else if (section == 0)
        return allList2.count;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
        (cell.textLabel).text = allList2[indexPath.row][@"name"];
        NSString *a = [NSString stringWithFormat:NSLocalizedString(@"%@, %ld item(s)",nil), allList2[indexPath.row][@"type"],(long)[allList2[indexPath.row][@"count"]integerValue]];
        (cell.detailTextLabel).text = a;
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"number" forIndexPath:indexPath];
        NSInteger hitomiNumber = searchWord.integerValue;
        (cell.textLabel).text = [NSString stringWithFormat:NSLocalizedString(@"Find Hitomi number %ld", nil),(long)hitomiNumber];
        return cell;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SearchView *segued = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"search"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        segued.tag = allList2[indexPath.row][@"name"];
        segued.type = allList2[indexPath.row][@"type"];
        segued.numbered = NO;
    }
    else {
        segued.hitomiNumber = searchWord;
        segued.numbered = YES;
    }
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    CGPoint cellPosition = [self.tableView convertPoint:location toView:self.view];
    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cellPosition];
    if (path) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchView *segued = [storyboard instantiateViewControllerWithIdentifier:@"io.github.mario-kang.HClient.searchview"];
        if ([cell.reuseIdentifier isEqualToString:@"list"]) {
            segued.tag = allList2[path.row][@"name"];
            segued.type = allList2[path.row][@"type"];
            segued.numbered = NO;
        }
        else {
            segued.hitomiNumber = searchWord;
            segued.numbered = YES;
        }
        return segued;
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

@end
