//
//  mainMenu.h
//  HClient
//
//  Created by 강희찬 on 2017. 6. 10..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import "String.h"
#import "InfoDetail.h"

@interface mainMenu : UITableViewController <UIViewControllerPreviewingDelegate>

@property (strong) UIActivityIndicatorView *activityController;
@property (strong) NSMutableArray *arr;
@property (strong) NSMutableArray *arr2;
@property (strong) NSMutableArray *arr3;
@property (strong) NSMutableArray *celllist;

@property (strong) id previewingContext;

@property bool pages;
@property NSInteger page;

@end

@interface MainmenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *DJImage;
@property (weak, nonatomic) IBOutlet UILabel *DJTitle;
@property (weak, nonatomic) IBOutlet UILabel *DJArtist;
@property (weak, nonatomic) IBOutlet UILabel *DJLang;
@property (weak, nonatomic) IBOutlet UILabel *DJTag;
@property (weak, nonatomic) IBOutlet UILabel *DJSeries;

@end
