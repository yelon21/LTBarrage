//
//  LTBarrageMessageView.m
//  New
//
//  Created by yelon on 16/8/25.
//  Copyright © 2016年 yjpal. All rights reserved.
//

#import "LTBarrageMessageView.h"

@interface LTBarrageMessageView (){

    UILabel *label;
}

@end


@implementation LTBarrageMessageView

-(instancetype)initWithHeight:(CGFloat)height{

    if ([super initWithFrame:CGRectMake(0, 0, 0, height)]) {
        
        label = [[UILabel alloc]initWithFrame:self.frame];
        label.textAlignment = 1;
        [self addSubview:label];
//        self.removed = NO;
        
        label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        label.layer.cornerRadius = 5.0;
        label.layer.masksToBounds = YES;
    }
    return self;
}

- (void)resetSize{
    
    [label sizeToFit];
    
    CGFloat selfH = CGRectGetHeight(self.frame);
    
    CGRect labelRect = label.bounds;
    if (labelRect.size.height < selfH-10.0) {
        
        labelRect.size.height *= 1.5;
    }
    else{
    
        labelRect.size.height = selfH-10.0;
    }
    
    labelRect.size.width += 20.0;
    label.frame = labelRect;
    
    labelRect.size.height = selfH;
    self.frame = labelRect;
    label.center = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
}

#pragma mark setter
-(void)setText:(NSString *)text{
    
    label.text = text;
    [self resetSize];
}

-(void)setAttributedText:(NSAttributedString *)attributedText{

    label.attributedText = attributedText;
    [self resetSize];
}

-(void)setFont:(UIFont *)font{
    
    label.font = font;
    [self resetSize];
}

-(void)setTextColor:(UIColor *)textColor{

    label.textColor = textColor;
}

@end
