//
//  MCTableViewIndex.swift
//  广州铁路
//
//  Created by michan on 15/3/6.
//  Copyright (c) 2015年 MC. All rights reserved.
//
protocol MCTableViewIndexDelegate:NSObjectProtocol{
    /**
    *  触摸到索引时触发
    *
    *  @param tableViewIndex 触发didSelectSectionAtIndex对象
    *  @param index          索引下标
    *  @param title          索引文字
    */
   func tableViewIndex(tableViewIndex:MCTableViewIndex,didSelectSectionAtIndex index:NSInteger,withTitle title:NSString)
    
    /**
    *  开始触摸索引
    *
    *  @param tableViewIndex 触发tableViewIndexTouchesBegan对象
    */
    func tableViewIndexTouchesBegan(tableViewIndex:MCTableViewIndex)


    /**
    *  触摸索引结束
    *
    *  @param tableViewIndex
    */
    func tableViewIndexTouchesEnd(tableViewIndex:MCTableViewIndex)
    
    
    /**
    *  TableView中右边右边索引title
    *
    *  @param tableViewIndex 触发tableViewIndexTitle对象
    *
    *  @return 索引title数组
    */
    func tableViewIndexTitle(tableViewIndex:MCTableViewIndex) ->NSArray
    
    
    
    
}

import UIKit

class MCTableViewIndex: ViewPerformSelector {
    

    
    weak var _tableViewIndexDelegate:
    MCTableViewIndexDelegate?
    
    var indexes:
    NSArray!
    
    var isLayedOut:
    Bool!
    var shapeLayer:
    CAShapeLayer!
    var letters:
    NSArray!
    var letterHeight:
    CGFloat!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.prepareUI()
        self.backgroundColor = UIColor.clearColor()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        //创建一个shapeLayer
        shapeLayer = CAShapeLayer()
        // 线条宽度
        shapeLayer.lineWidth = 1.0
        // 闭环填充的颜色
        shapeLayer.fillColor = UIColor.clearColor().CGColor;
        shapeLayer.lineJoin = kCALineCapSquare
        // 边缘线的颜色
        shapeLayer.strokeColor = UIColor.clearColor().CGColor
        shapeLayer.strokeEnd = 1.0
       // self.layer.masksToBounds = false

        
    }
    func delegate(tableViewIndexDelegate:MCTableViewIndexDelegate){
        
        _tableViewIndexDelegate = tableViewIndexDelegate
        //索引title数组
        letters = _tableViewIndexDelegate?.tableViewIndexTitle(self)
        
        isLayedOut = false
        self.layoutSubviews()
        
    }
    
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setup()
        if isLayedOut == false {
            
        self.PerformSelector(self)
               var Poin_t = CGPointZero
            var siz_e = self.layer.frame.size
            shapeLayer.frame.origin = Poin_t
            shapeLayer.frame.size = siz_e
            var bezierPath = UIBezierPath()
            bezierPath.moveToPoint(CGPointZero)
            bezierPath.addLineToPoint(CGPointMake(0, self.frame.size.height))
            
            letterHeight = 14
            var fontSize:CGFloat = 11
            
            
            letters.enumerateObjectsUsingBlock({ (letter, idx,stop) -> Void in
                var originY = CGFloat(idx) * self.letterHeight
                var ctl:CATextLayer = self.textLayerWithSize(fontSize, str:letter as! NSString , andFrame: CGRectMake(0, originY, self.frame.size.width, self.letterHeight))
                
                self.layer.addSublayer(ctl)
                bezierPath.moveToPoint(CGPointMake(0,originY))
                bezierPath.addLineToPoint(CGPointMake(ctl.frame.size.width, originY))
                
                
            })
            shapeLayer.path = bezierPath.CGPath
            self.layer.addSublayer(shapeLayer)
            isLayedOut = true
        }
    }
    
    func textLayerWithSize(size:CGFloat, str string:NSString, andFrame frame:CGRect) ->(CATextLayer){
        
        var tl = CATextLayer()
        tl.fontSize =  size
        tl.frame = frame
        tl.alignmentMode = kCAAlignmentCenter
        tl.contentsScale = UIScreen.mainScreen().scale
        tl.foregroundColor = CommonUtil.RGBA(30, g: 144, b: 255, a: 1).CGColor
        tl.string = string
        return tl
        
        

    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        self.sendEventToDelegate(event)

    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        self.sendEventToDelegate(event)
        _tableViewIndexDelegate?.tableViewIndexTouchesBegan(self)
        
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        _tableViewIndexDelegate?.tableViewIndexTouchesEnd(self)
    }
    func sendEventToDelegate(_event:UIEvent){
        var touch =  UITouch()
        var s : NSSet =  _event.allTouches()!
        touch = s.anyObject()as! UITouch
        var point = touch.locationInView(self)
        var indx = CGFloat(floorf(Float(point.y))) / letterHeight
        if ((Int(indx) < 0) || ( Int(indx) > letters.count - 1 )){
            
            return
            
        }
        
        _tableViewIndexDelegate?.tableViewIndex(self, didSelectSectionAtIndex: Int(indx), withTitle: letters.objectAtIndex(Int(indx)) as! NSString)
        
        
    }
       

    
    
    
    
    
    
   
}
