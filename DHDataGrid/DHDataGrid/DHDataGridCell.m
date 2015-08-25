//
//  DHDataGridCell.m
//  TestScrollView
//
//  Created by DH on 2014/10/23.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHDataGridCell.h"

@import QuartzCore;

@interface DHDataGridCell () {
    CGPoint _priorPoint;
    CGFloat _fector;
}

@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UIColor *borderColor;

@end

@implementation DHDataGridCell

- (NSString *) description {
    return [NSString stringWithFormat:@"%@",_textLabel.text];
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _borderColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.f];

        [self setBackgroundColor:_borderColor];
        
        _backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_backImgView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, frame.size.width - 2, frame.size.height - 2)];
        [_textLabel setNumberOfLines:2];
        [self addSubview:_textLabel];
        
        [self setFont:[UIFont boldSystemFontOfSize:16.f]];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame cellType:(DHDataGridCellType) type {
    self = [self initWithFrame:frame];
    if (self) {
        _cellType = type;
        
        if (type == DHDataGridCellTypeMove) {
            _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
            [self addGestureRecognizer:_longPressGesture];
        }else if(type == DHDataGridCellTypeTap) {
            _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturRecognizer:)];
            [self addGestureRecognizer:_tapGesture];
        }
    }
    return self;
}

- (void) longPressGestureRecognizer:(UILongPressGestureRecognizer *) recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        /* if needed do some initial setup or init of views here */
        
        _priorPoint = [recognizer locationInView:self];
        _fector = self.center.x - self.frame.origin.x - _priorPoint.x;
        
        [self.superview addSubview:self];
        [self setBackColor:_textLabel.backgroundColor.copy];
        [_textLabel setBackgroundColor:[UIColor greenColor]];
        [self setBackgroundColor:_borderColor];
        
        if (self.longPressBegin != NULL)
            self.longPressBegin(self);
        
        if (_delegate && [_delegate respondsToSelector:@selector(dataGridCell:startChangeCenter:)])
            [_delegate dataGridCell:self startChangeCenter:self.center];
        
    } else if(recognizer.state == UIGestureRecognizerStateChanged) {
        /* move your views here. */
        
        CGPoint point = [recognizer locationInView:self.superview];
        CGPoint center = self.center;
        center.x = point.x + _fector;
        self.center = center;
        
        /* check posistion */
        CGFloat sx = self.frame.origin.x;
        CGFloat ex = self.frame.origin.x + self.frame.size.width;
        if (sx < 0)
            self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        else if (ex > self.superview.frame.size.width)
            self.frame = CGRectMake(self.superview.frame.size.width - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        if (self.longPressMove != NULL)
            self.longPressMove(self,self.center);
        
        if (_delegate && [_delegate respondsToSelector:@selector(dataGridCell:changeCenter:)])
            [_delegate dataGridCell:self changeCenter:self.center];
        
    } else if(recognizer.state == UIGestureRecognizerStateEnded) {
        /* else do cleanup */
        
        [_textLabel setBackgroundColor:self.backColor];
        [self setBackgroundColor:_borderColor];
        
        if (self.longPressEnd != NULL)
            self.longPressEnd(self,self.center);
        
        if (_delegate && [_delegate respondsToSelector:@selector(dataGridCell:endChangeCenter:)])
            [_delegate dataGridCell:self endChangeCenter:self.center];
    }
}

- (void) tapGesturRecognizer:(UITapGestureRecognizer *) recognizer {
    if (!_backColor)
        _backColor = [_textLabel.backgroundColor copy];
    
    _textLabel.backgroundColor = [UIColor grayColor];
    
    if (_delegate && [_delegate respondsToSelector:@selector(dataGridCell:selectText:)])
        [_delegate dataGridCell:self selectText:_textLabel.text];
    
    [self performSelector:@selector(resetColor:) withObject:_backColor afterDelay:0.2];
}

- (void) resetColor:(UIColor *) color {
    _textLabel.backgroundColor = color;
}

- (void) setText:(NSString *) text {
    [_textLabel setText:text];
}

- (void) setTextAlignment:(NSTextAlignment) align {
    [_textLabel setTextAlignment:align];
}

- (void) setTextBackgroundColor:(UIColor *) color {
    _textLabel.backgroundColor = color;
}

- (void) setFont:(UIFont *) font {
    _textLabel.font = font;
}

- (void) setBackGroundImage:(UIImage *) image {
    [_backImgView setImage:image];
}

@end