//
//  SearchList.h
//  HClient
//
//  Created by 강희찬 on 2017. 6. 11..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"

@interface SearchList : UITableViewController<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *Search;

@property (strong) NSArray *tagList;
@property (strong) NSArray *artistList;
@property (strong) NSArray *maleList;
@property (strong) NSArray *femaleList;
@property (strong) NSArray *seriesList;
@property (strong) NSArray *groupList;
@property (strong) NSArray *characterList;
@property (strong) NSArray *tagList1;
@property (strong) NSArray *artistList1;
@property (strong) NSArray *maleList1;
@property (strong) NSArray *femaleList1;
@property (strong) NSArray *seriesList1;
@property (strong) NSArray *groupList1;
@property (strong) NSArray *characterList1;
@property (strong) UIActivityIndicatorView *activityController;

@property bool Active;
@property bool tags;

@end
