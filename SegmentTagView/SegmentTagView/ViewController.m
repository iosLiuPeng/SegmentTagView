//
//  ViewController.m
//  SegmentTagView
//
//  Created by 刘鹏i on 2019/1/14.
//  Copyright © 2019 wuhan.musjoy. All rights reserved.
//

#import "ViewController.h"
#import "SegmentTagView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet SegmentTagView *segmentTagView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segmentTagView.arrTitle = @[@"测", @"测试", @"测", @"测试文案", @"测试文案测试文案测试文案", @"测试文案测试文案", @"测案", @"测", @"测试晚安文案", @"测试文案测试文案测试文案"];
    //, @"测试晚安文案", @"测试测试晚安文案晚安文案", @"测安文案", @"测案", @"测", @"测试晚安文案", @"测试测试晚安文案晚安文案"
}


@end
