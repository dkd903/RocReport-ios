//
//  RRAddIssueViewController.m
//  RocReport
//
//  Created by Debjit Saha on 3/30/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import "RRAddIssueViewController.h"

@interface RRAddIssueViewController ()

@end

@implementation RRAddIssueViewController

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
    [super viewDidAppear:TRUE];
    
    NSString *mntoken = @"";
    NSString *homeDirectory = NSHomeDirectory();
    NSString *filePath = [homeDirectory stringByAppendingString:@"/Documents/RRtoken.txt"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        mntoken = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        //skip login screen if token exists
        if ([mntoken length] < 8) {
            NSLog(@"%@", mntoken);
            [self performSegueWithIdentifier:@"SegueLoginView" sender:self];
        }
    } else {
        NSLog(@"NO file");
        [self performSegueWithIdentifier:@"SegueLoginView" sender:self];
    }
    
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

@end
