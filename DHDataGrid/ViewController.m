//
//  ViewController.m
//  DHDataGrid
//
//  Created by Dareen Hsu on 8/25/15.
//  Copyright (c) 2015 D.H. All rights reserved.
//

#import "ViewController.h"
#import "DHDataGridView.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *displayView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    int dataCount = 100;
    NSArray *leftHeaders = @[@"Title1",@"Title2"];
    NSArray *rightHeaders = @[@"TitleA",@"TitleB",@"TitleC",@"rTitleD",@"rTitleE"];

    NSArray *lContentKeys = @[@"lkey1",@"lkey2"];
    NSArray *rContentKeys = @[@"rkey1",@"rkey2",@"rkey3",@"rkey4",@"rkey5"];

    NSMutableArray *leftContents = [NSMutableArray new];
    NSMutableArray *rightContents = [NSMutableArray new];

    for (int i = 0 ; i < dataCount ; i++) {
        for (NSInteger j = 0 ; j < lContentKeys.count ; j++) {
            NSDictionary *dict = @{@"lkey1":[NSString stringWithFormat:@"a%zd",j],
                                   @"lkey2":[NSString stringWithFormat:@"b%zd",j]};
            [leftContents addObject:dict];
        }

        for (NSInteger j = 0 ; j < rContentKeys.count ; j++) {
            NSDictionary *dict = @{@"rkey1":[NSString stringWithFormat:@"d%zd",j],
                                   @"rkey2":[NSString stringWithFormat:@"e%zd",j],
                                   @"rkey3":[NSString stringWithFormat:@"f%zd",j],
                                   @"rkey3":[NSString stringWithFormat:@"g%zd",j],
                                   @"rkey4":[NSString stringWithFormat:@"h%zd",j],};
            [rightContents addObject:dict];
        }
    }

    DHDataGridView *dataGrid = [[DHDataGridView alloc] initWithFrame:self.view.bounds
                                                        headerHeight:40
                                                          cellHeight:40
                                                     leftHeaderCName:leftHeaders
                                                      leftSideWeight:120
                                                     leftHeaderNames:lContentKeys
                                                        leftContents:leftContents
                                                    rightHeaderCName:[NSMutableArray arrayWithArray:rightHeaders]
                                                 rightSideCellWeight:100
                                                    rightHeaderNames:[NSMutableArray arrayWithArray:rContentKeys]
                                                       rightContents:rightContents
                                                    hiddenIndexArray:nil];

    [_displayView addSubview:dataGrid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
