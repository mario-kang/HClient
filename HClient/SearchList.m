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

@synthesize Active;
@synthesize tags;

- (void)viewDidLoad {
    [super viewDidLoad];
    activityController = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [activityController setCenter:self.view.center];
    [activityController setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    allList = [[NSMutableArray alloc]init];
    UIView *overlay = [[UIView alloc]initWithFrame:[[self tableView]frame]];
    [overlay setBackgroundColor:[UIColor blackColor]];
    [overlay setAlpha:0.8f];
    [self.view addSubview:overlay];
    [overlay addSubview:activityController];
    activityController.hidden = NO;
    [activityController startAnimating];
    NSString *urlString = @"https://ltn.hitomi.la/tags.json";
    Search.delegate = self;
    Active = NO;
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

-(void)addAll:(NSString *)type list:(NSDictionary *)list {
    for (NSDictionary *a in [list objectForKey:type]) {
        NSString *name = [a objectForKey:@"s"];
        NSString *count = [a objectForKey:@"t"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:name forKey:@"name"];
        [dic setObject:count forKey:@"count"];
        [dic setObject:type forKey:@"type"];
        [allList addObject:dic];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    Active = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    Active = NO;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    Active = NO;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    Active = NO;
    [self.view endEditing:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSPredicate *predicate;
    searchWord = searchText;
    if ([[searchText lowercaseString] hasPrefix:@"tag:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"tag:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'tag'",[[searchText lowercaseString]substringFromIndex:4]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"artist:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"artist:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'artist'",[[searchText lowercaseString]substringFromIndex:7]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"male:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"male:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'male'",[[searchText lowercaseString]substringFromIndex:5]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"female:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"female:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'female'",[[searchText lowercaseString]substringFromIndex:7]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"series:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"series:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'series'",[[searchText lowercaseString]substringFromIndex:7]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"group:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"group:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'group'",[[searchText lowercaseString]substringFromIndex:6]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"character:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"character:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'character'",[[searchText lowercaseString]substringFromIndex:10]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"language:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"language:"]) {
            predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@ AND type LIKE 'language'",[[searchText lowercaseString]substringFromIndex:10]];
            allList2 = [allList filteredArrayUsingPredicate:predicate];
        }
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@",[searchText lowercaseString]];
        allList2 = [allList filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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
        [cell.textLabel setText:[[allList2 objectAtIndex:indexPath.row]objectForKey:@"name"]];
        NSString *a = [NSString stringWithFormat:NSLocalizedString(@"%@, %ld item(s)",nil), [[allList2 objectAtIndex:indexPath.row]objectForKey:@"type"],(long)[[[allList2 objectAtIndex:indexPath.row]objectForKey:@"count"]integerValue]];
        [cell.detailTextLabel setText:a];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"number" forIndexPath:indexPath];
        NSInteger hitomiNumber = [searchWord integerValue];
        [cell.textLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Find Hitomi number %ld", nil),(long)hitomiNumber]];
        return cell;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"search"]) {
        SearchView *segued = segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        segued.tag = [[allList2 objectAtIndex:indexPath.row]objectForKey:@"name"];
        segued.type = [[allList2 objectAtIndex:indexPath.row]objectForKey:@"type"];
        segued.numbered = NO;
    }
    else {
        SearchView *segued = segue.destinationViewController;
        segued.hitomiNumber = searchWord;
        segued.numbered = YES;
    }
}

@end
