//
//  DHDataGridHorizontalRow.h
//  DHDataGrid
//
//  Created by DH on 2014/10/26.
//  Copyright (c) 2014年 DH. All rights reserved.
//

@import UIKit;
#import "DHDataGridCell.h"

@interface DHDataGridHorizontalRow : UIView

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, readonly) NSArray *cells;

- (void) addVisableCell:(DHDataGridCell *) cell;
- (NSInteger) getCellCount;
- (DHDataGridCell *) getCellWithIndex:(NSInteger) index;
- (void) setCell:(DHDataGridCell *) cell index:(NSInteger) index;
- (void) showVisableCell:(DHDataGridCell *) cell;
- (void) actionProcessWithBegin:(LongPressBegin) begin move:(LongPressMove) move end:(LongPressEnd) end;

@end