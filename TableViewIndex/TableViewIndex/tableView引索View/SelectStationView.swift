//
//  SelectStationView.swift
//  广州铁路
//
//  Created by michan on 15/3/5.
//  Copyright (c) 2015年 MC. All rights reserved.
//

protocol SelectStationViewDelegate : UITableViewDataSource,UITableViewDelegate {
    
   
    func sectionIndexTitlesForABELTableView(tableView:SelectStationView) -> NSArray
    
    
    
    
}



import UIKit

class SelectStationView: UIView , MCTableViewIndexDelegate{
    
    var _flotageLabel:
    UILabel!
    var _tableView:
    UITableView!
    var _tableViewIndex:
    MCTableViewIndex!
    
    weak var _delegate:
    SelectStationViewDelegate?
    
    let y_h:CGFloat = UIScreen.mainScreen().bounds.height > 480 ? 50 : 20
    
    
    func prepareUI(){
        //self.backgroundColor = UIColor.redColor()
      _tableView = UITableView(frame: self.bounds, style: UITableViewStyle.Plain)
      //  _tableView.showsHorizontalScrollIndicator = false
        _tableView.showsVerticalScrollIndicator = false
        _tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        self.addSubview(_tableView)
        
        _tableViewIndex = MCTableViewIndex(frame: CGRectMake(UIScreen.mainScreen().bounds.width - 20, 0, 20, self.frame.height - 20))
        self.addSubview(_tableViewIndex)
        _flotageLabel = UILabel(frame: CGRectMake((self.bounds.width - 64) / 2, (self.bounds.height - 64) / 2, 64, 64))
        _flotageLabel.backgroundColor = UIColor(patternImage: UIImage(named: "flotageBackgroud")!)
        _flotageLabel.hidden = true
        _flotageLabel.textAlignment = NSTextAlignment.Center
        _flotageLabel.textColor = UIColor.whiteColor()

        self.addSubview(_flotageLabel)
        
        
        
    }
    func Delegate(delegate:SelectStationViewDelegate){
      _delegate = delegate
        _tableView.dataSource = delegate
        _tableView.delegate = delegate
        _tableViewIndex.indexes = _delegate?.sectionIndexTitlesForABELTableView(self)
       
        var rect = _tableViewIndex.frame
        var hh =  _tableViewIndex.indexes.count
        if hh == 1{
            rect = CGRectMake(rect.origin.x, UIScreen.mainScreen().bounds.height / 2, rect.width, CGFloat(_tableViewIndex.indexes.count * 14))
            
        }
        else{
        rect = CGRectMake(rect.origin.x, y_h, rect.width, CGFloat(_tableViewIndex.indexes.count * 14))
        }
        //rect.origin.y = (self.bounds.height - rect.height)
        
        _tableViewIndex.frame = rect
        _tableViewIndex.delegate(self)
        
            
    }
    
    func reloadData(){
       _tableView.reloadData()
        
        var edgeInsets = _tableView.contentInset
        _tableViewIndex.indexes = _delegate?.sectionIndexTitlesForABELTableView(self)
        var rect = _tableViewIndex.frame
        let  height = CGFloat( _tableViewIndex.indexes.count * 14)
        
        let y = (self.bounds.height - rect.height - edgeInsets.top - edgeInsets.bottom) / 2
        if _tableViewIndex.indexes.count == 1{
           // rect = CGRectMake(rect.origin.x, , rect.width, CGFloat(_tableViewIndex.indexes.count * 14))
            rect = CGRectMake(rect.origin.x, UIScreen.mainScreen().bounds.height / 2, rect.width, height)

        }
        else{
            rect = CGRectMake(rect.origin.x, y_h, rect.width, height)

        }

        
        
//        println(y,self.bounds.height,rect.height)
//        println(edgeInsets.bottom)
//        println(edgeInsets.top)
        
        _tableViewIndex.frame = rect
        _tableViewIndex.delegate(self)
        
        
    }
    //#pragma mark -MCTableViewIndexDelegate
    // 触摸到索引时触发
    func tableViewIndex(tableViewIndex: MCTableViewIndex, didSelectSectionAtIndex index: NSInteger, withTitle title: NSString) {
        
        if _tableView.numberOfSections() > index && index > -1{
            // 滚动路径标识，直至指数连续接收器在屏幕上的特定位置
            _tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            _flotageLabel.text = title as String
 
            
        }
    
    }
    // 开始触摸索引
    func tableViewIndexTouchesBegan(tableViewIndex: MCTableViewIndex) {
        _flotageLabel.hidden = false
    }
    //触摸索引结束
    func tableViewIndexTouchesEnd(tableViewIndex: MCTableViewIndex) {
        
        var animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.4
        _flotageLabel.layer.addAnimation(animation, forKey: nil)
        _flotageLabel.hidden = true
        
        
    }
    //return 索引title数组
    func tableViewIndexTitle(tableViewIndex: MCTableViewIndex) -> NSArray {
        
        var array = _delegate?.sectionIndexTitlesForABELTableView(self)
        
        return array!
    }
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
