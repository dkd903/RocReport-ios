//
//  RRAddIssueViewController.m
//  RocReport
//
//  Created by Debjit Saha on 3/30/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import "RRAddIssueViewController.h"
#import "RRApiCreds.h"
#import "AFNetworking.h"

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
    
    //check if image has been added
    _imageChanged = 0;
    
    //get the token if it exists
    NSString *mntoken = @"";
    NSString *homeDirectory = NSHomeDirectory();
    NSString *filePath = [homeDirectory stringByAppendingString:@"/Documents/RRtoken.txt"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        mntoken = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        //skip login screen if token exists
        if ([mntoken length] < 8) {
            NSLog(@"%@", mntoken);
            [self performSegueWithIdentifier:@"SegueLoginView" sender:self];
        } else {
            //set the token
            _rrtoken = mntoken;
        }
    } else {
        NSLog(@"NO file");
        [self performSegueWithIdentifier:@"SegueLoginView" sender:self];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        [_locationManager setPurpose:@"This location is used to find the exact location of the issue you are reporting"];
    }
    [_locationManager startUpdatingLocation];
    //[_issueIndicator startAnimating];
    [_issueLocation setText:@"Getting Location..."];
    
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

- (IBAction)issueAddButton:(id)sender {
    
    NSString *issueDesc = [_issueText text];
    NSString *issueLoc = [_issueLocation text];
    NSData *issueImage = UIImageJPEGRepresentation(_issueImageToUpload, 50);
    __block NSString *imageUrl = @"";
    
    //Trim whitespace if any
    [issueDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    [issueLoc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    
    NSLog(@"%@",_issueImageToUpload);
    
    if ([issueDesc length] == 0 || _issueImageToUpload == nil) {
        
        UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill in all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [newAlert show];
        
    } else if ( _locationManager.location == nil ) {
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Turn On Location services to Allow \"RocReport\" to Determine Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        _issueLocation.text = @"Unable to get Location, Please Enable Location Services";
        
    }else {
        
        [_issueIndicator startAnimating];
        
        //API Calls
        //First upload the image & then after a succesful upload,
        //add the issue using the image url response
        
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kRRAPIURL]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        //get Image url
        NSDictionary *parameters = @{ @"token": _rrtoken, @"id": kRRAPPAPIKEY};
        
        AFHTTPRequestOperation *op = [manager POST:@"image/add/" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            //do not put image inside parameters dictionary as I did, but append it!
            [formData appendPartWithFileData:issueImage name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
            [_issueIndicator stopAnimating];
            
            if ([responseObject[@"status"] boolValue]) {
                
                imageUrl = responseObject[@"data"][@"image_url"];

                //Post the Isuue if the response in above step has the URL of image
                if ([imageUrl isEqualToString:@""]) {
                    
                } else {
                    
                    NSDictionary *parametersa = @{ @"location" : issueLoc, @"category" : @"test", @"description" : issueDesc, @"picture" : imageUrl, @"novote" : @"true", @"id" : kRRAPPAPIKEY, @"token" : _rrtoken, @"latitude" : _lati, @"longitude" : _longi, @"locality" : _addrLocality, @"formatted_address" : _addrFull, @"country" : _addrCountry,  };
                    
                    AFHTTPRequestOperation *opa = [manager POST:@"report/add/" parameters:parametersa success:^(AFHTTPRequestOperation *operationa, id responseObjecta) {
                        
                        NSLog(@"Success: %@ ***** %@", operationa.responseString, responseObjecta);
                        
                        [_issueIndicator stopAnimating];
                        
                        //NSLog(@"%@", responseObjecta[@"data"]);
                        //NSLog(@"%@", responseObjecta[@"status"]);
                        
                        if ([responseObjecta[@"status"] boolValue]) {
                            
                            //[self dismissViewControllerAnimated:YES completion:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                            //NSLog(@"I ma her");
                            
                        } else {
                            
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:responseObjecta[@"data"][@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alertView show];
                            
                        }
                        
                        
                    } failure:^(AFHTTPRequestOperation *operationa, NSError *error) {
                        
                        NSLog(@"Error: %@ ***** %@", operationa.responseString, error);
                        [_issueIndicator stopAnimating];
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:operationa.responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertView show];
                        
                    }];
                    
                    [_issueIndicator startAnimating];
                    [opa start];
                    
                }
                
            } else {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:responseObject[@"data"][@"reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            //NSLog(@"Error: %@ ***** %@", operation.responseString, error);
            [_issueIndicator stopAnimating];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:operation.responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }];

        [op start];
        
    }
    
}

/**
 Function that decides what to do after image add is tapped
 */
-(void)newTapMethod{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //UIImagePickerControllerSourceTypeCamera
    //UIImagePickerControllerSourceTypePhotoLibrary
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

/**
 Handle image after selection has been done
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/480.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0;
        }
        else{
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"%@", image);
    [_issueImageView setImage:img];
    _issueImageToUpload = img;
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

/**
 Handle image after user presses cancel
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/**
 Image Add Click Button
 */
- (IBAction)issueTakeImage:(id)sender {
    [self newTapMethod];
}

/**
 Image Add Click Button Text
 */
- (IBAction)issueTakeImageText:(id)sender {
    [self newTapMethod];
}


#pragma mark - Navigation Bar methods
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"Got L");
    //[_issueIndicator stopAnimating];
    
    NSNumber *lati = [[NSNumber alloc] initWithFloat:0.0];
    NSNumber *longi = [[NSNumber alloc] initWithFloat:0.0];
    
    if (_locationManager.location != nil) {
        CLLocation *currentLocation = _locationManager.location;
        CLLocationCoordinate2D currentCoords = currentLocation.coordinate;
        lati = [[NSNumber alloc] initWithFloat:currentCoords.latitude];
        longi = [[NSNumber alloc] initWithFloat:currentCoords.longitude];
        
        //NSLog(@"%@", lati);
        //NSLog(@"%@", longi);
        _lati = lati;
        _longi = longi;
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        // Reverse Geocoding
        NSLog(@"Resolving the Address");
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                CLPlacemark *placemark;
                placemark = [placemarks lastObject];
                _issueLocation.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                       placemark.subThoroughfare, placemark.thoroughfare,
                                       placemark.postalCode, placemark.locality,
                                       placemark.administrativeArea,
                                       placemark.country];
 
                _addrLocality = placemark.locality;
                _addrCountry = placemark.country;
                _addrFull = _issueLocation.text;
                
            } else {
                //NSLog(@"%@", error.debugDescription);
            }
        } ];
        
        //stop the location manager to conserve power
        [_locationManager stopUpdatingLocation];
        
    }
    
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [_issueIndicator stopAnimating];
    /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Turn On Location services to Allow \"RocReport\" to Determine Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];*/
    _issueLocation.text = @"Unable to get Location, Please Enable Location Services";
}

#pragma mark - Hide Keyboard
//On touching any space on the screen

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([_issueText isFirstResponder] && [touch view] != _issueText) {
        [_issueText resignFirstResponder];
    }
    if ([_issueLocation isFirstResponder] && [touch view] != _issueLocation) {
        [_issueLocation resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Hide Keyboard With Button

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)submitTopClick:(id)sender {
}
@end
