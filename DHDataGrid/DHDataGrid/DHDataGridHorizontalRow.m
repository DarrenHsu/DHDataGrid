//
//  DHDataGridHorizontalRow.m
//  DHDataGrid
//
//  Created by DH on 2014/10/26.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHDataGridHorizontalRow.h"

@interface DHDataGridHorizontalRow ()

@property (nonatomic, strong) NSMutableArray *visableSubCells;

@end

@implementation DHDataGridHorizontalRow

- (NSArray *) cells {
    return _visableSubCells;
}

- (void) addVisableCell:(DHDataGridCell *) cell {
    if (!_visableSubCells)
        _visableSubCells = [NSMutableArray new];
    
    [_visableSubCells addObject:cell];
}

- (NSInteger) getCellCount {
    return _visableSubCells.count;
}

- (DHDataGridCell *) getCellWithIndex:(NSInteger) index {
    return _visableSubCells[index];
}

- (void) setCell:(DHDataGridCell *) cell index:(NSInteger) index {
    [_visableSubCells setObject:cell atIndexedSubscript:index];
}

- (void) showVisableCell:(DHDataGridCell *) cell {
    CGFloat x = self.frame.size.width;
    CGFloat h = 0.f;
    CGRect cframe = cell.frame;
    cframe.origin.x = x;
    cell.frame = cframe;
    [self addSubview:cell];

    h = cframe.size.height;
    x += cframe.size.width;
    self.frame = CGRectMake(0, 0, x, h);
}

- (void) actionProcessWithBegin:(LongPressBegin) begin move:(LongPressMove) move end:(LongPressEnd) end {
    for (DHDataGridCell *cell in self.cells) {
        [cell setLongPressBegin:begin];
        [cell setLongPressMove:move];
        [cell setLongPressEnd:end];
    }
}

@end