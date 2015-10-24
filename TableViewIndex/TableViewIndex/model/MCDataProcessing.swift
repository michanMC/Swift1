//
//  MCDataProcessing.swift
//  广州铁路
//
//  Created by michan on 15/3/8.
//  Copyright (c) 2015年 MC. All rights reserved.
//

import UIKit

class MCDataProcessing: NSObject {
    weak var _Delegate:
    SelectStationViewController?
    
    
   // #pragma mark-记录经常搜索的词、站名
    func historySource(Source:NSString){
        
        var path = NSHomeDirectory() + "/Documents/constantStation.plist"
        
        var array = NSArray(contentsOfFile: path)
        
        if array == nil{
    var arr = NSArray()
    arr.writeToFile(path, atomically: true)
    array = NSArray(contentsOfFile: path)

        }
        var users = NSMutableArray(array: array!)
        var user = NSMutableDictionary()
    
        if users.count > 10{
            users.removeAllObjects()
            _Delegate?._historyArray.removeAllObjects()
        }
        else{
            _Delegate?._historyArray.addObject(Source)
            for obj in users
            {
                if Source.isEqualToString(obj.objectForKey("key") as! String)
                {
                   return
                }
            }
            user.setObject(Source, forKey: "key")
            users.addObject(user)
        }
        users.writeToFile(path, atomically: true)
        
    }
    //#pragma mark - 记录关注
   // -(void)attentionBureauStr:(NSString *)bureauStr telCode:(NSString*)telCode stationsName:(NSString *)stationsName bureauLetter:(NSString *)bureauLetter areaCode:(NSString *)areaCode
    func attentionBureauStr(BureauStr bureauStr:NSString , TelCode telCode:NSString,StationsName stationsName:NSString,BureauLetter bureauLetter:NSString, AreaCode areaCode:NSString){
        var path = NSHomeDirectory() + "/Documents/AttentionStation.plist"
        var array = NSArray(contentsOfFile: path)
        
        if array == nil{
            var arr = NSArray()
       arr.writeToFile(path, atomically: true)
            array = NSArray(contentsOfFile: path)
            
        }
        var users = NSMutableArray(array: array!)
        
        var user = NSMutableDictionary()
        for obj in users
        {
            if stationsName.isEqualToString(obj.objectForKey("Name")as! String)
            {
                
               _Delegate?._tableView.reloadData()
                return
                
            }
        }
        user.setObject(stationsName, forKey: "Name")
        user.setObject(bureauStr, forKey: "Bureau_name")
        user.setObject(telCode, forKey: "TelCode")
        user.setObject(bureauLetter, forKey: "Bureau_code")
        user.setObject(areaCode, forKey: "AreaCode")
        users.addObject(user)
        users.writeToFile(path, atomically: true)
        _Delegate?.lodaAttention(true)
        
        
    }
    func deleteAttentionStationsName(stationsName:NSString){
        var path = NSHomeDirectory() + "/Documents/AttentionStation.plist"
        var array = NSArray(contentsOfFile: path)
        
        if array == nil{
            return
        }
        var users = NSMutableArray(array: array!)
        for obj in users{
            if stationsName.isEqualToString(obj.objectForKey("Name")as! String){
                
                users.removeObject(obj)
                users.writeToFile(path, atomically: true)
                _Delegate?.lodaAttention(true)
                return
                
            }
        }
    }
    
    func 记录车次(车次:NSString){
        var path = NSHomeDirectory() + "/Documents/checijilu.plist"
        
        var array = NSArray(contentsOfFile: path)
        
        if array == nil{
            var arr = NSArray()
            arr.writeToFile(path, atomically: true)
            array = NSArray(contentsOfFile: path)
            
        }
        var users = NSMutableArray(array: array!)
        var user = NSMutableDictionary()
        users.removeAllObjects()
        user.setObject(车次, forKey: "checi")
         users.addObject(user)
        users.writeToFile(path, atomically: true)
        
        
    }
    func 记录候车车次(车次:NSString ,车站:NSString){
        var path = NSHomeDirectory() + "/Documents/houchechecijilu.plist"
        
        var array = NSArray(contentsOfFile: path)
        
        if array == nil{
            var arr = NSArray()
            arr.writeToFile(path, atomically: true)
            array = NSArray(contentsOfFile: path)
            
        }
        var users = NSMutableArray(array: array!)
        var user = NSMutableDictionary()
        users.removeAllObjects()
        user.setObject(车次, forKey: "checi")
        user.setObject(车站, forKey: "chezhan")
        users.addObject(user)
        users.writeToFile(path, atomically: true)
  
        
        
    }
    
    
    
}
