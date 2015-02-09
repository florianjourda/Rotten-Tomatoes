//
//  MovieCollectionViewCell.h
//  Rotten Tomatoes
//
//  Created by Florian Jourda on 2/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
