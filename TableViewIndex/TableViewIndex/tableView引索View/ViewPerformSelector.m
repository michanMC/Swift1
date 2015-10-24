//
//  ViewPerformSelector.m
//  广州铁路
//
//  Created by michan on 15/3/6.
//  Copyright (c) 2015年 MC. All rights reserved.
//

#import "ViewPerformSelector.h"

@implementation ViewPerformSelector
//- (id)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor clearColor];
//    }
//    return self;
//}
-(void)layoutSubviews
{
    
    
    
}
-(void)PerformSelector:(UIView *)view
{
    
    [view.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    
    
}
@end
