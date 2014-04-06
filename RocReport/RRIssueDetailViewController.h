//
//  RRIssueDetailViewController.h
//  RocReport
//
//  Created by Debjit Saha on 3/30/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import "RRMainTableViewController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RRIssueDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *issueCat;
@property (weak, nonatomic) IBOutlet UILabel *issueTitle;
@property (weak, nonatomic) IBOutlet UILabel *issueAddress;
@property (weak, nonatomic) IBOutlet UIImageView *issueImage;
@property (weak, nonatomic) IBOutlet MKMapView *issueMap;
@property (weak, nonatomic) NSDictionary *issue;

@end
