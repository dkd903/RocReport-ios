//
//  RRIssueDetailViewController.m
//  RocReport
//
//  Created by Debjit Saha on 3/30/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import "RRIssueDetailViewController.h"
#import "UIImageView+WebCache.h"
#import <GoogleMaps/GoogleMaps.h>

@interface RRIssueDetailViewController ()

@end

@implementation RRIssueDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}*/

- (void)viewDidLoad {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSMapView *mapView_;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    //self.view = mapView_;
    //[_issueGmaps addSubview:mapView_];
    [self.view addSubview:mapView_];
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"%@", _issue);
    [_issueCat setText:[_issue objectForKey:@"issueCat"]];
    [_issueAddress setText:[_issue objectForKey:@"issueAddress"]];
    [_issueTitle setText:[_issue objectForKey:@"issueDesc"]];
    
    
    NSNumber *latitude = [_issue objectForKey:@"issueLaitude"];
    NSNumber *longitude = [_issue objectForKey:@"issueLongitude"];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    MKCoordinateRegion region;
    region.span = MKCoordinateSpanMake(0.02, 0.02);
    region.center = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
    
    point.coordinate = region.center;
    point.title = [_issue objectForKey:@"issueCat"];
    point.subtitle = [_issue objectForKey:@"issueDesc"];
    
    
    [_issueMap setRegion:region];
    [_issueMap addAnnotation:point];
    
    [_issueImage setImageWithURL:[NSURL URLWithString:[_issue objectForKey:@"issueImage"]]
                   placeholderImage:[UIImage imageNamed:@"cellImageLoader.gif"]];
    
    /*GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    _mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView_.myLocationEnabled = YES;
    _issueGmaps = _mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = _mapView_;*/
    
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
