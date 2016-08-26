//
//  LTBarrage.h
//  New
//
//  Created by yelon on 16/8/25.
//  Copyright © 2016年 yjpal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTBarrage : UIView

@property(nonatomic,strong)IBInspectable UIColor *textColor;
@property(nonatomic,strong)IBInspectable UIFont  *textFont;
@property(nonatomic,assign)IBInspectable CGFloat speed;
@property(nonatomic,assign)IBInspectable CGFloat separateSpace;
@property(nonatomic,assign)IBInspectable CGFloat preRowHeight;

@property(nonatomic,strong)IBInspectable void(^WatingMessageCount)(LTBarrage *ltBarrage, NSUInteger count);

@property(nonatomic,strong)IBInspectable void(^WatingMessagePageCount)(LTBarrage *ltBarrage, NSUInteger count);
@property(nonatomic,assign,readonly) BOOL isPlaying;
- (void)reloadData;
- (void)start;
- (void)pause;

- (void)addMessage:(NSString *)message;
- (void)addMessages:(NSArray *)messages;

@end
