//
//  MovieCell.m
//  Rotten Tomatoes
//
//  Created by Florian Jourda on 2/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell


- (void)awakeFromNib {
  // Initialization code

  UIView *bgColorView = [[UIView alloc] init];
  bgColorView.backgroundColor = [UIColor darkGrayColor];
  [self setSelectedBackgroundView:bgColorView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // NSLog(@"SELECTED");
    // Configure the view for the selected state
}

/*
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
  [super setHighlighted:highlighted animated:animated];
  NSLog(@"HIGH");
  if (highlighted) {
    self.textLabel.textColor = [UIColor whiteColor];
  } else {
    self.textLabel.textColor = [UIColor blackColor];
  }
}
*/

@end
