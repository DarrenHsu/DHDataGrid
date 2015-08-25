//
//  DHScrollView.h
//  TestScrollView
//
//  Created by DH on 2014/10/25.
//  Copyright (c) 2014年 DH. All rights reserved.
//

@import UIKit;

#import "DHDataGridHorizontalRow.h"
#import "DHDataGridVerticalRow.h"
#import "DHDataGridCell.h"

typedef enum {
    DHScrollViewStyleX,
    DHScrollViewStyleY
} DHScrollViewStyle;

@protocol DHScrollViewDelegate;
@protocol DHScrollViewDataSource;

@interface DHScrollView : UIScrollView

@property (nonatomic, weak) id<DHScrollViewDelegate> DHDelegate;
@property (nonatomic, weak) id<DHScrollViewDataSource> DHDataSource;
@property (nonatomic, assign) DHScrollViewStyle layoutStyle;
@property (nonatomic, assign) CGSize subViewSize;

- (id) initWithFrame:(CGRect)frame layoutStyle:(DHScrollViewStyle) style;

- (NSArray *) getAllRow;
- (NSArray *) getCellsWithCellIndex:(NSInteger) cindex;

- (LongPressBegin) getLongPressBegin;
- (LongPressMove) getLongPressMove;
- (LongPressEnd) getLongPressEnd;

@end

@protocol DHScrollViewDataSource <NSObject>
@required
- (NSInteger) numberOfViewsInScrollView:(DHScrollView *) scrollView;
- (CGSize) sizeOfViewsInScrollView:(DHScrollView *) scrollView;
- (DHDataGridHorizontalRow *) rowWithIndex:(NSInteger) index scrollView:(DHScrollView *) scrollView;
@end

@protocol DHScrollViewDelegate <NSObject>
@optional
- (void) scrollToIndex:(NSInteger) index;
- (void) selectToIndex:(NSInteger) index;
@end