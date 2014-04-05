//
//  RRRegisterViewController.h
//  RocReport
//
//  Created by Debjit Saha on 4/5/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRRegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
- (IBAction)registerClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *registerIndicator;

@end
