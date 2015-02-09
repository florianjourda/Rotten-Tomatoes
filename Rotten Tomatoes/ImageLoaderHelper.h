//
//  ImageLoaderHelper
//  Rotten Tomatoes
//
//  Created by Florian Jourda on 2/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+AFNetworking.h"

@interface ImageLoaderHelper : NSObject

+ (void) setImage:(UIImageView *)imageView withUrlString:(NSString *)urlString;
+ (void) setImage:(UIImageView *)imageView withUrlString:(NSString *)urlString withPlaceHolderImage:placeHolderImage;

@end
