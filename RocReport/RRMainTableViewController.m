//
//  RRMainTableViewController.m
//  RocReport
//
//  Created by Debjit Saha on 3/30/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import "RRMainTableViewController.h"
#import "RRIssueDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "RRApiCreds.h"
#import "MyCustomCell.h"

@interface RRMainTableViewController ()

@end

@implementation RRMainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _issueList = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //COnnect to the API with an Async POST request
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kRRAPIURL]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{ @"type" : @"locality", @"name" : @"syracuse" , @"id" : kRRAPPAPIKEY };
    
    AFHTTPRequestOperation *op = [manager POST:@"report/fetch/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
        [_activityIndicatorObject stopAnimating];
        
        //NSLog(@"%@", responseObject[@"data"]);
        
        if ([responseObject[@"status"] boolValue]) {
            
            //get the data part of the response
            NSArray *apiResponseData = responseObject[@"data"];
            
            //iterate through the results
            for (id object in apiResponseData) {
                //object has all the details about the Issue
                NSString *issueID = [object objectForKey:@"report_id"];
                NSString *issueCat = [object objectForKey:@"category"];
                NSString *issueDesc = [object objectForKey:@"description"];
                NSString *issueLocality = [object objectForKey:@"locality"];
                NSString *issueAddress = [object objectForKey:@"formatted_address"];
                NSString *issueLatitude = [object objectForKey:@"latitude"];
                NSString *issueLongitude = [object objectForKey:@"longitude"];
                NSString *issueVotes = [object objectForKey:@"vote_count"];
                NSString *issueImage = [object objectForKey:@"picture"];
                NSDictionary *issueDetails = [[NSDictionary alloc] initWithObjectsAndKeys:issueID, kRRissueID, issueCat, kRRissueCat, issueDesc, kRRissueDesc,
                                              issueLocality, kRRissueLocality, issueAddress, kRRissueAddress, issueLatitude, kRRissueLatitude,
                                              issueLongitude, kRRissueLongitude, issueVotes, kRRissueVotes, issueImage, kRRissueImage,
                                              nil];
                
                //add it to the issue list array
                [_issueList addObject:issueDetails];
            }
            
            //Reload the tableview
            [[self tableView] reloadData];
            
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:responseObject[@"data"][@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        [_activityIndicatorObject stopAnimating];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:operation.responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
    [_activityIndicatorObject startAnimating];
    [op start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_issueList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell" forIndexPath:indexPath];
    
    /*MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    }*/
    
    // Configure the cell...
    
    int rowNumber = [indexPath row];
    
    NSDictionary *issueDictionary = [_issueList objectAtIndex:rowNumber];

    NSString *issueCat = [issueDictionary objectForKey:kRRissueCat];
    NSString *issueDesc = [issueDictionary objectForKey:kRRissueDesc];
    NSString *issueLocality = [issueDictionary objectForKey:kRRissueLocality];
    NSString *issueImage = [issueDictionary objectForKey:kRRissueImage];
    
    //set the text label and the description label
    [[cell textLabel] setText:issueDesc];
    [[cell detailTextLabel] setText:[[issueCat stringByAppendingString:@" in "] stringByAppendingString:issueLocality]];
    [[cell imageView] setImage:[UIImage imageNamed:@"button.png"]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:issueImage]
                   placeholderImage:[UIImage imageNamed:@"cellImageLoader.gif"]];
    cell.imageView.transform = CGAffineTransformMakeScale(0.65, 0.65);
    
    //cell.issueDsc.text = issueDesc;
    //cell.issueCt.text = [[issueCat stringByAppendingString:@" in "] stringByAppendingString:issueLocality];
    //[cell.issueImg setImageWithURL:[NSURL URLWithString:issueImage]
      //             placeholderImage:[UIImage imageNamed:@"cellImageLoader.gif"]];
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"SegueIssueDetailView"]) {
        NSIndexPath *selectedRow = [[self tableView] indexPathForSelectedRow];
        NSDictionary *selectedIssue = [_issueList objectAtIndex:[selectedRow row]];
        RRIssueDetailViewController *rrViewController = [segue destinationViewController];
        [rrViewController setIssue: selectedIssue];
        NSLog(@"%@",@"fff");
    }
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    //[messageAlert show];

}*/

@end
