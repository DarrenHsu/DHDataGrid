//
//  DHDataGridView.h
//  TestScrollView
//
//  Created by DH on 2014/10/23.
//  Copyright (c) 2014年 DH. All rights reserved.
//

@import UIKit;

@protocol DHDataGridViewDelegate;

@interface DHDataGridView : UIView

@property (nonatomic, weak) id<DHDataGridViewDelegate> delegate;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat leftSideWeight;
@property (nonatomic, assign) CGFloat rightCellWeight;

@property (nonatomic, strong) UIColor *headerColor;
@property (nonatomic, strong) UIColor *contentColor;

@property (nonatomic, strong) UIColor *headerFontColor;
@property (nonatomic, strong) UIColor *contentFontColor;

@property (nonatomic, strong) UIFont *headerFount;
@property (nonatomic, strong) UIFont *contentFount;

@property (nonatomic, strong) NSArray *leftHeaderCNames;            // @[header1] 中文
@property (nonatomic, strong) NSArray *leftHeaderNames;             // @[header1]
@property (nonatomic, strong) NSArray *leftContents;                // @[@{header1 : content1, header2 : content2, ...}, ...]

@property (nonatomic, strong) NSMutableArray *rightHeaderCNames;    // @[header1] 中文
@property (nonatomic, strong) NSMutableArray *rightHeaderNames;     // @[header1]
@property (nonatomic, strong) NSMutableArray *rightContents;        // @[@{header1 : content1, header2 : content2, ...}, ...]

- (id) initWithFrame:(CGRect)frame
        headerHeight:(CGFloat) hheight
           cellHeight:(CGFloat) cheight
     leftHeaderCName:(NSArray *) lcnames
      leftSideWeight:(CGFloat) lweight
     leftHeaderNames:(NSArray *) lhnames
        leftContents:(NSArray *) lcontents
    rightHeaderCName:(NSMutableArray *) rcnames
 rightSideCellWeight:(CGFloat) rweight
    rightHeaderNames:(NSMutableArray *) rhnames
       rightContents:(NSMutableArray *) rcontents
    hiddenIndexArray:(NSArray *) harray;

- (void) setGestureRecognizerToFail:(UIGestureRecognizer *) gesture;

@end

@protocol DHDataGridViewDelegate <NSObject>
@optional
- (void) dataGridView:(DHDataGridView *) dataGrid selectValue:(NSString *) str;
- (void) dataGridView:(DHDataGridView *) dataGrid moveIndex:(NSInteger) mindex changeIndex:(NSInteger) cindex;
@end