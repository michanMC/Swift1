//
//  ArrayDispose.m
//  广州铁路
//
//  Created by michan on 15/3/7.
//  Copyright (c) 2015年 MC. All rights reserved.
//

#import "ArrayDispose.h"

@implementation ArrayDispose

-(NSArray*)KeyArray:(NSArray*)keyArray
{
    NSArray * KeyArray =[keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                         {
        if ([obj2 isEqualToString:@" "])
                                 
        return [obj2 compare:obj1 options:NSNumericSearch];
        return [obj1 compare:obj2 options:NSNumericSearch];
                             
                         }];

    return KeyArray;
    
}

@end
