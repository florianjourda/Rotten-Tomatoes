//
//  MovieCell.h
//  Rotten Tomatoes
//
//  Created by Florian Jourda on 2/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
