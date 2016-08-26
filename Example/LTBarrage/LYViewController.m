//
//  LYViewController.m
//  LTBarrage
//
//  Created by yelon21 on 08/26/2016.
//  Copyright (c) 2016 yelon21. All rights reserved.
//

#import "LYViewController.h"
#import "LTBarrage.h"
@interface LYViewController ()

@property (weak, nonatomic) IBOutlet LTBarrage *barrageView;
@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.barrageView.speed = 50.0;
    self.barrageView.textColor = [UIColor whiteColor];
    
    NSData *data = [@"<html>http://www.baidu.com</html><img src=\"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png\" height=\"20\" width=\"40\">" dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.barrageView setWatingMessagePageCount:^(LTBarrage *ltBarrageView,NSUInteger count) {
        
        NSLog(@"count=%@",@(count));
        if (count<2) {
            
            NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
            
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithData:data
                                                                                    options:options documentAttributes:nil
                                                                                      error:nil];
            [ltBarrageView addMessages:@[@"你瞅啥？",
                                         @"瞅你咋地！！！！！！！！",
                                         @"你再瞅试试！！",
                                         @"我就瞅了，咋地吧！！",
                                         @"傻B，我也瞅你",
                                         @"。。。",
                                         @"两个傻B的对话",
                                         att]];
        }
        
    }];
}

- (IBAction)loadNew:(id)sender {
    
    [self.barrageView start];
}

- (IBAction)pause:(id)sender {
    
    [self.barrageView pause];
}

- (IBAction)reloadData:(id)sender {
    
    [self.barrageView reloadData];
}

@end
