//
//  DHDataGridVerticalRow.m
//  TestScrollView
//
//  Created by DH on 2014/10/23.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHDataGridVerticalRow.h"

@implementation DHDataGridVerticalRow

- (NSArray *) cells {
    return self.subviews;
}

- (void) addCell:(DHDataGridCell *) cell {
    [self addSubview:cell];
}

@end