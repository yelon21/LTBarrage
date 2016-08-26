//
//  LTBarrage.m
//  New
//
//  Created by yelon on 16/8/25.
//  Copyright © 2016年 yjpal. All rights reserved.
//

#import "LTBarrage.h"
#import "LTBarrageMessageView.h"

@interface LTBarrage (){

    NSMutableArray *messgePool;
    
    NSUInteger rowCount;
    CGFloat rowHeight;
}
@property(atomic,strong) NSMutableArray *usingRowKeys;
@property(nonatomic,assign,readwrite) BOOL isPlaying;
@end

@implementation LTBarrage
@synthesize textColor = _textColor;
@synthesize speed = _speed;
@synthesize textFont = _textFont;
@synthesize preRowHeight = _preRowHeight;

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{
    
    [self setup];
}

-(void)layoutSubviews{

    [super layoutSubviews];
    [self calcuteRowCount];
//    [self clearScreenMessage];
}

- (void)setup{

    self.isPlaying = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    messgePool = [[NSMutableArray alloc]init];
    self.usingRowKeys = [[NSMutableArray alloc]init];
    
    [self calcuteRowCount];
}

- (void)addMessage:(NSString *)message{

    [messgePool addObject:message];
    [self loadNewMessage];
}
- (void)addMessages:(NSArray *)messages{

    [messgePool addObjectsFromArray:messages];
    [self loadNewMessage];
}

-(void)reloadData{

    [messgePool removeAllObjects];
    [self start];
}

-(void)start{

    self.isPlaying = YES;
    
    [self loadNewMessage];
}

-(void)pause{

    self.isPlaying = NO;
}

-(void)clearScreenMessage{
    
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)calcuteRowCount{

    CGFloat selfH = CGRectGetHeight(self.frame);
    
    CGFloat rowH = self.preRowHeight;
    NSInteger preRowCount = selfH/rowH;
    
    NSAssert(preRowCount>0, ([NSString stringWithFormat:@"preRowCount:%@，小于1",@(preRowCount)]));
    
    rowHeight = selfH/preRowCount;
    rowCount = selfH/rowHeight;
}

- (void)loadNewMessage{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.isPlaying&&[messgePool count]>0) {
            
            for (NSUInteger index = 0;index<rowCount;index++) {
                
                if (![self.usingRowKeys containsObject:@(index)]) {
                    
                    NSString *newMsg = [messgePool firstObject];
                    [messgePool removeObjectAtIndex:0];
                    NSLog(@"newMsg=%@",newMsg);
                    [self addNewMessage:newMsg toRow:index];
                    
                    [self blockMessageCount];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self loadNewMessage];
                    });
                    return;
                }
            }
        }
        else{
            
            [self blockMessageCount];
        }
    });
}

- (void)blockMessageCount{

    if (self.WatingMessageCount) {
        self.WatingMessageCount(self,[messgePool count]);
    }
    
    if (self.WatingMessagePageCount) {
        
        NSUInteger count = [messgePool count];
        
        if (count%rowCount==0) {
            
            self.WatingMessagePageCount(self,count/rowCount);
        }
    }
}

- (void)addNewMessage:(NSString *)message toRow:(NSUInteger)rowIndex{

    LTBarrageMessageView *messageViegw = [[LTBarrageMessageView alloc]initWithHeight:rowHeight];
    messageViegw.rowIndex = rowIndex;
    
    if ([message isKindOfClass:[NSString class]]) {
        
        messageViegw.text = message;
    }
    else if ([message isKindOfClass:[NSAttributedString class]]) {
        
        messageViegw.attributedText = message;
    }
    else{
    
        return;
    }
    messageViegw.font = self.textFont;
    messageViegw.textColor = self.textColor;

    CGFloat selfW = CGRectGetWidth(self.frame);
    
    CGRect rect = messageViegw.frame;
    rect.origin.x = selfW + self.separateSpace;
    rect.origin.y = rowIndex * rowHeight;
    messageViegw.frame = rect;
    
    [self addSubview:messageViegw];
    
    [self.usingRowKeys addObject:@(rowIndex)];
    
    [self startAnimation:messageViegw];
}

- (void)startAnimation:(LTBarrageMessageView *)messageViegw{
    
    CGFloat selfW = CGRectGetWidth(self.bounds);
    CGFloat width = CGRectGetWidth(messageViegw.bounds);
    
    CGFloat time = 3.0;
    if (selfW-width/3.0<200.0) {
        
        time = 200.0/self.speed;
    }
    else{
    
        time = (selfW - width/3.0)/self.speed;
    }
    
    CGFloat newSpeed = (self.separateSpace+selfW+width)/time;
    
    CGFloat rightInTime = (width+self.separateSpace)/newSpeed;
    CGFloat rightOutTime = selfW/newSpeed;
    CGFloat totalTime = rightInTime+rightOutTime;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(floor(totalTime * NSEC_PER_SEC))), dispatch_get_main_queue(), ^{
        
        [self.usingRowKeys removeObject:@(messageViegw.rowIndex)];
        [self loadNewMessage];
    });
    
    [UIView animateWithDuration:rightInTime+rightOutTime
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         CGRect rect = messageViegw.frame;
                         rect.origin.x = -width;
                         messageViegw.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         
                         [messageViegw removeFromSuperview];
                     }];
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    //1.获取 当前设备 实例
    UIDevice *device = [UIDevice currentDevice] ;
    
    switch (device.orientation) {
            
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:{

            [self calcuteRowCount];
            [self clearScreenMessage];
            break;
        }
        case UIDeviceOrientationFaceUp:
            break;
        case UIDeviceOrientationFaceDown:
            break;
        case UIDeviceOrientationUnknown:
            break;
        default:
            NSLog(@"无法辨识");
            break;
    }
}
#pragma mark setter getter
-(void)setTextColor:(UIColor *)textColor{

    if (_textColor != textColor) {
        
        _textColor = textColor;
    }
}

-(UIColor *)textColor{

    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

-(CGFloat)speed{

    if (_speed<40.0) {
        _speed = 40.0;
    }
    return _speed;
}

-(UIFont *)textFont{

    if (!_textFont) {
        _textFont = [UIFont systemFontOfSize:14.0];
    }
    return _textFont;
}

-(CGFloat)separateSpace{

    if (_separateSpace<0.0) {
        _separateSpace = 0.0;
    }
    return _separateSpace;
}

-(void)setPreRowHeight:(CGFloat)preRowHeight{

    if (preRowHeight>30.0 && _preRowHeight != preRowHeight) {
        
        _preRowHeight = preRowHeight;
        [self calcuteRowCount];
    }
}

-(CGFloat)preRowHeight{

    if (_preRowHeight<40.0) {
        _preRowHeight = 40.0;
    }
    return _preRowHeight;
}

@end
