//
//  mainMenu.h
//  HClient
//
//  Created by 강희찬 on 2017. 6. 10..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "String.h"
#import "InfoDetail.h"


@interface mainMenu : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong) UIActivityIndicatorView *activityController;
@property (strong) NSMutableArray *arr;
@property (strong) NSMutableArray *arr2;
@property (strong) NSString *djURL;

@property bool pages;
@property NSInteger page;

@end

@interface MainmenuCell : UITableViewCell

@property (weak) IBOutlet UIImageView *DJImage;
@property (weak) IBOutlet UILabel *DJTitle;
@property (weak) IBOutlet UILabel *DJArtist;
@property (weak) IBOutlet UILabel *DJLang;
@property (weak) IBOutlet UILabel *DJTag;
@property (weak) IBOutlet UILabel *DJSeries;

@end