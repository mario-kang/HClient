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

@interface InfoDetail : UIViewController 

@property (strong) IBOutlet UIImageView *Image;
@property (strong) IBOutlet UILabel *Title;
@property (strong) IBOutlet UILabel *Artist;
@property (strong) IBOutlet UILabel *Series;
@property (strong) IBOutlet UILabel *Language;
@property (strong) IBOutlet UILabel *Tag;

@property (strong) UIActivityIndicatorView *activityController;
@property (strong) NSString *URL;
@property (strong) NSString *ViewerURL;

@end
