//
//  SearchView.h
//  HClient
//
//  Created by 강희찬 on 2017. 6. 11..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import "String.h"
#import "InfoDetail.h"

@interface SearchView : UITableViewController

@property (strong) UIActivityIndicatorView *activityController;
@property (strong) NSString *type;
@property (strong) NSString *tag;
@property (strong) NSMutableArray *arr;
@property (strong) NSMutableArray *arr2;
@property (strong) NSString *djURL;
@property (strong) NSString *hitomiNumber;
@property (strong) NSMutableDictionary *numberDic;
@property bool pages;
@property bool numbered;
@property NSInteger page;

@end

@interface SearchCell : UITableViewCell

@property (weak) IBOutlet UIImageView *DJImage;
@property (weak) IBOutlet UILabel *DJTitle;
@property (weak) IBOutlet UILabel *DJArtist;
@property (weak) IBOutlet UILabel *DJLang;
@property (weak) IBOutlet UILabel *DJTag;
@property (weak) IBOutlet UILabel *DJSeries;

@end
