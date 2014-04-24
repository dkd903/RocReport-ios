//
//  RRAddIssueViewController.h
//  RocReport
//
//  Created by Debjit Saha on 3/30/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RRAddIssueViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) NSString *rrtoken;
@property int imageChanged;
@property (weak, nonatomic) IBOutlet UITextField *issueText;
@property (weak, nonatomic) IBOutlet UITextField *issueLocation;
@property (strong, nonatomic) UIImage *issueImageToUpload;
@property (strong, nonatomic) IBOutlet UIImageView *issueImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *issueIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *issueImageView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) NSNumber* lati;
@property (strong, nonatomic) NSNumber* longi;
@property (strong, nonatomic) NSString* addrLocality;
@property (strong, nonatomic) NSString* addrCountry;
@property (strong, nonatomic) NSString* addrFull;
@property (weak, nonatomic) IBOutlet UITextField *issueCat;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString *pickerCatChosen;

- (IBAction)issueCatHit:(id)sender;
- (IBAction)issueAddButton:(id)sender;
- (IBAction)issueTakeImage:(id)sender;
- (IBAction)issueTakeImageText:(id)sender;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)submitTopClick:(id)sender;

@end