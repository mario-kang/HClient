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
@synthesize tagList;
@synthesize artistList;
@synthesize maleList;
@synthesize femaleList;
@synthesize seriesList;
@synthesize groupList;
@synthesize characterList;
@synthesize tagList1;
@synthesize artistList1;
@synthesize maleList1;
@synthesize femaleList1;
@synthesize seriesList1;
@synthesize groupList1;
@synthesize characterList1;
@synthesize searchWord;

@synthesize Active;
@synthesize tags;

- (void)viewDidLoad {
    [super viewDidLoad];
    activityController = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [activityController setCenter:self.view.center];
    [activityController setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
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
    NSURLSession *Session = [NSURLSession sharedSession];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSURLSessionTask *sessionTask = [Session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *JSONList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            tagList = [JSONList objectForKey:@"tag"];
            artistList = [JSONList objectForKey:@"artist"];
            maleList = [JSONList objectForKey:@"male"];
            femaleList = [JSONList objectForKey:@"female"];
            seriesList = [JSONList objectForKey:@"series"];
            groupList = [JSONList objectForKey:@"group"];
            characterList = [JSONList objectForKey:@"character"];
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
    tagList1 = [[NSArray alloc]init];
    artistList1 = [[NSArray alloc]init];
    maleList1 = [[NSArray alloc]init];
    femaleList1 = [[NSArray alloc]init];
    seriesList1 = [[NSArray alloc]init];
    groupList1 = [[NSArray alloc]init];
    characterList1 = [[NSArray alloc]init];
    if ([[searchText lowercaseString] hasPrefix:@"tag:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"tag:"]) {
            predicate = [NSPredicate predicateWithFormat:@"s CONTAINS %@",[[searchText lowercaseString]substringFromIndex:4]];
            tagList1 = [tagList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"artist:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"artist:"]) {
            predicate = [NSPredicate predicateWithFormat:@"s CONTAINS %@",[[searchText lowercaseString]substringFromIndex:7]];
            artistList1 = [artistList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"male:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"male:"]) {
            predicate = [NSPredicate predicateWithFormat:@"s CONTAINS %@",[[searchText lowercaseString]substringFromIndex:5]];
            maleList1 = [maleList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"female:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"female:"]) {
            predicate = [NSPredicate predicateWithFormat:@"s CONTAINS %@",[[searchText lowercaseString]substringFromIndex:7]];
            femaleList1 = [femaleList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"series:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"series:"]) {
            predicate = [NSPredicate predicateWithFormat:@"s CONTAINS %@",[[searchText lowercaseString]substringFromIndex:7]];
            seriesList1 = [seriesList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"group:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"group:"]) {
            predicate = [NSPredicate predicateWithFormat:@"s CONTAINS %@",[[searchText lowercaseString]substringFromIndex:6]];
            groupList1 = [groupList filteredArrayUsingPredicate:predicate];
        }
    }
    else if ([[searchText lowercaseString] hasPrefix:@"character:"]) {
        if (![[searchText lowercaseString] isEqualToString:@"character:"]) {
            predicate = [NSPredicate predicateWithFormat:@"s CONTAINS %@",[[searchText lowercaseString]substringFromIndex:10]];
            characterList1 = [characterList filteredArrayUsingPredicate:predicate];
        }
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"s CONTAINS %@",[searchText lowercaseString]];
        tagList1 = [tagList filteredArrayUsingPredicate:predicate];
        artistList1 = [artistList filteredArrayUsingPredicate:predicate];
        maleList1 = [maleList filteredArrayUsingPredicate:predicate];
        femaleList1 = [femaleList filteredArrayUsingPredicate:predicate];
        seriesList1 = [seriesList filteredArrayUsingPredicate:predicate];
        groupList1 = [groupList filteredArrayUsingPredicate:predicate];
        characterList1 = [characterList filteredArrayUsingPredicate:predicate];
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
    if (tagList1 == nil)
        return 0;
    else if (section == 0)
        return tagList1.count+artistList1.count+maleList1.count+femaleList1.count+seriesList1.count+groupList1.count+characterList1.count;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *a;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
        if (indexPath.row < tagList1.count) {
            [cell.textLabel setText:[[tagList1 objectAtIndex:indexPath.row]objectForKey:@"s"]];
            a = [NSString stringWithFormat:NSLocalizedString(@"Tag, %d item(s)", nil), [[[tagList1 objectAtIndex:indexPath.row]objectForKey:@"t"]intValue]];
            [cell.detailTextLabel setText:a];
        }
        else if (indexPath.row - tagList1.count < artistList1.count) {
            [cell.textLabel setText:[[artistList1 objectAtIndex:indexPath.row-tagList1.count]objectForKey:@"s"]];
            a = [NSString stringWithFormat:NSLocalizedString(@"Artist, %d item(s)", nil), [[[artistList1 objectAtIndex:indexPath.row-tagList1.count]objectForKey:@"t"]intValue]];
            [cell.detailTextLabel setText:a];
        }
        else if (indexPath.row - tagList1.count - artistList1.count < maleList1.count) {
            [cell.textLabel setText:[[maleList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count]objectForKey:@"s"]];
            a = [NSString stringWithFormat:NSLocalizedString(@"Male, %d item(s)", nil), [[[maleList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count]objectForKey:@"t"]intValue]];
            [cell.detailTextLabel setText:a];
        }
        else if (indexPath.row - tagList1.count - artistList1.count - maleList1.count < femaleList1.count) {
            [cell.textLabel setText:[[femaleList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count]objectForKey:@"s"]];
            a = [NSString stringWithFormat:NSLocalizedString(@"Female, %d item(s)", nil), [[[femaleList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count]objectForKey:@"t"]intValue]];
            [cell.detailTextLabel setText:a];
        }
        else if (indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count < seriesList1.count) {
            [cell.textLabel setText:[[seriesList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count]objectForKey:@"s"]];
            a = [NSString stringWithFormat:NSLocalizedString(@"Series, %d item(s)", nil), [[[seriesList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count]objectForKey:@"t"]intValue]];
            [cell.detailTextLabel setText:a];
        }
        else if (indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count - seriesList1.count < groupList1.count) {
            [cell.textLabel setText:[[groupList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count - seriesList1.count]objectForKey:@"s"]];
            a = [NSString stringWithFormat:NSLocalizedString(@"Group, %d item(s)", nil), [[[groupList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count - seriesList1.count]objectForKey:@"t"]intValue]];
            [cell.detailTextLabel setText:a];
        }
        else {
            [cell.textLabel setText:[[characterList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count - seriesList1.count - groupList1.count]objectForKey:@"s"]];
            a = [NSString stringWithFormat:NSLocalizedString(@"Character, %d item(s)", nil), [[[characterList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count - seriesList1.count - groupList1.count]objectForKey:@"t"]intValue]];
            [cell.detailTextLabel setText:a];
        }
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
        if (indexPath.row < tagList1.count) {
            segued.tag = [[tagList1 objectAtIndex:indexPath.row]objectForKey:@"s"];
            segued.type = @"tag";
        }
        else if (indexPath.row - tagList1.count < artistList1.count) {
            segued.tag = [[artistList1 objectAtIndex:indexPath.row-tagList1.count]objectForKey:@"s"];
            segued.type = @"artist";
        }
        else if (indexPath.row - tagList1.count - artistList1.count < maleList1.count) {
            segued.tag = [[maleList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count]objectForKey:@"s"];
            segued.type = @"male";
        }
        else if (indexPath.row - tagList1.count - artistList1.count - maleList1.count < femaleList1.count) {
            segued.tag = [[femaleList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count]objectForKey:@"s"];
            segued.type = @"female";
        }
        else if (indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count < seriesList1.count) {
            segued.tag = [[seriesList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count]objectForKey:@"s"];
            segued.type = @"series";
        }
        else if (indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count - seriesList1.count < groupList1.count) {
            segued.tag = [[groupList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count - seriesList1.count]objectForKey:@"s"];
            segued.type = @"group";
        }
        else {
            segued.tag = [[characterList1 objectAtIndex:indexPath.row - tagList1.count - artistList1.count - maleList1.count - femaleList1.count - seriesList1.count - groupList1.count]objectForKey:@"s"];
            segued.type = @"character";
        }
        segued.numbered = NO;
    }
    else {
        SearchView *segued = segue.destinationViewController;
        segued.hitomiNumber = searchWord;
        segued.numbered = YES;
    }
}

@end
