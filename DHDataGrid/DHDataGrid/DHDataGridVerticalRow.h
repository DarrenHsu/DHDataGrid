//
//  DHDataGridVerticalRow.h
//  TestScrollView
//
//  Created by DH on 2014/10/23.
//  Copyright (c) 2014年 DH. All rights reserved.
//

@import UIKit;
#import "DHDataGridCell.h"

@interface DHDataGridVerticalRow : UIView

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, readonly) NSArray *cells;

- (void) addCell:(DHDataGridCell *) cell;

@end