//
//  RRMainTableViewController.m
//  RocReport
//
//  Created by Debjit Saha on 3/30/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import "RRMainTableViewController.h"
#import "UIImageView+WebCache.h"

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
    

    //COnnect to the API with an Async POST request
    NSString *apiUrl = @"http://www.rocreport.org/v2/api/report/fetch/";
    NSURL *URL = [NSURL URLWithString:apiUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    
    NSString *params = [@"type=locality&name=syracuse&id=" stringByAppendingString:kRRAPPAPIKEY];
    
    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%i", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
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
    //[[cell imageView] setImage:[UIImage imageNamed:@"button.png"]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:issueImage]
                   placeholderImage:[UIImage imageNamed:@"cellImageLoader.gif"]];
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    //_responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    //Parse the JSON response
    NSError *error;
    NSDictionary *apiResponse = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:kNilOptions
                                error:&error];
    
    //check if the response is good to go
    NSString *apiResponseStatus = [apiResponse objectForKey:@"status"];
    if ([apiResponseStatus boolValue] == 1) {
        
        //get the data part of the response
        NSArray *apiResponseData = [apiResponse objectForKey:@"data"];
        
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
        //NSLog(@"%d", [_issueList count]);
        
    } else {
        
        //Show alert that request was not fine
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something Went Wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }

}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end
