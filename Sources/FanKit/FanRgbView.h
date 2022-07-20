//
//  FanRgbView.h
//  FanPicture
//
//  Created by 向阳凡 on 2020/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///HSV的绘制类型
typedef NS_ENUM(NSUInteger, FanHSVType) {
    ///圆形rgb 只有hue+饱和度(控件要是正方形)
    FanHSVTypeCicle_HS,
    ///矩形色彩空间Hue（水平和垂直）
    FanHSVTypeRect_H,
    ///矩形的饱和度和亮度
    FanHSVTypeRect_SL,
    ///饱和度（水平和垂直）
    FanHSVTypeRect_S,
    ///亮度（水平和垂直）
    FanHSVTypeRect_L,
};

///HSV的触摸类型
typedef NS_ENUM(NSUInteger, FanHSVTouchType) {
    ///触摸开始
    FanHSVTouchTypeBegan,
    ///触摸移动
    FanHSVTouchTypeMoved,
    ///触摸结束
    FanHSVTouchTypeEnded,
    ///触摸关闭
    FanHSVTouchTypeCancelled,
    ///首次复位初始化
    FanHSVTouchTypeInit
};

@class FanHSVView;

typedef void(^FanHSVViewBlock)(UIColor * _Nullable hsvColor,FanHSVTouchType touchType);

typedef void(^FanHSVTouchBlock)(CGPoint touchPoint,FanHSVTouchType touchType);

@class FanRgbView;

typedef void(^FanRgbViewBlock)(FanRgbView *_Nullable rgbView,  UIColor * _Nullable rgbColor,FanHSVTouchType touchType);

@interface FanRgbView : UIView

@property(nonatomic,strong)UIImageView *pointView;

@property(nonatomic,copy)FanRgbViewBlock rgbBlock;

///上下左右内边距 默认 8
@property(nonatomic,assign)CGFloat padding;
///滑块是否居中
@property(nonatomic,assign)BOOL panCenter;


///传过来的颜色,会重新计算HSV，记得setNeedsDisplay
@property(nonatomic,strong)UIColor *rgbColor;
///时时拖动时的颜色
@property(nonatomic,strong)UIColor *panColor;

///Hsv类型
@property(nonatomic,assign)FanHSVType hsvType;
///是否是垂直类型 默认=NO
@property(nonatomic,assign)BOOL isVertical;

@property(nonatomic,strong)FanHSVView *hsvView;

//必须执行此方法来绘制，不然就没有数据，且只执行一次
-(void)fan_drawStyle:(FanHSVType)hsvType;
///重新绘制 调整好属性后
-(void)fan_resetDraw;

@end




@interface FanHSVView : UIView

@property(nonatomic,assign)CGPoint touchPoint;

@property(nonatomic,copy)FanHSVViewBlock hsvBlock;
@property(nonatomic,copy)FanHSVTouchBlock hsvTouchBlock;

///Hsv类型
@property(nonatomic,assign)FanHSVType hsvType;
///是否是垂直类型 默认=NO
@property(nonatomic,assign)BOOL isVertical;

///是否重置每次重新绘制的拖动点 默认YES
@property(nonatomic,assign)BOOL resetPanPoint;

///传过来的颜色,会重新计算HSV，记得setNeedsDisplay
@property(nonatomic,strong)UIColor *hsvColor;
///时时拖动时的颜色
@property(nonatomic,strong)UIColor *panColor;

//必须执行此方法来绘制，不然就没有数据
-(void)fan_drawHsv;


-(void)fan_touchPoint:(CGPoint)point touchType:(FanHSVTouchType)touchType;

@end
NS_ASSUME_NONNULL_END
