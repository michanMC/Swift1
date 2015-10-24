//
//  MCmodel.swift
//  广州铁路
//
//  Created by michan on 15/3/6.
//  Copyright (c) 2015年 MC. All rights reserved.
//

import UIKit

class MCmodel: NSObject {
   
    let Bureau_code = "Bureau_code"
    let Bureau_name = "Bureau_name"
    let ID          = "ID"
    let Name        = "Name"
    let Shortkey    = "Shortkey"
    let AreaCode    = "AreaCode"
    let Levels      = "Levels"
    let TelCode     = "TelCode"
    
    weak var _Delegate:
    SelectStationViewController!
    var _dataSource:
    NSMutableArray!
    
    func lodaData(){
        
        _dataSource = NSMutableArray()
        var keyArray = NSMutableArray()
        var pathStr = NSBundle.mainBundle().pathForResource("stations", ofType: "db")
        var _database = FMDatabase(path: pathStr)
        _database.open()
        var queystr = "select * from stations,bureau where stations.Bureau_code=bureau.Bureau_code"
        
        var result :FMResultSet = _database.executeQuery(queystr, withArgumentsInArray: nil)
        while (result.next())
        {
          
            var dic  = NSMutableDictionary()
            var BureauName = result.stringForColumn(Bureau_name)
            var Id = result.stringForColumn(ID)
            var Namestr = result.stringForColumn(Name)
            _Delegate._stationSearchArray.addObject(Namestr)
            var telCode = result.stringForColumn(TelCode)
            var BureauCode = result.stringForColumn(Bureau_code)
            var Shortkeystr = result.stringForColumn(Shortkey)
            var AreaCodestr = result.stringForColumn(AreaCode)
            
            dic.setObject(Id, forKey: ID)
            dic.setObject(Namestr, forKey: Name)
            dic.setObject(telCode, forKey: TelCode)
            dic.setObject(BureauName, forKey: Bureau_name)
            dic.setObject(BureauCode, forKey: Bureau_code)
            dic.setObject(Shortkeystr, forKey: Shortkey)
            dic.setObject(AreaCodestr, forKey: AreaCode)
            
           _dataSource.addObject(dic)
            
            //textField.text = (toBeString as NSString).substringToIndex(30)
            
            
    var keyStr = (Shortkeystr as NSString).substringToIndex(1)
            if keyArray.containsObject(keyStr) == false{
                
                keyArray.addObject(keyStr)
            
            }
        }
            var arrayDpe = ArrayDispose()

          _Delegate._inhaulArray  =  arrayDpe.KeyArray(keyArray as [AnyObject])
            _Delegate._arraySection.setArray(_Delegate._inhaulArray as! [AnyObject])
            _Delegate._arraySection.replaceObjectAtIndex(_Delegate._arraySection.count - 1, withObject: "#")
        
        _database.close()
        self.grouping()
            
            
        }
    func grouping(){
       var dicKey = NSMutableDictionary()
        
        for keyStr in  _Delegate._inhaulArray{
            
            var arrayData = NSMutableArray()
            dicKey.setObject(arrayData, forKey: keyStr as! String)
            
        }
        for citydic in _dataSource{
            var keyStr = (citydic.objectForKey(Shortkey) as! NSString).substringToIndex(1)
            dicKey.objectForKey(keyStr)?.addObject(citydic)
            
        }
        for key in _Delegate._inhaulArray{
            var array: AnyObject? = dicKey.objectForKey(key as! NSString)

            _Delegate._cityData.addObject(array!)
        }
        if _Delegate._attentionArray.count > 0 {
           _Delegate._cityData.insertObject(_Delegate._attentionArray, atIndex: 0)
           _Delegate._arraySection.insertObject("关注", atIndex: 0)
        }
        
        
      //  println("===\(_Delegate._cityData)")
        
        _Delegate._cityDataBackups = _Delegate._cityData.mutableCopy() as! NSMutableArray
        if _Delegate._tableView != nil{
    _Delegate._tableView.reloadData()
        }
        
    }
        
    
    
}
