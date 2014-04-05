//
//  RRRegisterViewController.m
//  RocReport
//
//  Created by Debjit Saha on 4/5/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import "RRRegisterViewController.h"
#import "AFNetworking.h"
#import "RRApiCreds.h"

@interface RRRegisterViewController ()

@end

@implementation RRRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    _userPassword.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerClicked:(id)sender {
    
    
    NSString *userEmail = [_userEmail text];
    NSString *userName = [_userName text];
    NSString *userPass = [_userPassword text];
    
    //Trim whitespace if any
    [userEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    [userPass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    
    if ([userEmail length] == 0 || [userName length] == 0 || [userPass length] == 0) {
        UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Please fill in all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [newAlert show];
    } else {
        
        //API Calls
        //save token
        //on success move ahead
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kRRAPIURL]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *parameters = @{ @"email" : userEmail, @"password" : userPass, @"name" : userName, @"id" : kRRAPPAPIKEY };
        
        AFHTTPRequestOperation *op = [manager POST:@"auth/register/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
            [_registerIndicator stopAnimating];
            //[_fieldQuestion setText:responseObject[@"data"]];
            
            if ([responseObject[@"status"] boolValue]) {
                
                //move user back to login screen
                [self performSegueWithIdentifier:@"MoveToLoginFromRegister" sender:self];
                
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:responseObject[@"data"][@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
            [_registerIndicator stopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:operation.responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
        
        [_registerIndicator startAnimating];
        [op start];
        
    }
    
    
}
@end
