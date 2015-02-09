//
//  ImageLoaderHelper
//  Rotten Tomatoes
//
//  Created by Florian Jourda on 2/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "ImageLoaderHelper.h"

@implementation ImageLoaderHelper

+ (void) setImage:(UIImageView *)imageView withUrlString:(NSString *)urlString {
  [self setImage:imageView withUrlString:urlString withPlaceHolderImage:nil];

}

+ (void) setImage:(UIImageView *)imageView withUrlString:(NSString *)urlString withPlaceHolderImage:placeHolderImage {
  imageView.image = nil;

  // @NOTE(florian) 2015-02-08: There is a bug:
  // the image is not reset to nil if setImageWithURLRequest is called just after imageView.image = nil.
  // The work around is to do a 'setTimeout' of 0.
  int64_t delayInSeconds = 0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] placeholderImage:placeHolderImage
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
          Boolean isLoadedFromCache = (response == nil);
          if (isLoadedFromCache) {
            imageView.image = image;
          } else {
            [UIView transitionWithView:imageView
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                imageView.image = image;
                            }
                            completion:NULL
            ];
          }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        }
     ];
  });

}

@end
