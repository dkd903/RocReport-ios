//
//  RRLoginViewController.m
//  RocReport
//
//  Created by Debjit Saha on 3/30/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import "RRLoginViewController.h"
#import "RRApiCreds.h"
#import "AFNetworking.h"

@interface RRLoginViewController ()

@end

@implementation RRLoginViewController

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
    //if user is already logged in then skip to welcome
    //read token from local store
    [super viewDidAppear:YES];
    _userPass.secureTextEntry = YES;
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

- (IBAction)loginPressed:(id)sender {
    //NSLog(@"Login Pressed: %i", [_issueList count]);
    //[self performSegueWithIdentifier:@"SegueLoginViewBackToAdd" sender:self];
    
    NSString *userEmail = [_userMail text];
    NSString *userPass = [_userPass text];
    
    //Trim whitespace if any
    [userEmail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    [userPass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    
    if ([userEmail length] == 0 || [userPass length] == 0) {
        
        UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Please fill in all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [newAlert show];
        
    } else {
        
        //API Calls
        //save token
        //on success move ahead
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kRRAPIURL]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        NSDictionary *parameters = @{ @"email" : userEmail, @"password" : userPass, @"id" : kRRAPPAPIKEY };
        
        AFHTTPRequestOperation *op = [manager POST:@"auth/login/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
            
            [_loginIndicator stopAnimating];
            
            NSLog(@"%@", responseObject[@"data"]);
            
            if ([responseObject[@"status"] boolValue]) {
                
                //Save the token in a token state
                NSError *error;
                NSString *homeDirectory = NSHomeDirectory();
                NSString *filePath = [homeDirectory stringByAppendingString:@"/Documents/RRtoken.txt"];
                NSString *rrToken = responseObject[@"data"][@"token"];
                [rrToken writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
                NSLog(@"%@", rrToken);
                
                //move user back to add issue screen
                //[self performSegueWithIdentifier:@"SegueLoginViewBackToAdd" sender:self];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:responseObject[@"data"][@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
            [_loginIndicator stopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:operation.responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];
        
        [_loginIndicator startAnimating];
        [op start];
        
    }
    
}

- (IBAction)clickCancelButton:(id)sender {
    
    //move user back to add issue screen
    //[self performSegueWithIdentifier:@"SegueLoginViewBackToAdd" sender:self];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
