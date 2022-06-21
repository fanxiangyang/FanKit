//
//  FanTextField.m
//  Brain
//
//  Created by 向阳凡 on 2018/7/2.
//  Copyright © 2018年 向阳凡. All rights reserved.
//

#import "FanTextField.h"

@implementation FanTextField

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.leftSpace=10;
        self.rightSpace=0;
    }
    return self;
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect leftRect = [super leftViewRectForBounds:bounds];
    leftRect.origin.x +=_leftViewSpace;
    return leftRect;
}
-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightRect=[super rightViewRectForBounds:bounds];
    rightRect.origin.x -= _rightViewSpace;
    return rightRect;
}
- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super textRectForBounds:bounds];
    
    textRect.origin.x += _leftSpace;
    textRect.size.width-=(_leftSpace+_rightSpace);
    return textRect;
}
-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect textRect = [super editingRectForBounds:bounds];
    
    textRect.origin.x += _leftSpace;
    textRect.size.width-=(_leftSpace+_rightSpace);
    return textRect;
}
#pragma mark  - 添加下划线
-(UIImageView *)lineImgView{
    if (_lineImgView==nil) {
        _lineImgView = [[UIImageView alloc]init];
        [self addSubview:_lineImgView];
    }
    return _lineImgView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
