//
//  MovieDetailViewController.m
//  Rotten Tomatoes
//
//  Created by Florian Jourda on 2/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ImageLoaderHelper.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupPoster];
  [self setupDetails];
  [self setupSwipe];
  [self setupTap];
  [self scrollViewDidScroll:self.detailsScrollView];
}

- (void)setupDetails {
  self.title = self.movie[@"title"];
  self.detailsLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.movie[@"title"], self.movie[@"year"]];
  self.mpaaRatingLabel.text = self.movie[@"mpaa_rating"];
  self.synopsisLabel.text = [NSString stringWithFormat:@"Critic score: %@%%\nAudience score: %@%%\n\n%@", self.movie[@"ratings"][@"critics_score"], self.movie[@"ratings"][@"audience_score"], self.movie[@"synopsis"]];
  [self.synopsisLabel sizeToFit];
  [self.detailsScrollView setContentSize:CGSizeMake(self.detailsScrollView.frame.size.width, self.synopsisLabel.frame.size.height + 360)];
  
  CGRect newFrame = self.detailsBackgroundView.frame;
  newFrame.size = CGSizeMake(self.detailsScrollView.frame.size.width, self.synopsisLabel.frame.size.height + 500);
  self.detailsBackgroundView.frame = newFrame;

  self.detailsScrollView.delegate = self;
  self.detailsScrollView.alwaysBounceVertical = YES;
}

- (void)setupPoster {
  // Do any additional setup after loading the view from its nib.
  NSString *urlString = [[self.movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString: @"_tmb.jpg" withString:@"_ori.jpg"];
  [ImageLoaderHelper setImage:self.fullPosterView withUrlString:urlString withPlaceHolderImage:self.lowResImage];
  [self.parallaxScrollView setContentSize:self.fullPosterView.frame.size];
  [self.parallaxScrollView setScrollEnabled:FALSE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parallax

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat detailsScrollMaxOffset = self.detailsScrollView.contentSize.height - CGRectGetHeight(self.detailsScrollView.frame);
  CGFloat parallaxScrollMaxOffset = self.parallaxScrollView.contentSize.height - CGRectGetHeight(self.parallaxScrollView.frame);

  CGFloat percentage = self.detailsScrollView.contentOffset.y /detailsScrollMaxOffset;
  percentage = MIN(percentage, 1.0);
  percentage = MAX(percentage, 0.0);

  NSLog(@"SCROLL %f", percentage);
  [self.parallaxScrollView setContentOffset:CGPointMake(0, percentage * parallaxScrollMaxOffset)];
}

# pragma mark - Tap to hide details

- (void)setupTap {
  UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
  [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer{
  NSLog(@"TAP");

  [UIView animateWithDuration:0.4 animations:^{
    CGRect newFrame = self.detailsScrollView.frame;
    newFrame.origin = CGPointMake(newFrame.origin.x, newFrame.size.height - newFrame.origin.y);
    self.detailsScrollView.frame = newFrame;
  } completion:^(BOOL finished) {
    // Do something here when the animation finishes.
  }];
}

#pragma mark - Swipe to go back to home

- (void)setupSwipe {
  UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer)];
  swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  [self.view addGestureRecognizer:swipeGestureRecognizer];
}

- (void)slideToRightWithGestureRecognizer {
  NSLog(@"SWIPE");
  [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
