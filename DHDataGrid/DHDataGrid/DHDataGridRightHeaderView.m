//
//  DHDataGridRightHeaderView.m
//  TestScrollView
//
//  Created by DH on 2014/10/23.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHDataGridRightHeaderView.h"
#import "DHDataGridCell.h"

@implementation DHDataGridRightHeaderView

- (LongPressBegin) getLongPressBegin {
    LongPressBegin begin = ^void(UIView *cell) {
        DHDataGridCell *_cell = (DHDataGridCell *)cell;
        [_cell setBackgroundColor:[UIColor yellowColor]];
    };
    return begin;
}

- (LongPressMove) getLongPressMove {
    LongPressMove move = ^void(UIView *cell,CGPoint point) {
        DHDataGridCell *_cell = (DHDataGridCell *)cell;
        if (_cell.frame.origin.x + _cell.frame.size.width > self.contentOffset.x + self.bounds.size.width) {
            [self scrollRectToVisible:CGRectMake(self.contentOffset.x + _cell.frame.size.width, self.contentOffset.y, self.bounds.size.width, self.bounds.size.height)
                             animated:YES];
        }else if (_cell.frame.origin.x < self.contentOffset.x) {
            [self scrollRectToVisible:CGRectMake(self.contentOffset.x - _cell.frame.size.width, self.contentOffset.y, self.bounds.size.width, self.bounds.size.height)
                             animated:YES];
        }
//        NSLog(@"move %f %f",point.x,point.y);
    };
    return move;
}

- (LongPressMove) getLongPressEnd {
    LongPressEnd end = ^void(UIView *cell,CGPoint point) {
//        DHDataGridCell *_cell = (DHDataGridCell *)cell;
//        NSLog(@"end %f %f",point.x,point.y);
    };
    return end;
}

@end