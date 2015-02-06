//
//  MovieDetailViewController.m
//  Rotten Tomatoes
//
//  Created by Florian Jourda on 2/3/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  NSString *urlString = [[self.movie valueForKeyPath:@"posters.thumbnail"] stringByReplacingOccurrencesOfString: @"_tmb.jpg" withString:@"_ori.jpg"];
  NSURL *url = [NSURL URLWithString:urlString];

  [self.fullPosterView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:self.lowResImage
      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
          [UIView transitionWithView:self.fullPosterView
                duration:0.3
                options:UIViewAnimationOptionTransitionCrossDissolve
                animations:^{
                    self.fullPosterView.image = image;
                }
                completion:NULL
           ];
      }
      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
      }
   ];

  [self.parallaxScrollView setScrollEnabled:TRUE];

 // [self.parallaxScrollView setContentSize:CGSizeMake(self.parallaxScrollView.frame.size.width, self.fullPosterView.frame.size.height)];
   [self.parallaxScrollView setContentSize:CGSizeMake(self.parallaxScrollView.frame.size.width, 10)];

  self.title = self.movie[@"title"];
  self.detailsLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.movie[@"title"], self.movie[@"year"]];
  self.mpaaRatingLabel.text = self.movie[@"mpaa_rating"];
  self.synopsisLabel.text = [NSString stringWithFormat:@"Critic score: %@%%\nAudience score: %@%%\n\n%@", self.movie[@"ratings"][@"critics_score"], self.movie[@"ratings"][@"audience_score"], self.movie[@"synopsis"]];
  [self.synopsisLabel sizeToFit];
  [self.detailsScrollView setContentSize:CGSizeMake(self.detailsScrollView.frame.size.width, self.synopsisLabel.frame.size.height + 360)];

  CGRect newFrame = self.detailsBackgroundView.frame;
  newFrame.size = CGSizeMake(self.detailsScrollView.frame.size.width, self.synopsisLabel.frame.size.height + 500);
  self.detailsBackgroundView.frame = newFrame;
  //[self.detailsScrollView setContentOffset:CGPointMake(0, -300) animated:YES];

  self.detailsScrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parallax

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSLog(@"SCROLL");
  CGFloat detailMaxOffset = self.detailsScrollView.contentSize.width - CGRectGetWidth(self.parallaxScrollView.frame);

  CGFloat maxOffset = 100;
  CGFloat parallaxOffset = 0;

  CGFloat percentage = self.detailsScrollView.contentOffset.x / maxOffset;

  CGFloat parallaxMaxOffset = self.parallaxScrollView.contentSize.width - CGRectGetWidth(self.parallaxScrollView.frame);

  //[self.parallaxScrollView setContentOffset:CGPointMake(percentage * parallaxOffset, 0)];

  //[self.parallaxScrollView setContentOffset:self.detailsScrollView.contentOffset];
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
