//
//  FanLockNodeView.m
//  
//
//  Created by 向阳凡 on 15/7/2.
//
//

#import "FanLockNodeView.h"

@implementation FanLockNodeView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.outlineLayer];
        [self.layer addSublayer:self.innerCircleLayer];
        self.nodeViewState = FanLockNodeViewStateNormal;
    }
    return self;
}
-(void)setNodeViewState:(FanLockNodeViewState)nodeViewState
{
    _nodeViewState = nodeViewState;
    switch (_nodeViewState) {
        case FanLockNodeViewStateNormal:
            [self setStatusToNormal];
            break;
        case FanLockNodeViewStateSelected:
            [self setStatusToSelected];
            break;
        case FanLockNodeViewStateWarning:
            [self setStatusToWarning];
            break;
        case FanLockNodeViewStateSuccess:
            [self setStatusToSuccess];
        default:
            break;
    }
}
-(UIColor *)strokeColor{
    if (_strokeColor==nil) {
        _strokeColor=[UIColor colorWithRed:0 green:170/255.0 blue:1 alpha:1];
    }
    return _strokeColor;
}
-(void)setStatusToNormal
{
    self.outlineLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.innerCircleLayer.fillColor = [UIColor clearColor].CGColor;
}

-(void)setStatusToSelected
{
    self.outlineLayer.strokeColor = self.strokeColor.CGColor;
    self.innerCircleLayer.fillColor = self.strokeColor.CGColor;
}

-(void)setStatusToWarning
{
    self.outlineLayer.strokeColor = [UIColor redColor].CGColor;
    self.innerCircleLayer.fillColor = [UIColor redColor].CGColor;
    
}
-(void)setStatusToSuccess
{
    self.outlineLayer.strokeColor = self.strokeColor.CGColor;
    self.innerCircleLayer.fillColor = self.strokeColor.CGColor;
    
}
-(void)layoutSubviews
{
    self.outlineLayer.frame = self.bounds;
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    self.outlineLayer.path = outlinePath.CGPath;
    
    CGRect frame = self.bounds;
    CGFloat width = frame.size.width / 3;
    self.innerCircleLayer.frame = CGRectMake(width, width, width, width);
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:self.innerCircleLayer.bounds];
    self.innerCircleLayer.path = innerPath.CGPath;
    
}

-(CAShapeLayer *)outlineLayer
{
    if (_outlineLayer == nil) {
        _outlineLayer = [[CAShapeLayer alloc] init];
        _outlineLayer.strokeColor = self.strokeColor.CGColor;
        _outlineLayer.lineWidth = 1.0f;
        _outlineLayer.fillColor  = [UIColor clearColor].CGColor;
    }
    return _outlineLayer;
}

-(CAShapeLayer *)innerCircleLayer
{
    if (_innerCircleLayer == nil) {
        _innerCircleLayer = [[CAShapeLayer alloc] init];
        _innerCircleLayer.strokeColor = [UIColor clearColor].CGColor;
        _innerCircleLayer.lineWidth = 1.0f;
        _innerCircleLayer.fillColor  = self.strokeColor.CGColor;
    }
    return _innerCircleLayer;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
