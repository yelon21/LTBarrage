//
//  LTBarrageMessageView.h
//  New
//
//  Created by yelon on 16/8/25.
//  Copyright © 2016年 yjpal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTBarrageMessageView : UIView

@property(nonatomic,assign)             NSInteger  rowIndex;
@property(nonnull, nonatomic,assign)         NSString   *text;
@property(nullable, nonatomic,assign)   NSAttributedString *attributedText;
@property(null_resettable,nonatomic,assign)  UIFont     *font;
@property(null_resettable,nonatomic,assign)  UIColor    *textColor;

//@property(nonatomic,assign) BOOL  removed;

-(_Nonnull instancetype)initWithHeight:(CGFloat)height;
@end
