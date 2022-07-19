//
//  FanGestureView.m
//  
//
//  Created by 向阳凡 on 15/7/2.
//
//

#import "FanGesturePasswordView.h"

@interface FanGesturePasswordView()

@end

@implementation FanGesturePasswordView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    [self.layer addSublayer:self.polygonalLineLayer];
    
    _nodeViewArray=[[NSMutableArray alloc]initWithCapacity:9];
    for (int i=0; i<9; i++) {
        FanLockNodeView *nodeView=[[FanLockNodeView alloc]init];
        nodeView.tag=i;
        [self addSubview:nodeView];
        [_nodeViewArray addObject:nodeView];
    }
    _selectedNodeViewArray=[[NSMutableArray alloc]initWithCapacity:9];
    _pointArray=[[NSMutableArray alloc]initWithCapacity:9];
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
    self.viewState=FanLockNodeViewStateNormal;
    [self cleanNodes];
}
/**
 *  刷新节点，重置节点
 */
-(void)cleanNodes{
    [self.nodeViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        FanLockNodeView *nodeView=(FanLockNodeView *)obj;
        nodeView.nodeViewState=FanLockNodeViewStateNormal;
    }];
    [self.selectedNodeViewArray removeAllObjects];
    [self.pointArray removeAllObjects];
    self.polygonalLinePath=[UIBezierPath new];
    self.polygonalLineLayer.strokeColor=self.fan_LineColor.CGColor;
    self.polygonalLineLayer.path=self.polygonalLinePath.CGPath;
}
#pragma mark - panGesture
/**
 *  拖拽手势
 *
 *  @param pan 拖拽手柄
 */
-(void)panGesture:(UIPanGestureRecognizer *)pan{
    if (pan.state==UIGestureRecognizerStateBegan) {
        self.viewState=FanLockNodeViewStateNormal;
    }
    //NSLog(@"--------drag--------");
    CGPoint touchPoint=[pan locationInView:self];
    NSInteger index=[self indexForNodeAtPoint:touchPoint];
    if (index>=0) {
        FanLockNodeView *nodeView=self.nodeViewArray[index];
        if (![self addSelectedNode:nodeView]) {
            [self moveLineWithFingerPosition:touchPoint];
        }
    }else{
        //没有焦点，移动线
        [self moveLineWithFingerPosition:touchPoint];
    }
    if (pan.state==UIGestureRecognizerStateEnded) {
        [self removeLastFingerPosition];
        if ([_delegate respondsToSelector:@selector(fanGesturePasswordView:didEndDragWithPassword:)]) {
            NSMutableString *password = [NSMutableString new];
            for(FanLockNodeView *nodeView in self.selectedNodeViewArray){
                NSString *index = [@(nodeView.tag) stringValue];
                [password appendString:index];
            }
            [_delegate fanGesturePasswordView:self didEndDragWithPassword:password];
        }else{
            self.viewState=FanLockNodeViewStateSelected;
        }
    }
}
/**
 *  触摸点在第几个圆圈里面
 *
 *  @param point 点坐标
 *
 *  @return 第几个点
 */
-(NSInteger)indexForNodeAtPoint:(CGPoint)point
{
    for (int i = 0; i < self.nodeViewArray.count; ++i) {
        FanLockNodeView *node = self.nodeViewArray[i];
        //point在self上的坐标转换成在node里面的坐标点
        CGPoint pointInNode = [node convertPoint:point fromView:self];
        //点是否在view里面 可以用： hitTest:(CGPoint) withEvent:(UIEvent *)
        if ([node pointInside:pointInNode withEvent:nil]) {
            NSLog(@"点中了第%d个~~", i);
            return i;
        }
    }
    return -1;
}
/**
 *  添加选中节点
 *
 *  @param nodeView 触摸节点
 *
 *  @return 是否已经添加，NO表示已经添加过了
 */
-(BOOL)addSelectedNode:(FanLockNodeView *)nodeView
{
    if (![self.selectedNodeViewArray containsObject:nodeView]) {
        nodeView.nodeViewState = FanLockNodeViewStateSelected;
        [self.selectedNodeViewArray addObject:nodeView];
        
        [self addLineToNode:nodeView];
        
        return YES;
    }else{
        return NO;
    }
}
/**
 *  添加连线到节点
 *
 *  @param nodeView 节点view
 */
-(void)addLineToNode:(FanLockNodeView *)nodeView
{
    //
    if(self.selectedNodeViewArray.count == 1){
        
        //path move to start point
        CGPoint startPoint = nodeView.center;
        [self.polygonalLinePath moveToPoint:startPoint];
        [self.pointArray addObject:[NSValue valueWithCGPoint:startPoint]];
        self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;
        
    }else{
        //path add line to point
        [self.pointArray removeLastObject];
        CGPoint middlePoint = nodeView.center;
        [self.pointArray addObject:[NSValue valueWithCGPoint:middlePoint]];
        
        
        [self refreshPolygonalLine];
    }
}
/**
 *  移动线到触摸点
 *
 *  @param touchPoint 触摸点
 */
-(void)moveLineWithFingerPosition:(CGPoint)touchPoint
{
    //NSLog(@"--------move--------");

    if (self.pointArray.count > 0) {
        if (self.pointArray.count > self.selectedNodeViewArray.count) {
            [self.pointArray removeLastObject];
        }
        [self.pointArray addObject:[NSValue valueWithCGPoint:touchPoint]];
        
        [self refreshPolygonalLine];
    }
}
/**
 *  刷新多边行线（刷新界面，重绘路径）
 */
-(void)refreshPolygonalLine{
    [self.polygonalLinePath removeAllPoints];
    CGPoint startPoint = [self.pointArray[0] CGPointValue];
    [self.polygonalLinePath moveToPoint:startPoint];
    //重新绘制所有点
    for (int i = 1; i < self.pointArray.count; ++i) {
        CGPoint middlePoint = [self.pointArray[i] CGPointValue];
        [self.polygonalLinePath addLineToPoint:middlePoint];
    }
    self.polygonalLineLayer.path = self.polygonalLinePath.CGPath;

}
/**
 *  移除最后一个节点后刷新界面
 */
-(void)removeLastFingerPosition
{
    if (self.pointArray.count > 0) {
        if (self.pointArray.count > self.selectedNodeViewArray.count) {
            [self.pointArray removeLastObject];
        }
        
        [self refreshPolygonalLine];
        
    }
}
/**
 *  刷新成警告红线
 */
-(void)makeNodesToWarning
{
    for (int i = 0; i < self.selectedNodeViewArray.count; ++i) {
        FanLockNodeView *node = self.selectedNodeViewArray[i];
        node.nodeViewState = FanLockNodeViewStateWarning;
    }
    self.polygonalLineLayer.strokeColor = [UIColor redColor].CGColor;
}
/**
 *  刷新成成功绿线
 */
-(void)makeNodesToSuccess
{
    for (int i = 0; i < self.selectedNodeViewArray.count; ++i) {
        FanLockNodeView *node = self.selectedNodeViewArray[i];
        node.strokeColor=[UIColor greenColor];
        node.nodeViewState = FanLockNodeViewStateSuccess;
    }
    self.polygonalLineLayer.strokeColor = [UIColor greenColor].CGColor;
}
/**
 *  1秒后清理错误警告
 */
-(void)cleanNodesIfNeeded{
    if(self.viewState != FanLockNodeViewStateSelected){
        [self cleanNodes];
    }
}

#pragma mark - get set 方法
-(CAShapeLayer *)polygonalLineLayer{
    if (_polygonalLineLayer==nil) {
        _polygonalLineLayer=[[CAShapeLayer alloc]init];
        _polygonalLineLayer.lineWidth=1.0f;
        _polygonalLineLayer.strokeColor=self.fan_LineColor.CGColor;
        _polygonalLineLayer.fillColor=[UIColor clearColor].CGColor;
    }
    return _polygonalLineLayer;
}
-(UIColor *)fan_LineColor{
    if (_fan_LineColor==nil) {
        _fan_LineColor=[UIColor colorWithRed:0 green:170/255.0 blue:1 alpha:1];
    }
    return _fan_LineColor;
}
-(void)setViewState:(FanLockNodeViewState)viewState{
    _viewState=viewState;
    switch (_viewState) {
        case FanLockNodeViewStateNormal:{
            [self cleanNodes];
        }
            break;
        case FanLockNodeViewStateWarning:{
            [self makeNodesToWarning];
            [self performSelector:@selector(cleanNodesIfNeeded) withObject:nil afterDelay:0.3];
        }
            break;
        case FanLockNodeViewStateSelected:{
            
        }
        case FanLockNodeViewStateSuccess:{
            [self makeNodesToSuccess];
            [self performSelector:@selector(cleanNodesIfNeeded) withObject:nil afterDelay:0.3];
        }
        default:
            break;
    }
}

#pragma mark - drawRect layoutSubviewss
-(void)layoutSubviews{
    self.polygonalLineLayer.frame=self.bounds;
    CAShapeLayer *maskLayer=[CAShapeLayer new];
    maskLayer.frame=self.bounds;
    
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRect:self.bounds];
    maskLayer.fillRule=kCAFillRuleEvenOdd;
    maskLayer.lineWidth=1.0f;
    maskLayer.strokeColor=[UIColor blackColor].CGColor;
    maskLayer.fillColor=[UIColor blackColor].CGColor;
    for (int i=0; i<self.nodeViewArray.count; i++) {
        FanLockNodeView *nodeView=self.nodeViewArray[i];
//        nodeView.backgroundColor=[UIColor redColor];
        nodeView.strokeColor=self.fan_LineColor;
        CGFloat min = self.bounds.size.width < self.bounds.size.height ? self.bounds.size.width : self.bounds.size.height;
        CGFloat width,height;
        width=height= min / 5;
        CGRect frame = CGRectMake((i%3) *(width * 2), (i/3) * (width *2), width, height);
        nodeView.frame = frame;
        [maskPath appendPath:[UIBezierPath bezierPathWithOvalInRect:frame]];

    }
    maskLayer.path=maskPath.CGPath;
    self.polygonalLineLayer.mask=maskLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
