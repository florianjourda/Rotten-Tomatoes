//
//  MovieDetailViewController.h
//  Rotten Tomatoes
//
//  Created by Florian Jourda on 2/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *detailsScrollView;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *mpaaRatingLabel;
@property (weak, nonatomic) IBOutlet UIView *detailsBackgroundView;


@property (weak, nonatomic) IBOutlet UIScrollView *parallaxScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *fullPosterView;

@property (strong, nonatomic) NSDictionary *movie;
@property (weak, nonatomic) UIImage *lowResImage;
@end
