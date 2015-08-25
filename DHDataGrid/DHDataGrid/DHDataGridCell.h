//
//  DHDataGridCell.h
//  TestScrollView
//
//  Created by DH on 2014/10/23.
//  Copyright (c) 2014年 DH. All rights reserved.
//

@import UIKit;

typedef enum {
    DHDataGridCellTypeNone,
    DHDataGridCellTypeMove,
    DHDataGridCellTypeTap
} DHDataGridCellType;

typedef void (^LongPressBegin)(UIView *cell);
typedef void (^LongPressMove)(UIView *cell, CGPoint point);
typedef void (^LongPressEnd)(UIView *cell,CGPoint point);
typedef void (^TapStart)(NSString *value);

@protocol DHDataGridCellDelegate;

@interface DHDataGridCell : UIView

@property (nonatomic, weak) id<DHDataGridCellDelegate> delegate;

@property (nonatomic, assign) DHDataGridCellType cellType;
@property (nonatomic, copy) LongPressBegin longPressBegin;
@property (nonatomic, copy) LongPressMove longPressMove;
@property (nonatomic, copy) LongPressEnd longPressEnd;

@property (nonatomic, assign) NSInteger cellIndex;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

- (id) initWithFrame:(CGRect)frame cellType:(DHDataGridCellType) type;

- (void) setText:(NSString *) text;
- (void) setTextAlignment:(NSTextAlignment) align;
- (void) setTextBackgroundColor:(UIColor *) color;
- (void) setFont:(UIFont *) font;
- (void) setBackGroundImage:(UIImage *) image;

@end

@protocol DHDataGridCellDelegate <NSObject>
@optional
- (void) dataGridCell:(DHDataGridCell *) cell startChangeCenter:(CGPoint) point;
- (void) dataGridCell:(DHDataGridCell *) cell changeCenter:(CGPoint) point;
- (void) dataGridCell:(DHDataGridCell *) cell endChangeCenter:(CGPoint) point;
- (void) dataGridCell:(DHDataGridCell *) cell selectText:(NSString *) text;
@end