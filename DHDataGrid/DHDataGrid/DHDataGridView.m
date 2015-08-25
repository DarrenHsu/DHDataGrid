//
//  DHDataGridView.m
//  TestScrollView
//
//  Created by DH on 2014/10/23.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHDataGridView.h"
#import "DHDataGridLeftSideView.h"
#import "DHDataGridRightSideView.h"
#import "DHDataGridLeftHeaderView.h"
#import "DHDataGridRightHeaderView.h"

@import QuartzCore;

@interface DHDataGridView () <DHScrollViewDataSource,DHDataGridCellDelegate,UIScrollViewDelegate> {
    NSInteger _moveIndex;
    NSInteger _changeIndex;
}

@property (nonatomic, strong) DHDataGridLeftSideView *lSideView;
@property (nonatomic, strong) DHDataGridRightSideView *rSideView;
@property (nonatomic, strong) DHDataGridLeftHeaderView *lHeaderView;
@property (nonatomic, strong) DHDataGridRightHeaderView *rHeaderView;

@property (nonatomic, strong) NSMutableArray *faildGestures;
@property (nonatomic, strong) NSArray *catchCells;

@property (nonatomic, strong) NSMutableArray *rHeaderCells;
@property (nonatomic, strong) NSMutableDictionary *allIndexDict;
@property (nonatomic, strong) NSArray *hiddenIndexArray;

@end

@implementation DHDataGridView

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultStyle];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame headerHeight:(CGFloat) hheight cellHeight:(CGFloat) cheight leftHeaderCName:(NSArray *) lcnames leftSideWeight:(CGFloat) lweight leftHeaderNames:(NSArray *) lhnames leftContents:(NSArray *) lcontents rightHeaderCName:(NSMutableArray *) rcnames rightSideCellWeight:(CGFloat) rweight rightHeaderNames:(NSMutableArray *) rhnames rightContents:(NSMutableArray *) rcontents hiddenIndexArray:(NSArray *) harray{
    self = [self initWithFrame:frame];
    if (self) {
        _cellHeight = cheight;
        _leftHeaderCNames = lcnames;
        _rightHeaderCNames = rcnames;

        _hiddenIndexArray = harray;

        _leftSideWeight = lweight;
        _leftHeaderNames = lhnames;
        _leftContents = lcontents;

        _headerHeight = hheight;
        _cellHeight = hheight;

        _rightCellWeight = rweight;
        _rightHeaderNames = rhnames;
        _rightContents = rcontents;

        self.backgroundColor = [UIColor clearColor];
        self.faildGestures = [NSMutableArray new];
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
    [self layoutContentWithRect:rect];
}

- (void) setGestureRecognizerToFail:(UIGestureRecognizer *) gesture {
    [_faildGestures addObject:gesture];
}

- (void) setDefaultStyle {
    _rHeaderCells = [NSMutableArray new];
    _allIndexDict = [NSMutableDictionary new];
    
    _headerColor = [UIColor grayColor];
    _headerFontColor = [UIColor blackColor];
    _headerFount = [UIFont boldSystemFontOfSize:14.f];
    
    _headerHeight = 44.f;
    _cellHeight = 35.f;
    _leftSideWeight = 150.f;
    _rightCellWeight = 180.f;
    
    _contentColor = [UIColor clearColor];
    _contentFount = [UIFont systemFontOfSize:14.f];
    _contentFontColor = [UIColor darkGrayColor];
}

- (void) layoutContentWithRect:(CGRect) rect {
    _lSideView = [[DHDataGridLeftSideView alloc] initWithFrame:CGRectMake(0, _headerHeight, _leftSideWeight, rect.size.height - _headerHeight) layoutStyle:DHScrollViewStyleY];
    [_lSideView setDHDataSource:self];
    [_lSideView setDelegate:self];
    
    _rSideView = [[DHDataGridRightSideView alloc] initWithFrame:CGRectMake(_leftSideWeight, _headerHeight, rect.size.width - _leftSideWeight, rect.size.height - _headerHeight) layoutStyle:DHScrollViewStyleY];
    [_rSideView setDHDataSource:self];
    [_rSideView setDelegate:self];

    _lHeaderView = [[DHDataGridLeftHeaderView alloc] initWithFrame:CGRectMake(0, 0, _leftSideWeight, _headerHeight)];
    for (int i = 0 ; i < _leftHeaderCNames.count ; i++) {
        NSString *str = _leftHeaderCNames[i];
        DHDataGridCell *cell = [[DHDataGridCell alloc] initWithFrame:CGRectMake(i * _leftSideWeight / _leftHeaderCNames.count , 0, _leftSideWeight / _leftHeaderCNames.count, _headerHeight)];
        [cell setTextBackgroundColor:_headerColor];
        [cell setTextAlignment:NSTextAlignmentCenter];
        [cell setText:str];
        [_lHeaderView addSubview:cell];
    }
    
    _rHeaderView = [[DHDataGridRightHeaderView alloc] initWithFrame:CGRectMake(_leftSideWeight, 0, rect.size.width - _leftSideWeight, _headerHeight) layoutStyle:DHScrollViewStyleX];
    [_rHeaderView setDHDataSource:self];
    [_rHeaderView setDelegate:self];

    [self addSubview:_lHeaderView];
    [self addSubview:_rHeaderView];
    [self addSubview:_lSideView];
    [self addSubview:_rSideView];
    
    for (UIGestureRecognizer *ges in _lSideView.gestureRecognizers) {
        for (UIGestureRecognizer *gesture in _faildGestures) {
            [gesture requireGestureRecognizerToFail:ges];
        }
    }
    
    for (UIGestureRecognizer *ges in _rSideView.gestureRecognizers) {
        for (UIGestureRecognizer *gesture in _faildGestures) {
            [gesture requireGestureRecognizerToFail:ges];
        }
    }
    
    for (UIGestureRecognizer *ges in _lHeaderView.gestureRecognizers) {
        for (UIGestureRecognizer *gesture in _faildGestures) {
            [gesture requireGestureRecognizerToFail:ges];
        }
    }
    
    for (UIGestureRecognizer *ges in _rHeaderView.gestureRecognizers) {
        for (UIGestureRecognizer *gesture in _faildGestures) {
            [gesture requireGestureRecognizerToFail:ges];
        }
    }
    
    _lHeaderView.backgroundColor = [UIColor clearColor];
    _lSideView.backgroundColor = [UIColor clearColor];
    _rHeaderView.backgroundColor = [UIColor clearColor];
    _rSideView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Draw Rows Methods
- (DHDataGridHorizontalRow *) getLeftContentViewWithTag:(NSInteger) index {
    DHDataGridHorizontalRow *row = [[DHDataGridHorizontalRow alloc] init];
    row.backgroundColor = [UIColor clearColor];
    row.tag = index;
    
    NSInteger count = _leftHeaderNames.count;
    
    CGFloat width = _leftSideWeight / count;
    
    for (int i = 0 ; i < count ; i++) {
        NSDictionary *dict = [_leftContents objectAtIndex:index];
        DHDataGridCell *cell = [[DHDataGridCell alloc] initWithFrame:CGRectMake(0, 0, width, _cellHeight)];
        if ([dict objectForKey:_leftHeaderNames[i]] != [NSNull null]) {
            [cell setText:[dict objectForKey:_leftHeaderNames[i]]];
            [cell setTextAlignment:NSTextAlignmentCenter];
        }
        [cell setTextBackgroundColor:[UIColor whiteColor]];
        [row addVisableCell:cell];
        [row showVisableCell:cell];
    }

    return row;
}

- (DHDataGridHorizontalRow *) getRightHeaderViewWithTag:(NSInteger) index {
    DHDataGridHorizontalRow *row = [[DHDataGridHorizontalRow alloc] init];
    row.backgroundColor = [UIColor clearColor];
    row.tag = index;
    
    NSInteger count = _rightHeaderCNames.count;
    
    CGFloat width = _rightCellWeight;
    
    for (int i = 0 ; i < count ; i++) {
        DHDataGridCell *cell = [[DHDataGridCell alloc] initWithFrame:CGRectMake(0, 0, width, _headerHeight) cellType:DHDataGridCellTypeMove];
        for (UIGestureRecognizer *gesture in _faildGestures)
            [gesture requireGestureRecognizerToFail:cell.longPressGesture];
        
        [cell setDelegate:self];
        [cell setTextBackgroundColor:_headerColor];
        [cell setText:_rightHeaderCNames[i]];
        [cell setTextAlignment:NSTextAlignmentCenter];
        [cell setCellIndex:i];
        
        /* set display position */
        NSNumber *kNumber = [NSNumber numberWithInt:i];
        if (![_allIndexDict objectForKey:kNumber]) {
            [_allIndexDict setObject:cell forKey:kNumber];
            
            if (![_hiddenIndexArray containsObject:kNumber])
                [_rHeaderCells addObject:cell];
        }
        
        if (![_hiddenIndexArray containsObject:kNumber]) {
            [row addVisableCell:cell];
            [row showVisableCell:cell];
        }
    }
    
    return row;
}

- (DHDataGridHorizontalRow *) getRightContentViewWithTag:(NSInteger) index {
    DHDataGridHorizontalRow *row = [[DHDataGridHorizontalRow alloc] init];
    row.backgroundColor = [UIColor clearColor];
    row.tag = index;
    
    NSInteger count = _rightHeaderNames.count;
    
    CGFloat width = _rightCellWeight;
    
    for (int i = 0 ; i < count ; i++) {
        if (index == -1) continue;

        NSDictionary *dict = [_rightContents objectAtIndex:index];
        
        DHDataGridCell *cell = [[DHDataGridCell alloc] initWithFrame:CGRectMake(0, 0, width, _cellHeight) cellType:DHDataGridCellTypeTap];
        if ([dict objectForKey:_rightHeaderNames[i]] != [NSNull null]) {
            [cell setText:[dict objectForKey:_rightHeaderNames[i]]];
            [cell setTextAlignment:NSTextAlignmentRight];
        }
        
        [cell setDelegate:self];
        
        /* control color */
        if (index % 2 == 0)
            [cell setTextBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
        else
            [cell setTextBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
       
        NSNumber *kNumber = [NSNumber numberWithInt:i];
        if (![_hiddenIndexArray containsObject:kNumber]) {
            [row addVisableCell:cell];
            [row showVisableCell:cell];
        }
    }

    return row;
}

#pragma mark - UIScrollViewDelegate Methods
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _rSideView) {
        [_lSideView setContentOffset:CGPointMake(_lSideView.contentOffset.x, scrollView.contentOffset.y)];
        [_rHeaderView setContentOffset:CGPointMake(scrollView.contentOffset.x, _rHeaderView.contentOffset.y)];
    }else if(scrollView == _lSideView) {
        [_rSideView setContentOffset:CGPointMake(_rSideView.contentOffset.x, scrollView.contentOffset.y)];
    }else if(scrollView == _rHeaderView) {
        [_rSideView setContentOffset:CGPointMake(scrollView.contentOffset.x, _rSideView.contentOffset.y)];
    }
}

#pragma mark - DHScrollViewDataSource Methods
- (NSInteger) numberOfViewsInScrollView:(DHScrollView *)scrollView {
    if (scrollView == _rHeaderView)
        return 1;
    else
        return _leftContents.count;
}

- (CGSize) sizeOfViewsInScrollView:(DHScrollView *)scrollView {
    if (scrollView == _rHeaderView)
        return CGSizeMake(150 * _rightHeaderNames.count, _headerHeight);
    else
        return CGSizeMake(_cellHeight, _cellHeight);
}

- (DHDataGridHorizontalRow *) rowWithIndex:(NSInteger) index scrollView:(DHScrollView *) scrollView {
    if (scrollView == _lSideView) {
        return [self getLeftContentViewWithTag:index];
    }else if(scrollView == _rSideView) {
        return [self getRightContentViewWithTag:index];
    } else {
        return [self getRightHeaderViewWithTag:index];
    }
}

#pragma mark - DHDataGridCellDelegate Methods
- (void) dataGridCell:(DHDataGridCell *) cell startChangeCenter:(CGPoint) point {
    _moveIndex = [_rHeaderCells indexOfObject:cell];
    _catchCells = [_rSideView getCellsWithCellIndex:_moveIndex];
    for (DHDataGridCell *cell in _catchCells)
        [cell.superview bringSubviewToFront:cell];
}

- (void) dataGridCell:(DHDataGridCell *) cell changeCenter:(CGPoint) point {
    /* move cell of right content side */
    for (DHDataGridCell *cell in _catchCells) {
        cell.center = CGPointMake(point.x, cell.center.y);
    }
    
    DHDataGridCell *changeCell = [self getNearCellWithCell:cell];
    if (changeCell) {
        _moveIndex = [_rHeaderCells indexOfObject:cell];
        _changeIndex = [_rHeaderCells indexOfObject:changeCell];
        
        /* switch position */
        CGRect frame = changeCell.frame;
        frame.origin.x = _moveIndex * changeCell.frame.size.width;
        changeCell.frame = frame;

        /* switch collection */
        [_rHeaderCells setObject:cell atIndexedSubscript:_changeIndex];
        [_rHeaderCells setObject:changeCell atIndexedSubscript:_moveIndex];
        
        /* switch cell of right content side */
        for (DHDataGridHorizontalRow *srow in [_rSideView getAllRow]) {
            DHDataGridCell *sccell = [srow getCellWithIndex:_changeIndex];
            DHDataGridCell *smcell = [srow getCellWithIndex:_moveIndex];
            
            /* switch position */
            CGRect sframe = sccell.frame;
            sframe.origin.x = _moveIndex * sccell.frame.size.width;
            sccell.frame = sframe;
            
            [srow setCell:sccell index:_moveIndex];
            [srow setCell:smcell index:_changeIndex];
        }
        
        /* call delegate method  */
        if (_delegate && [_delegate respondsToSelector:@selector(dataGridView:moveIndex:changeIndex:)])
            [_delegate dataGridView:self moveIndex:cell.cellIndex changeIndex:changeCell.cellIndex];
        
        /* change data source sort */
        NSString *moveName = [_rightHeaderNames objectAtIndex:cell.cellIndex];
        NSString *changeName = [_rightHeaderNames objectAtIndex:changeCell.cellIndex];
        
        NSString *moveCName = [_rightHeaderCNames objectAtIndex:cell.cellIndex];
        NSString *changeCName = [_rightHeaderCNames objectAtIndex:changeCell.cellIndex];
        
        NSInteger tempCellIndex = cell.cellIndex;
        cell.cellIndex = changeCell.cellIndex;
        changeCell.cellIndex = tempCellIndex;
        
        [_rightHeaderNames setObject:moveName atIndexedSubscript:cell.cellIndex];
        [_rightHeaderNames setObject:changeName atIndexedSubscript:changeCell.cellIndex];
        
        [_rightHeaderCNames setObject:moveCName atIndexedSubscript:cell.cellIndex];
        [_rightHeaderCNames setObject:changeCName atIndexedSubscript:changeCell.cellIndex];
    }
}

- (void) dataGridCell:(DHDataGridCell *) cell endChangeCenter:(CGPoint) point {
    _moveIndex = [_rHeaderCells indexOfObject:cell];
    
    /* switch position */
    CGRect frame = cell.frame;
    frame.origin.x = _moveIndex * cell.frame.size.width;
    cell.frame = frame;
    
    /* switch cell of right content side */
    for (DHDataGridHorizontalRow *srow in [_rSideView getAllRow]) {
        DHDataGridCell *scell = [srow getCellWithIndex:_moveIndex];
        
        /* switch position */
        CGRect sframe = scell.frame;
        sframe.origin.x = _moveIndex * scell.frame.size.width;
        scell.frame = sframe;
        
        [srow setCell:scell index:_moveIndex];
    }
    
    _catchCells = nil;
}

- (void) dataGridCell:(DHDataGridCell *)cell selectText:(NSString *)text {
    if (_delegate && [_delegate respondsToSelector:@selector(dataGridView:selectValue:)])
        [_delegate dataGridView:self selectValue:text];
}

- (DHDataGridCell *) getNearCellWithCell:(DHDataGridCell *) cell {
    NSInteger cellIndex = [_rHeaderCells indexOfObject:cell];
    for (int i = 0 ; i < _rHeaderCells.count ; i++) {
        DHDataGridCell *nearCell = _rHeaderCells[i];
        
        if (cell == nearCell)
            continue;
        
        CGFloat sx = nearCell.frame.origin.x;
        CGFloat ex = nearCell.frame.origin.x + nearCell.frame.size.width;
        CGFloat cx = nearCell.center.x;
        if (cellIndex < i) {
            CGFloat fx = cell.frame.origin.x + cell.frame.size.width;
            if (fx > cx && fx < ex)
                return nearCell;
            
        }else if (cellIndex > i) {
            CGFloat fx = cell.frame.origin.x;
            if (fx < cx && fx > sx)
                return nearCell;
        }
    }

    return nil;
}

@end