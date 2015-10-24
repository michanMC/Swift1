//
//  MCSaerchModel.swift
//  广州铁路
//
//  Created by michan on 15/3/7.
//  Copyright (c) 2015年 MC. All rights reserved.
//

import UIKit

class MCSaerchModel: NSObject {
    
    weak var _Delegate:
    SelectStationViewController!
    
    
    func loadData(Str:NSString){
       // str = str.uppercaseString()
        
        var str:NSString =  Str.uppercaseString
       // println(str)
        _Delegate._cityData.removeAllObjects()
        if str.isEqualToString(""){
            _Delegate._cityData = _Delegate._cityDataBackups.mutableCopy() as! NSMutableArray
            _Delegate._siteState = SiteState.SiteState_all
            _Delegate.lodaAttention(true)
            return
        }
        
        
        var array = _Delegate._dataModel._dataSource
        var firstStr = (str as NSString).substringToIndex(1)
        
        for citydic in array{
            
            var strKey:
            NSString?
            if self.isPureInt(firstStr) == true {
                
             strKey = citydic.objectForKey("AreaCode") as? NSString
                
               _Delegate._keyStr = "区号-" + (str as! String)
                
            }
            else
            {
                if strlen(firstStr) == 3 {
                strKey = citydic.objectForKey("Name") as? NSString
                
                }
                else
                {
                    strKey  = citydic.objectForKey("Shortkey") as? NSString
                }
                
            }
            if strKey?.length >= str.length {
                
                var index:Int = str.length
                var ss = ((strKey as NSString!).substringToIndex(index)as NSString).isEqualToString(str as String)
                
                if ss {
                    if self.isPureInt(firstStr) == false {
                        _Delegate._keyStr = (citydic.objectForKey("Shortkey") as! NSString).substringToIndex(1)
                        
                    }
                    _Delegate._cityData.addObject(citydic)
                    
                }
            }
            

            
        }
        
        if _Delegate._cityData.count > 0 {
            _Delegate._siteState = SiteState.SiteState_search
            for var i = 0 ; i < _Delegate._cityData.count; i++
            {
                
                var cityStr: AnyObject? = _Delegate._cityData.objectAtIndex(i).objectForKey("Name")
                if _Delegate._historyArray.containsObject(cityStr!) == true{
                    _Delegate._cityData.exchangeObjectAtIndex(0, withObjectAtIndex: i)
                    break
                }
            }
            
        }
        
       // println(_Delegate._cityData.count)
        _Delegate._tableView.reloadData()
        
        
        
        
        
        
        
    }
    
    func isPureInt(string:NSString)->Bool{
        var scan = NSScanner(string: string as! String)
        var val = Int32()
       // var bb = scan.scanInt(&val)
        
        return scan.scanInt(&val) && scan.atEnd
        
    }
   
}
