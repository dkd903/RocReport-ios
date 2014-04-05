//
//  RRLoginViewController.h
//  RocReport
//
//  Created by Debjit Saha on 3/30/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRLoginViewController : UIViewController
- (IBAction)loginPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userMail;
@property (weak, nonatomic) IBOutlet UITextField *userPass;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;
- (IBAction)clickCancelButton:(id)sender;

@end
