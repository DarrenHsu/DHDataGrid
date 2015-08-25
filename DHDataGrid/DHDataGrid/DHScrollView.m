//
//  DHScrollView.m
//  TestScrollView
//
//  Created by DH on 2014/10/25.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#define ORIGIN_X                    0
#define IMAGES_WIDTH                265
#define IMAGES_HEIGHT               44
#define DEGREES_TO_RADIANS(degrees) ((M_PI * degrees)/ 180)

#import "DHScrollView.h"
#import <QuartzCore/QuartzCore.h>

@interface DHScrollView () {
    NSInteger _currentTag;
    NSInteger _MaxTag;
    NSInteger _MinTag;
    NSInteger _totalCount;
    NSInteger _displayIndex;
    BOOL _isLayout;
    CGRect _rect;
}

@property (nonatomic, strong) NSMutableArray *visibleLabels;
@property (nonatomic, strong) NSMutableDictionary *visibleDict;
@property (nonatomic, strong) UIView *labelContainerView;

@end

@implementation DHScrollView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentTag = 0;
        _subViewSize = CGSizeMake(IMAGES_WIDTH, IMAGES_HEIGHT);
        _layoutStyle = DHScrollViewStyleY;
        _rect = frame;
        self.bounces = NO;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame layoutStyle:(DHScrollViewStyle) style {
    self = [self initWithFrame:frame];
    if (self) {
        _layoutStyle = style;
    }
    return self;
}

- (NSArray *) getAllRow {
    return [NSArray arrayWithArray:_visibleLabels];
}

- (NSArray *) getCellsWithCellIndex:(NSInteger) cindex {
    NSMutableArray *cells = [NSMutableArray new];
    for (DHDataGridHorizontalRow *row in _visibleLabels) {
        [cells addObject:row.cells[cindex]];
    }
    return cells;
}

- (LongPressBegin) getLongPressBegin {
    return NULL;
}

- (LongPressMove) getLongPressMove {
    return NULL;
}

- (LongPressEnd) getLongPressEnd {
    return NULL;
}


- (void) setDefaultStyle {
    if (_isLayout) return;
    
    _subViewSize = [_DHDataSource sizeOfViewsInScrollView:self];
    _totalCount = [_DHDataSource numberOfViewsInScrollView:self];
    CGSize size = CGSizeMake(self.bounds.size.width, _subViewSize.height * _totalCount);
    
    if (_layoutStyle == DHScrollViewStyleX)
        size = CGSizeMake(_subViewSize.width * _totalCount, self.bounds.size.height);
    
    _MinTag = 0;
    _MaxTag = -1;
    
    self.contentSize = size;
    
    _visibleLabels = [NSMutableArray new];
    _visibleDict = [NSMutableDictionary new];
    
    _labelContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    [_labelContainerView setBackgroundColor:[UIColor clearColor]];
    [_labelContainerView setUserInteractionEnabled:YES];
    
    [self addSubview:self.labelContainerView];
    [self setShowsVerticalScrollIndicator:NO];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setUserInteractionEnabled:YES];
    
    _isLayout = YES;
}

#pragma mark - Layout
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setDefaultStyle];
    
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.labelContainerView];
    CGFloat minimumVisible = _layoutStyle == DHScrollViewStyleY ? CGRectGetMinY(visibleBounds) : CGRectGetMinX(visibleBounds);
    CGFloat maximumVisible = _layoutStyle == DHScrollViewStyleY ? CGRectGetMaxY(visibleBounds) : CGRectGetMaxX(visibleBounds);
    
    if (_layoutStyle == DHScrollViewStyleY)
        [self viewFromMinY:minimumVisible toMaxY:maximumVisible];
    else
        [self viewFromMinX:minimumVisible toMaxX:maximumVisible];
}

- (void) syncCurrentIndex {
    DHDataGridHorizontalRow *lastView = [self.visibleLabels lastObject];
    DHDataGridHorizontalRow *firstView = [self.visibleLabels firstObject];
    if (lastView && firstView) {
        _MaxTag = [lastView.indexPath row];
        _MinTag = [firstView.indexPath row];
    }
}

- (CGFloat) placeNewLabelOnRight:(CGFloat) rightEdge
{
    [self syncCurrentIndex];
    _MaxTag += 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_MaxTag inSection:0];
    DHDataGridHorizontalRow *view = [self.visibleDict objectForKey:indexPath];
    if (view) {
        return CGRectGetMaxX(view.frame);
    }
    
    view = [_DHDataSource rowWithIndex:_MaxTag >= _totalCount ? _totalCount - 1 : _MaxTag scrollView:self];
    self.contentSize = CGSizeMake(view.frame.size.width, self.contentSize.height);
    [view setIndexPath:indexPath];
    [view actionProcessWithBegin:[self getLongPressBegin] move:[self getLongPressMove] end:[self getLongPressEnd]];
    
    if (_MaxTag >= _totalCount)
        view.alpha = 0.f;
    
    [self addSubview:view];
    
    _currentTag = _MaxTag;
    
    [self.visibleLabels addObject:view];
    [self.visibleDict setObject:view forKey:indexPath];
    
    CGRect frame = [view frame];
    frame.origin.x = rightEdge;
    frame.origin.y = [self.labelContainerView bounds].size.height - frame.size.height;
    [view setFrame:frame];
    
    return CGRectGetMaxX(frame);
}

- (CGFloat) placeNewLabelOnLeft:(CGFloat) leftEdge
{
    [self syncCurrentIndex];
    _MinTag -= 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_MinTag inSection:0];
    DHDataGridHorizontalRow *view = [self.visibleDict objectForKey:indexPath];
    if (view) {
        return CGRectGetMaxX(view.frame);
    }
    
    view = [_DHDataSource rowWithIndex:_MinTag < 0 ? 0 : _MinTag scrollView:self];
    self.contentSize = CGSizeMake(view.frame.size.width, self.contentSize.height);
    [view setIndexPath:indexPath];
    [view actionProcessWithBegin:[self getLongPressBegin] move:[self getLongPressMove] end:[self getLongPressEnd]];
    
    if (_MinTag < 0)
        view.alpha = 0.f;
    
    [self addSubview:view];
    
    _currentTag = _MinTag;
    
    [self.visibleLabels insertObject:view atIndex:0]; // add leftmost label at the beginning of the array
    [self.visibleDict setObject:view forKey:indexPath];
    
    CGRect frame = [view frame];
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = [self.labelContainerView bounds].size.height - frame.size.height;
    [view setFrame:frame];
    
    return CGRectGetMinX(frame);
}

- (CGFloat) placeNewLabelOnTop:(CGFloat) topEdge
{
    [self syncCurrentIndex];
    _MaxTag += 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_MaxTag inSection:0];
    DHDataGridHorizontalRow *view = [self.visibleDict objectForKey:indexPath];
    if (view) {
        return CGRectGetMaxY(view.frame);
    }
    
    view = [_DHDataSource rowWithIndex:_MaxTag >= _totalCount ? _totalCount - 1 : _MaxTag scrollView:self];
    self.contentSize = CGSizeMake(view.frame.size.width, self.contentSize.height);
    [view setIndexPath:indexPath];
    [view actionProcessWithBegin:[self getLongPressBegin] move:[self getLongPressMove] end:[self getLongPressEnd]];
    
    if (_MaxTag >= _totalCount)
        view.alpha = 0.f;
    
    [self addSubview:view];
    
    _currentTag = _MaxTag;
    
    [self.visibleLabels addObject:view]; // add rightmost label at the end of the array
    [self.visibleDict setObject:view forKey:indexPath];
    
    CGRect frame = [view frame];
    frame.origin.y = topEdge;
    [view setFrame:frame];
    
    return CGRectGetMaxY(frame);
}

- (CGFloat) placeNewLabelOnBottom:(CGFloat) bottomEdge
{
    [self syncCurrentIndex];
    _MinTag -= 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_MinTag inSection:0];
    DHDataGridHorizontalRow *view = [self.visibleDict objectForKey:indexPath];
    if (view) {
        return CGRectGetMaxY(view.frame);
    }
    
    view = [_DHDataSource rowWithIndex:_MinTag < 0 ? 0 : _MinTag scrollView:self];
    self.contentSize = CGSizeMake(view.frame.size.width, self.contentSize.height);
    [view setIndexPath:indexPath];
    [view actionProcessWithBegin:[self getLongPressBegin] move:[self getLongPressMove] end:[self getLongPressEnd]];
    
    if (_MinTag < 0)
        view.alpha = 0.f;
    
    [self addSubview:view];
    
    _currentTag = _MinTag;
    
    [self.visibleLabels insertObject:view atIndex:0];
    [self.visibleDict setObject:view forKey:indexPath];
    
    CGRect frame = [view frame];
    frame.origin.y = bottomEdge - frame.size.height;
    [view setFrame:frame];
    
    return CGRectGetMinY(frame);
}

- (void) viewFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([self.visibleLabels count] == 0)     {
        [self placeNewLabelOnRight:minimumVisibleX];
    }
    
    // add labels that are missing on right side
    DHDataGridHorizontalRow *lastView = [self.visibleLabels lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastView frame]);
    while (rightEdge < maximumVisibleX)
    {
        rightEdge = [self placeNewLabelOnRight:rightEdge];
    }
    
    // add labels that are missing on left side
    DHDataGridHorizontalRow *firstView = self.visibleLabels[0];
    CGFloat leftEdge = CGRectGetMinX([firstView frame]);
    while (leftEdge > minimumVisibleX)
    {
        leftEdge = [self placeNewLabelOnLeft:leftEdge];
    }
    
    // remove labels that have fallen off right edge
    lastView = [self.visibleLabels lastObject];
    while ([lastView frame].origin.x > maximumVisibleX)
    {
        [lastView removeFromSuperview];
        [self.visibleDict removeObjectForKey:lastView.indexPath];
        [self.visibleLabels removeLastObject];
        lastView = [self.visibleLabels lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstView = self.visibleLabels[0];
    while (CGRectGetMaxX([firstView frame]) < minimumVisibleX)
    {
        [firstView removeFromSuperview];
        [self.visibleDict removeObjectForKey:firstView.indexPath];
        [self.visibleLabels removeObjectAtIndex:0];
        firstView = self.visibleLabels[0];
    }
}

- (void) viewFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([self.visibleLabels count] == 0)
    {
        [self placeNewLabelOnTop:minimumVisibleY];
    }
    
    // add labels that are missing on right side
    DHDataGridHorizontalRow *lastView = [self.visibleLabels lastObject];
    CGFloat topEdge = CGRectGetMaxY([lastView frame]);
    while (topEdge < maximumVisibleY)
    {
        topEdge = [self placeNewLabelOnTop:topEdge];
    }
    
    // add labels that are missing on left side
    DHDataGridHorizontalRow *firstView = self.visibleLabels[0];
    CGFloat bottomEdge = CGRectGetMinY([firstView frame]);
    while (bottomEdge > minimumVisibleY)
    {
        bottomEdge = [self placeNewLabelOnBottom:bottomEdge];
    }
    
    // remove labels that have fallen off right edge
    lastView = [self.visibleLabels lastObject];
    while ([lastView frame].origin.y > maximumVisibleY)
    {
        [lastView removeFromSuperview];
        [self.visibleDict removeObjectForKey:lastView.indexPath];
        [self.visibleLabels removeLastObject];
        lastView = [self.visibleLabels lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstView = self.visibleLabels[0];
    while (CGRectGetMaxY([firstView frame]) < minimumVisibleY)
    {
        [firstView removeFromSuperview];
        [self.visibleDict removeObjectForKey:firstView.indexPath];
        [self.visibleLabels removeObjectAtIndex:0];
        firstView = self.visibleLabels[0];
    }
}

@end