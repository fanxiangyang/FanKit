# FanKit
A Cocoa Tool Kit collection of iOS components(一个iOS集成实用工具库,以后会添加更多更多的工具，实用类，封装类，封装小效果)


Introduce（介绍）
==============

FanKit 是一组庞大、功能丰富的 iOS 组件。

但是现在还只是起步而已，我会加快完善类库和demo，希望到时候能给大家带来一个优质的工具
* Common 			— 公共+基类+资源。
* Core 			— 基本类型及常用工厂类。
* UIKit		 	— UI方面的类及工厂方法。
* Libs		 	— 自定义的小效果。（自己喜欢可以自己下载demo使用）

Installation（安装）
==============
### CocoaPods

1. Add `pod 'FanKit','~> 1.1.0'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import "FanKit.h".

### SPM支持

1. 从版本1.1.0开始
2. 

### 手动安装

1. 下载 FanKit项目。
2. 将 FanKit项目里面Sources文件夹及内的源文件添加(拖放)到你的工程。
3. 链接以下 frameworks:
   * UIKit
   * CoreFoundation
   * CoreGraphics
   * QuartzCore
   * AudioToolbox
   * AVFoundation
   * Photos
   * AssetsLibrary
   * SystemConfiguration
   * CoreLocation"
4. 在项目pch中导入 `FanKit.h`,其他的功能自行选择。

Requirements(系统要求)
==============
FanKit该项目最低支持 iOS 9.0。

注意：随着iOS系统更新换代，iOS9.0以下，不适配了


Function Example(功能事例)
==============
### 1.Example List（功能列表）
<img src="https://github.com/fanxiangyang/FanKit/blob/master/Demo/Document/DemoList.png?raw=true" width="320">     <img src="https://github.com/fanxiangyang/FanKit/blob/master/Demo/Document/password.png?raw=true" width="320">
#### 2.RGB-HSV可以相互转换
<img src="https://github.com/fanxiangyang/FanKit/blob/master/Demo/Document/rgbColor.png?raw=true" width="320">

更新历史(Version Update)
==============
### Release 1.1.0 
* 1.添加对Swift Package Manager的支持
* 2.其他各功能优化，及bug修复

### Release 1.0.0 
* 1.UIView+FanAutoLayout添加和更新方法
* 2.增加RGB-HSV画图
* 3.其他各功能优化

### Release 0.4.0
* 1.录屏横竖屏和锁定适配
* 2.新增加RSA加密解密算法
* 3.日期处理显示的bug

### Release 0.3.0
* iOS 9.0+ 会移除iOS8.0的方法
* 添加部分方法，优化部分细节
* 增加wav和caf格式转码到aac

### Release 0.2.0
* 添加部分方法，优化部分细节，
* 移除Libs pod库内容，需要可以下载使用，以后只包含在项目中。

### Release 0.1.0
* 添加部分语言本地化，
* 移除不太通用的方法，
* 完善和添加部分方法，使用更加方便,特别在layer层绘图。

### Release 0.0.1-0.0.3
* 基本库，很多不是很完善

Like(喜欢)
==============
#### 有问题请直接在文章下面留言,喜欢就给个Star(小星星)吧！ 
#### Email: fqsyfan@gmail.com
#### Email: fanxiangyang_heda@163.com 
