//
//  MyCustomCell.h
//  RocReport
//
//  Created by Debjit Saha on 4/6/14.
//  Copyright (c) 2014 ___DM___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *issueImg;
@property (weak, nonatomic) IBOutlet UILabel *issueDsc;
@property (weak, nonatomic) IBOutlet UILabel *issueCt;


@end
