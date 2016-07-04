//
//  FanSwiperbleView.m
//
//
//  Created by 向阳凡 on 15/8/24.
//
//

#import "FanSwiperbleView.h"

const NSUInteger FanShowViewsNumber = 3;


@interface FanSwiperbleView ()<UICollisionBehaviorDelegate,UIDynamicAnimatorDelegate>

/**
 *  UIDynamicAnimator介于iOS图形引擎和动力项(View)之间，
 */
@property (strong, nonatomic) UIDynamicAnimator *animator;
/**
 *  View的捕捉行为（给动力一个捕捉点，动力项会根据配置的效果，来抓住这一捕捉点）
 */
@property (strong, nonatomic) UISnapBehavior *swipeableViewSnapBehavior;
/**
 *  View的吸附行为
 
 *  指定两个动力项（项或点）之间的连接，当一个项或者点移动时，吸附的项也随之移动。
 *  当然，这个连接并不是完全是静态的（static），吸附的项有两个属性damping(阻尼)和oscillation(震荡)，
 *  这两个属性决定了吸附项的行为是如何随时间而变化的。
 */
@property (strong, nonatomic)UIAttachmentBehavior *swipeableViewAttachmentBehavior;
/**
 *  锚点的吸附行为
 */
@property (strong, nonatomic)UIAttachmentBehavior *anchorViewAttachmentBehavior;
/**
 *  锚点View容器(没有什么卵用）
 */
//@property (strong, nonatomic) UIView *anchorContainerView;
/**
 *  锚点View
 */
@property (strong, nonatomic) UIView *anchorView;
/**
 *  描点是否可见
 */
@property (nonatomic) BOOL isAnchorViewVisible;
/**
 *  容器View
 */
@property (strong, nonatomic) UIView *containerView;

@end

@implementation FanSwiperbleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    //行为管理
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    //self.animator.delegate = self;
    //锚点容器
//    self.anchorContainerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
//    self.anchorContainerView.backgroundColor=[UIColor yellowColor];
//    [self addSubview:self.anchorContainerView];
    //开启锚点
    self.isAnchorViewVisible = NO;
    //存放显示的View容器
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
//    self.containerView.backgroundColor=[UIColor greenColor];
    [self addSubview:self.containerView];
    // Default properties(默认属性设置）
    self.direction = FanSwipeableViewDirectionAll;
    self.beginCenter=CGPointMake(0, 0);
    self.rotationDegree=5;
    self.collisionRect = [self defaultCollisionRect];
    self.pushVelocityMagnitude = 1000;
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    self.anchorContainerView.frame = CGRectMake(0, 0, 1, 1);
    self.containerView.frame =self.bounds;
}
#pragma mark - 辅助方法
- (CGRect)defaultCollisionRect {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    CGFloat collisionSizeScale = 6;
    CGSize collisionSize = CGSizeMake(viewSize.width * collisionSizeScale,
                                      viewSize.height * collisionSizeScale);
    CGRect collisionRect =
    CGRectMake(-collisionSize.width / 2 + viewSize.width / 2,
               -collisionSize.height / 2 + viewSize.height / 2,
               collisionSize.width, collisionSize.height);
    return collisionRect;
}
int signum(CGFloat n) { return (n < 0) ? -1 : (n > 0) ? +1 : 0; }
-(FanSwipeableViewDirection)fanDirectionVectorToSwipeableViewDirection:(CGVector)directionVector{
    FanSwipeableViewDirection direction = FanSwipeableViewDirectionNone;
    //拖动时x,y方向，通过大小，判断你拖动朝哪个方向
    if (ABS(directionVector.dx) > ABS(directionVector.dy)) {
        if (directionVector.dx > 0) {
            direction = FanSwipeableViewDirectionRight;
        } else {
            direction = FanSwipeableViewDirectionLeft;
        }
    } else {
        if (directionVector.dy > 0) {
            direction = FanSwipeableViewDirectionDown;
        } else {
            direction = FanSwipeableViewDirectionUp;
        }
    }
    
    return direction;
}

#pragma mark - 滑动手势

//滑动手势
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    //拖动的偏移量
    CGPoint translation = [recognizer translationInView:self];
    //在父视图的坐标
    CGPoint location = [recognizer locationInView:self];
    UIView *swipeableView = recognizer.view;
    NSLog(@"\ntranslation:[%f:%f]\nlocation:[%f:%f]",translation.x,translation.y,location.x,location.y);
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        [self createAnchorViewForCover:swipeableView atLocation:location shouldAttachAnchorViewToPoint:YES];
    }
    if (recognizer.state==UIGestureRecognizerStateChanged) {
        self.anchorViewAttachmentBehavior.anchorPoint=location;
    }
    if (recognizer.state==UIGestureRecognizerStateCancelled||recognizer.state==UIGestureRecognizerStateEnded) {
        //拖动的速度
        CGPoint velocity = [recognizer velocityInView:self];
        NSLog(@"velocity:[%f:%f]]",velocity.x,velocity.y);
        //开平方的总速度
        CGFloat velocityMagnitude=sqrtf(powf(velocity.x, 2) + powf(velocity.y, 2));
        CGPoint normalizedVelocity = CGPointMake(velocity.x / velocityMagnitude, velocity.y / velocityMagnitude);
        //推出速度，1000左右
        CGFloat scale = velocityMagnitude > 750? velocityMagnitude: self.pushVelocityMagnitude;
        //偏移量开平方（滑动的距离）
        CGFloat translationMagnitude = sqrtf(translation.x * translation.x +translation.y * translation.y);
        //滑动的速度
        CGVector directionVector =CGVectorMake(translation.x / translationMagnitude * scale,translation.y / translationMagnitude * scale);
        //ABS（）求据对值
        if (([self fanDirectionVectorToSwipeableViewDirection:directionVector]&self.direction)>0
            &&(ABS(translation.x) > 0.25 *self.bounds.size.width ||velocityMagnitude > 750) && // velocity
            (signum(translation.x) == signum(normalizedVelocity.x)) && // sign X
            (signum(translation.y) == signum(normalizedVelocity.y))    // sign Y
            ) {
            [self pushAnchorViewForCover:swipeableView inDirection:directionVector andCollideInRect:self.collisionRect];
        }else{
            [self.animator removeBehavior:self.swipeableViewAttachmentBehavior];
            [self.animator removeBehavior:self.anchorViewAttachmentBehavior];
            [self.anchorView removeFromSuperview];
            self.swipeableViewSnapBehavior =[self snapBehaviorThatSnapView:swipeableView toPoint:self.containerView.center];
            [self.animator addBehavior:self.swipeableViewSnapBehavior];
            
        }
    }
}
/**
 *  给滑动View创建吸附行为和吸附锚点
 *
 *  @param swipeableView       滑动View
 *  @param location            本地坐标
 *  @param shouldAttachToPoint 是否需要吸附锚点
 */
- (void)createAnchorViewForCover:(UIView *)swipeableView atLocation:(CGPoint)location shouldAttachAnchorViewToPoint:(BOOL)shouldAttachToPoint {
    [self.animator removeBehavior:self.swipeableViewSnapBehavior];
    self.swipeableViewSnapBehavior = nil;
    
    self.anchorView =[[UIView alloc] initWithFrame:CGRectMake(location.x - 500,location.y - 500, 1000, 1000)];
    [self.anchorView setBackgroundColor:[UIColor blueColor]];
    self.anchorView.alpha=0.5;
    [self.anchorView setHidden:!self.isAnchorViewVisible];
    [self addSubview:self.anchorView];
    UIAttachmentBehavior *attachToView =[self attachmentBehaviorThatAnchorsView:swipeableView toView:self.anchorView];
    [self.animator addBehavior:attachToView];
    self.swipeableViewAttachmentBehavior = attachToView;
    
    if (shouldAttachToPoint) {
        UIAttachmentBehavior *attachToPoint =[self attachmentBehaviorThatAnchorsView:self.anchorView toPoint:location];
        [self.animator addBehavior:attachToPoint];
        self.anchorViewAttachmentBehavior = attachToPoint;
    }
}
- (void)pushAnchorViewForCover:(UIView *)swipeableView
                   inDirection:(CGVector)directionVector
              andCollideInRect:(CGRect)collisionRect {
    //FanSwipeableViewDirection direction =[self fanDirectionVectorToSwipeableViewDirection:directionVector];
    
    [self.animator removeBehavior:self.anchorViewAttachmentBehavior];
    
    UICollisionBehavior *collisionBehavior =[self collisionBehaviorThatBoundsView:self.anchorView inRect:collisionRect];
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    
    UIPushBehavior *pushBehavior =[self pushBehaviorThatPushView:self.anchorView toDirection:directionVector];
    [self.animator addBehavior:pushBehavior];
    
    [self addSubview:self.anchorView];
    [self addSubview:swipeableView];
    swipeableView.userInteractionEnabled=NO;
    [self bringSubviewToFront:swipeableView];
    
    self.anchorView = nil;
    
    [self loadNextSwipeableViewsIfNeeded];
}
#pragma mark - UICollisionBehaviorDelegate
-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier{
    if ([self.delegate respondsToSelector:@selector(fan_swipeableView:leaveView:)]) {
        [self.delegate fan_swipeableView:self leaveView:item];
    }
    
    NSMutableSet *viewsToRemove = [[NSMutableSet alloc] init];
    
    for (id aBehavior in self.animator.behaviors) {
        if ([aBehavior isKindOfClass:[UIAttachmentBehavior class]]) {
            NSArray *items = ((UIAttachmentBehavior *)aBehavior).items;
            if ([items containsObject:item]) {
                [self.animator removeBehavior:aBehavior];
                [viewsToRemove addObjectsFromArray:items];
            }
        }
        if ([aBehavior isKindOfClass:[UIPushBehavior class]]) {
            NSArray *items = ((UIPushBehavior *)aBehavior).items;
            if ([((UIPushBehavior *)aBehavior).items containsObject:item]) {
                if ([items containsObject:item]) {
                    [self.animator removeBehavior:aBehavior];
                    [viewsToRemove addObjectsFromArray:items];
                }
            }
        }
        if ([aBehavior isKindOfClass:[UICollisionBehavior class]]) {
            NSArray *items = ((UICollisionBehavior *)aBehavior).items;
            if ([((UICollisionBehavior *)aBehavior).items
                 containsObject:item]) {
                if ([items containsObject:item]) {
                    [self.animator removeBehavior:aBehavior];
                    [viewsToRemove addObjectsFromArray:items];
                }
            }
        }
    }
    
    for (UIView *view in viewsToRemove) {
        for (UIGestureRecognizer *aGestureRecognizer in view.gestureRecognizers) {
            if ([aGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                [view removeGestureRecognizer:aGestureRecognizer];
            }
        }
        [view removeFromSuperview];
    }
}
#pragma mark - 外部调用方法
-(void)fan_reloadData{
    [self fan_discardAllSwipeableViews];
    [self loadNextSwipeableViewsIfNeeded];
}
/**
 *  移除所有View
 */
- (void)fan_discardAllSwipeableViews {
    //[self.animator removeBehavior:self.anchorViewAttachmentBehavior];
    [self.animator removeAllBehaviors];
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
}
- (void)fan_swipeTopViewToLeft {
    [self fan_swipeTopViewToDirection:FanSwipeableViewDirectionLeft];
}

- (void)fan_swipeTopViewToRight {
    [self fan_swipeTopViewToDirection:FanSwipeableViewDirectionRight];
}

- (void)fan_swipeTopViewToUp {
    [self fan_swipeTopViewToDirection:FanSwipeableViewDirectionUp];
}

- (void)fan_swipeTopViewToDown {
    [self fan_swipeTopViewToDirection:FanSwipeableViewDirectionDown];
}

- (void)fan_swipeTopViewToDirection:(FanSwipeableViewDirection)direction {
    UIView *topSwipeableView = self.containerView.subviews.lastObject;
    if (!topSwipeableView) {
        return;
    }
    
    CGPoint location = CGPointMake(topSwipeableView.center.x,topSwipeableView.center.y *(1 -0.2));
    [self createAnchorViewForCover:topSwipeableView atLocation:location shouldAttachAnchorViewToPoint:YES];
    CGVector directionVector;
    switch (direction) {
        case FanSwipeableViewDirectionLeft:
            directionVector = CGVectorMake(-self.pushVelocityMagnitude, 0);
            break;
        case FanSwipeableViewDirectionRight:
            directionVector = CGVectorMake(self.pushVelocityMagnitude, 0);
            break;
        case FanSwipeableViewDirectionUp:
            directionVector = CGVectorMake(0, -self.pushVelocityMagnitude);
            break;
        case FanSwipeableViewDirectionDown:
            directionVector = CGVectorMake(0, self.pushVelocityMagnitude);
            break;
        default:
            directionVector = CGVectorMake(0, 0);
            break;
    }
    [self pushAnchorViewForCover:topSwipeableView inDirection:directionVector andCollideInRect:self.collisionRect];
}


#pragma mark - 动画布局
- (void)loadNextSwipeableViewsIfNeeded {
    NSInteger numViews = self.containerView.subviews.count;
    NSMutableSet *newViews = [NSMutableSet set];
    for (NSInteger i = numViews; i < FanShowViewsNumber; i++) {
        UIView *nextView = [self nextSwipeableView];
        if (nextView) {
            [self.containerView addSubview:nextView];
            [self.containerView sendSubviewToBack:nextView];
            if (i==0) {
                nextView.center =self.beginCenter;
            }else{
                //nextView.center=CGPointMake(-self.beginCenter.x, self.beginCenter.y);
            }
            [newViews addObject:nextView];
        }
    }
    [self refreshSwipeableViews];
}
/**
 *  从datasource代理中取到显示View
 *
 *  @return View
 */
- (UIView *)nextSwipeableView {
    UIView *nextView = nil;
    if ([self.dataSource respondsToSelector:@selector(nextViewForSwipeableView:)]) {
        nextView = [self.dataSource nextViewForSwipeableView:self];
    }
    if (nextView) {
        [nextView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)]];
    }
    return nextView;
}
/**
 *  刷新布局
 */
- (void)refreshSwipeableViews{
    //容器中没有View时返回
    UIView *topSwipeableView = self.containerView.subviews.lastObject;
    if (!topSwipeableView) {
        return;
    }
    //把最上面一张View设置可以交互行为
    for (UIView *cover in self.containerView.subviews) {
        cover.userInteractionEnabled = NO;
    }
    topSwipeableView.userInteractionEnabled = YES;
    //不是默认手势状态时不执行归位动画
    for (UIGestureRecognizer *recognizer in topSwipeableView
         .gestureRecognizers) {
        if (recognizer.state != UIGestureRecognizerStatePossible) {
            return;
        }
    }
    //三张View归位动画
    if (YES) {
        // rotation
        NSUInteger numSwipeableViews = self.containerView.subviews.count;
        if (numSwipeableViews >= 1) {
            //取最上面一张View添加捕捉行为
            [self.animator removeBehavior:self.swipeableViewSnapBehavior];
            self.swipeableViewSnapBehavior = [self snapBehaviorThatSnapView:self.containerView.subviews[numSwipeableViews - 1] toPoint:self.containerView.center];
            [self.animator addBehavior:self.swipeableViewSnapBehavior];
        }
        CGPoint rotationCenterOffset = {0, CGRectGetHeight(topSwipeableView.frame) *0.3};
        if (numSwipeableViews >= 2) {
            [self rotateView:self.containerView.subviews[numSwipeableViews - 2] forDegree:self.rotationDegree atOffsetFromCenter:rotationCenterOffset animated:YES];
        }
        if (numSwipeableViews >= 3) {
            [self rotateView:self.containerView.subviews[numSwipeableViews - 3] forDegree:-self.rotationDegree atOffsetFromCenter:rotationCenterOffset animated:YES];
        }
    }
}
/**
 *  旋转View，产生错乱有秩的情况
 *
 *  @param view     View
 *  @param degree   旋转弧度
 *  @param offset   中心偏移量
 *  @param animated 是否有动画
 */
- (void)rotateView:(UIView *)view forDegree:(float)degree atOffsetFromCenter:(CGPoint)offset animated:(BOOL)animated {
    float duration = animated ? 0.4 : 0;
    float rotationRadian = degree * M_PI / 180;
    [UIView animateWithDuration:duration animations:^{
        view.center = self.containerView.center;
        CGAffineTransform transform =CGAffineTransformMakeTranslation(offset.x, offset.y);
        transform =CGAffineTransformRotate(transform, rotationRadian);
        transform = CGAffineTransformTranslate(transform, -offset.x, -offset.y);
        view.transform = transform;
    }];
}
#pragma mark - get set
- (void)setDataSource:(id<FanSwipeableViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self loadNextSwipeableViewsIfNeeded];
}

#pragma mark - UIDynamicAnimationHelpers

- (UICollisionBehavior *)collisionBehaviorThatBoundsView:(UIView *)view
                                                  inRect:(CGRect)rect {
    if (!view) {
        return nil;
    }
    UICollisionBehavior *collisionBehavior =
    [[UICollisionBehavior alloc] initWithItems:@[ view ]];
    UIBezierPath *collisionBound = [UIBezierPath bezierPathWithRect:rect];
    [collisionBehavior addBoundaryWithIdentifier:@"c" forPath:collisionBound];
    collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    return collisionBehavior;
}

- (UIPushBehavior *)pushBehaviorThatPushView:(UIView *)view toDirection:(CGVector)direction {
    if (!view) {
        return nil;
    }
    UIPushBehavior *pushBehavior =
    [[UIPushBehavior alloc] initWithItems:@[view] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = direction;
    return pushBehavior;
}
/**
 *  初始化捕捉行为，加阻尼
 *
 *  @param view  加行为View
 *  @param point 捕捉点
 *
 *  @return 捕捉行为
 */
- (UISnapBehavior *)snapBehaviorThatSnapView:(UIView *)view toPoint:(CGPoint)point {
    if (!view) {
        return nil;
    }
    UISnapBehavior *snapBehavior =[[UISnapBehavior alloc] initWithItem:view snapToPoint:point];
    //阻尼数值
    snapBehavior.damping =0.25f; /* Medium oscillation */
    return snapBehavior;
}
//吸附行为（两个View）
- (UIAttachmentBehavior *)attachmentBehaviorThatAnchorsView:(UIView *)aView toView:(UIView *)anchorView {
    if (!aView) {
        return nil;
    }
    CGPoint anchorPoint = anchorView.center;
    CGPoint p = [self convertPoint:aView.center toView:self];
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]
                                        initWithItem:aView
                                        offsetFromCenter:UIOffsetMake(-(p.x - anchorPoint.x),
                                                                      -(p.y - anchorPoint.y))
                                        attachedToItem:anchorView
                                        offsetFromCenter:UIOffsetMake(0, 0)];
    
    attachment.length = 0;
    return attachment;
}
//吸附行为（锚点）
- (UIAttachmentBehavior *)attachmentBehaviorThatAnchorsView:(UIView *)aView
                                                    toPoint:(CGPoint)aPoint {
    if (!aView) {
        return nil;
    }
    
    CGPoint p = aView.center;
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc]
                                                initWithItem:aView
                                                offsetFromCenter:UIOffsetMake(-(p.x - aPoint.x), -(p.y - aPoint.y))
                                                attachedToAnchor:aPoint];
    attachmentBehavior.damping = 100;
    attachmentBehavior.length = 0;
    return attachmentBehavior;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
