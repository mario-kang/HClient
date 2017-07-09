//
//  InfoDetail.h
//  HClient
//
//  Created by 강희찬 on 2017. 6. 10..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
#import "String.h"
#import "Viewer.h"
#import "SearchView.h"
#import "Viewer.h"

@interface InfoDetail : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionIcon;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookmarkIcon;
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UILabel *Artist;
@property (weak, nonatomic) IBOutlet UILabel *Group;
@property (weak, nonatomic) IBOutlet UILabel *Type;
@property (weak, nonatomic) IBOutlet UILabel *Series;
@property (weak, nonatomic) IBOutlet UILabel *Character;
@property (weak, nonatomic) IBOutlet UILabel *Language;
@property (weak, nonatomic) IBOutlet UILabel *Tag;
@property (weak, nonatomic) IBOutlet UILabel *Date;

@property (strong) UIActivityIndicatorView *activityController;
@property (strong) NSString *URL;
@property (strong) NSString *ViewerURL;

@end
