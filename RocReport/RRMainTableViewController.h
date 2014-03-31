//
//  RRMainTableViewController.h
//  RocReport
//
//  Created by Debjit Saha on 3/30/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRRAPPAPIKEY @"Fuhjvfuys67389bjkbvHFGvcjhDSHJ6243ghsbfyu"
#define kRRissueID @"issueID"
#define kRRissueCat @"issueCat"
#define kRRissueDesc @"issueDesc"
#define kRRissueLocality @"issueLocality"
#define kRRissueAddress @"issueAddress"
#define kRRissueLatitude @"issueLaitude"
#define kRRissueLongitude @"issueLongitude"
#define kRRissueVotes @"issueVotes"
#define kRRissueImage @"issueImage"

@interface RRMainTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableArray *issueList;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@end
