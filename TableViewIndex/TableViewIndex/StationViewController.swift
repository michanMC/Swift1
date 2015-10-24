//
//  StationViewController.swift
//  广州铁路
//
//  Created by michan on 15/3/19.
//  Copyright (c) 2015年 MC. All rights reserved.
//
//protocol StationViewCtlReturnedValue :NSObjectProtocol
//{
//    
//    func sendreturnedValue(InfoDic:NSMutableDictionary)
//    
//    
//}

import UIKit
@objc protocol StationViewCtlReturnedValue {
    
    optional  func sendreturnedValue(InfoDic:NSMutableDictionary)
    
}

class StationViewController: UIViewController,SelectStationViewDelegate,UITableViewDataSource,UITableViewDelegate ,UITextFieldDelegate{
    let Bureau_code = "Bureau_code"
    let Bureau_name = "Bureau_name"
    let ID          = "ID"
    let Name        = "Name"
    let Shortkey    = "Shortkey"
    let AreaCode    = "AreaCode"
    let Levels      = "Levels"
    let TelCode     = "TelCode"
    //搜索stationData
    var _stationSearchArray:
    NSMutableArray!
    //记录曾选择的station
    var _historyArray:
    NSMutableArray!
    //关注stationData
    var _attentionArray:
    NSMutableArray!
    //SectionIndexArray
    var _arraySection:
    NSMutableArray!
    //section的关键字
    var _keyStr:
    NSString!
    var _inhaulArray:
    NSArray!
    var _cityData:
    NSMutableArray!
    //备份
    var _cityDataBackups:
    NSMutableArray!
    
    var _dataSource:
    NSMutableArray!


    
    //输入框
    var _textField:
    UITextField!
    //搜索时最终输入的Str
    var _finalImportStr:
    NSString!
    var _tableView:
    SelectStationView!
    
    var _siteState:
    SiteState!

//    var _SaerchModel:
//    MCSaerchModel!
//    var _DataProcessingModel:
//    MCDataProcessing!
    var _Delegate:
    StationViewCtlReturnedValue?

    
    
    
    var _activity:
    UIActivityIndicatorView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
       
        _cityData = NSMutableArray()
        _cityDataBackups = NSMutableArray()
        _stationSearchArray =  NSMutableArray()
        _attentionArray =  NSMutableArray()
        _arraySection = NSMutableArray()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func headView() -> UIView{
        
        
        var x:CGFloat = 0
        var y:CGFloat = 64
        var width = self.view.frame.width
        var height:CGFloat = 40
        var view = UIView(frame: CGRectMake(x, y
            , width, height))
        view.backgroundColor = CommonUtil.RGBA(220, g: 220, b: 220, a: 1)
        _textField = UITextField(frame: CGRectMake(10
            , 5, width - 20, 30))
        _textField.borderStyle = UITextBorderStyle.RoundedRect
        _textField.placeholder = "输入站名/简拼/区号，如广州/GZ/020"
        _textField.adjustsFontSizeToFitWidth = true
        _textField.delegate = self

        _textField.addTarget(self, action: "textFieldEditChanged:", forControlEvents: UIControlEvents.EditingChanged)
        view.addSubview(_textField)
  
        
        return view
    }
    func prepareUI(){
        _activity = UIActivityIndicatorView()
        _activity.center = self.view.center
        _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        _activity.startAnimating()
        self.view.addSubview(_activity)
   
        self.view.addSubview(self.headView())
        
    }
    func prepareTableView(){
        var x:CGFloat = 0
        var y :CGFloat = 64 + 40
        var width:CGFloat = self.view.frame.width
        var height = self.view.frame.height - y
        _tableView = SelectStationView(frame: CGRectMake(x
            , y, width, height))
        _tableView.Delegate(self)
        self.view.addSubview(_tableView)
        
    }

    //MARK: 实时监控textField的值
    func textFieldEditChanged(textField:UITextField){
        
        _finalImportStr = textField.text
        self.loadData()
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //_finalImportStr = textField.text
    
        if _cityData.count == 0{
            _finalImportStr = ""
            self.loadData()
        }
        return true
       // self.loadData()
    }
    //MARK:搜索刷新
    func loadData(){
        _tableView.userInteractionEnabled = false
        
        self.loadData(_finalImportStr)
        
    }
    func sectionIndexTitlesForABELTableView(tableView:SelectStationView) -> NSArray{
        
        if _siteState == SiteState.SiteState_search{
            if _keyStr != nil{
                if ((_keyStr as NSString).substringToIndex(1)as NSString ).isEqualToString("区"){
                    return NSArray()
                    
                }
                else
                {
                    return [_keyStr]
                }
            }
        }
        //  println(_inhaulArray)
        if _inhaulArray == nil{
            return NSArray()
        }
        var array = NSMutableArray(array: _inhaulArray)
        array.replaceObjectAtIndex(array.count - 1, withObject: "#")
        if _cityData.count > _inhaulArray.count{
            array.insertObject("注", atIndex: 0)
        }
        return array

    }
    
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
            _stationSearchArray.addObject(Namestr)
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
        _inhaulArray  =  arrayDpe.KeyArray(keyArray as [AnyObject])
        _arraySection.setArray(_inhaulArray as [AnyObject])
        _arraySection.replaceObjectAtIndex(_arraySection.count - 1, withObject: "#")
        
        _database.close()
        self.grouping()
        
        
    }
    func grouping(){
        var dicKey = NSMutableDictionary()
        
        for keyStr in  _inhaulArray{
            
            var arrayData = NSMutableArray()
            dicKey.setObject(arrayData, forKey: (keyStr as! String))
            
        }
        for citydic in _dataSource{
            var keyStr = (citydic.objectForKey(Shortkey) as! NSString).substringToIndex(1)
            dicKey.objectForKey(keyStr)?.addObject(citydic)
            
        }
        for key in _inhaulArray{
            var array: AnyObject? = dicKey.objectForKey(key as! NSString)
            
            _cityData.addObject(array!)
        }
        if _attentionArray.count > 0 {
            _cityData.insertObject(_attentionArray, atIndex: 0)
            _arraySection.insertObject("关注", atIndex: 0)
        }
        
        
        //  println("===\(_Delegate._cityData)")
        
        _cityDataBackups = _cityData.mutableCopy() as! NSMutableArray
        if _tableView != nil{
        _tableView.reloadData()
        }
        
    }
    func loadData(Str:NSString){
        // str = str.uppercaseString()
        
        var str:NSString? =  Str.uppercaseString
        // println(str)
        _cityData.removeAllObjects()
        if str!.isEqualToString(""){
            _cityData = _cityDataBackups.mutableCopy() as! NSMutableArray
            _siteState = SiteState.SiteState_all
            self.lodaAttention(true)
            return
        }
        
        
        var array = _dataSource
        var firstStr = str!.substringToIndex(1)
        
        for citydic in array{
            
            var strKey:
            NSString?
            if self.isPureInt(firstStr) == true {
                
                strKey = citydic.objectForKey("AreaCode") as? NSString
                
                _keyStr = "区号-" + (str as! String)
                
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
            if strKey?.length >= str?.length {
                
                var index:Int = str!.length
                var ss = ((strKey as NSString!).substringToIndex(index)as NSString).isEqualToString(str as! String)
                
                if ss {
                    if self.isPureInt(firstStr) == false {
                        _keyStr = (citydic.objectForKey("Shortkey") as? NSString)!.substringToIndex(1)
                        
                    }
                    _cityData.addObject(citydic)
                    
                }
            }
            
            
            
        }
        
        if _cityData.count > 0 {
            _siteState = SiteState.SiteState_search
            for var i = 0 ; i < _cityData.count; i++
            {
                
                var cityStr: AnyObject? = _cityData.objectAtIndex(i).objectForKey("Name")
                if _historyArray.containsObject(cityStr!) == true{
                    _cityData.exchangeObjectAtIndex(0, withObjectAtIndex: i)
                    break
                }
            }
            
        }
        
        // println(_Delegate._cityData.count)
        _tableView.reloadData()
        }
    
    func isPureInt(string:NSString)->Bool{
        var scan = NSScanner(string: string as String)
        var val = Int32()
        // var bb = scan.scanInt(&val)
        
        return scan.scanInt(&val) && scan.atEnd
        
    }

    //MARK:加载关注
    func lodaAttention(AddAttention:Bool){
        
        var path = NSHomeDirectory() + "/Documents/AttentionStation.plist"
        var array = NSArray(contentsOfFile: path)
        _attentionArray.removeAllObjects()
        
        
        for var i = 0 ; i < array?.count ; i++ {
            _attentionArray.addObject(array!.objectAtIndex(i))
            
        }
        
        //保证_attentionArray有值，是否AddAttention 不在SiteTey_search状态下而进行操作
        if _attentionArray.count > 0 && AddAttention && _siteState != SiteState.SiteState_search{
            if _cityData.count == _inhaulArray.count{
                _cityData.insertObject(_attentionArray, atIndex: 0)
                _cityDataBackups.insertObject(_attentionArray, atIndex: 0)
                _arraySection.insertObject("关注", atIndex: 0)
            }
            else
            {
                _cityData.replaceObjectAtIndex(0, withObject: _attentionArray)
                _cityDataBackups.replaceObjectAtIndex(0, withObject: _attentionArray)
            }
            
        }
        //如果_attentionArray没值，_arraySection第一个Key是@“关注”时把关注Section移除
        if _arraySection.count > 0{
            if _attentionArray.count == 0 && _arraySection.objectAtIndex(0).isEqualToString("关注"){
                _arraySection.removeObjectAtIndex(0)
                _cityData.removeObjectAtIndex(0)
                _cityDataBackups.removeObjectAtIndex(0)
                
            }
        }
        
        if _tableView != nil{
            _tableView.reloadData()
        }
    }
    //MARK: -  获取文件中的信息
    func userInfo()-> NSArray{
        
        var path = NSHomeDirectory() + "/Documents/constantStation.plist"
        var users = NSArray(contentsOfFile: path)
        if users == nil{
            return NSArray()
        }
        return users!
        
    }
    //MARK:曾选择的station
    func lodaHistory(){
        
        _historyArray = NSMutableArray()
        var _historyInfo = self.userInfo()
        
        for obj in _historyInfo{
            _historyArray.addObject(obj.objectForKey("key")!)
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.prepareUI()
        self.title = "选择车站"
        var _globalQueue:
        dispatch_queue_t!
        var _mainQueue:
        dispatch_queue_t!
        _mainQueue = dispatch_get_main_queue()
        _globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(_globalQueue, { () -> Void in
//            self._dataModel = MCmodel()
//            self._dataModel._Delegate = self
            //进来就取本地的关注的stations数据
            self.lodaAttention(false)
            //取数据库数据
            self.lodaData()
            //提取History_stations在搜索是提高优先级
            self.lodaHistory()
            self._siteState = SiteState.SiteState_all
            
            
            dispatch_async(_mainQueue, { () -> Void in
                self.prepareTableView()
                
            })
            
        })
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
     _textField.resignFirstResponder()
    }
    // MARK:TableView代理
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let NewsIdentity = "selectIdentity"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(NewsIdentity)as?UITableViewCell
        if (cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: NewsIdentity)
            
        }
        
        var dic:
        NSDictionary!
        var stationNameStr:
        NSString!
        if _siteState == SiteState.SiteState_search
        {
            // println(_cityData.count,indexPath.row)
            
            if _cityData.count > indexPath.row
            {
                
                dic = _cityData.objectAtIndex(indexPath.row) as! NSDictionary
                
                stationNameStr = dic.objectForKey("Name") as? NSString
            }
        }
            
            
        else{
            
            
            if _cityData.count > indexPath.section{
                
                var array = _cityData.objectAtIndex(indexPath.section) as! NSArray
                
                dic = array.objectAtIndex(indexPath.row) as! NSDictionary
                stationNameStr = dic.objectForKey("Name") as? NSString
                
            }
        }
        // println(stationNameStr)
        if stationNameStr != nil{
            cell?.textLabel?.text = stationNameStr as String
            var Bureau_name = dic.objectForKey("Bureau_name")as! String
            var AreaCode = dic.objectForKey("AreaCode") as! String
            
            var  detailTextStr:String = "\(Bureau_name as String)-\(AreaCode as String)"
            //println(detailTextStr)
            
            cell?.detailTextLabel?.text = detailTextStr
        }
        _tableView.userInteractionEnabled = true
        _activity.stopAnimating()
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var name:NSString!
        var Bureau_code:NSString!
        var TelCode:NSString!
        var dic:NSMutableDictionary?
        
        
        
        if _siteState == SiteState.SiteState_search
        {
        dic = _cityData.objectAtIndex(indexPath.row) as? NSMutableDictionary
            
            
        }
        else{
            var array: AnyObject = _cityData.objectAtIndex(indexPath.section)
            dic = array.objectAtIndex(indexPath.row) as? NSMutableDictionary
           

        }
        name = dic!.objectForKey("Name")as? NSString
        Bureau_code = dic!.objectForKey("Bureau_code")as? NSString
        TelCode = dic!.objectForKey("TelCode")as? NSString
        println(name)
        
        var Dic = NSMutableDictionary()
        Dic.setObject(name!, forKey: "station")
        Dic.setObject(TelCode!, forKey: "telcode")
        Dic.setObject(Bureau_code!, forKey: "Bureau_code")

        _Delegate?.sendreturnedValue!(Dic)
        //_Delegate?.sendReturnedValue(Dic)
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // println(section)
        if _siteState == SiteState.SiteState_search{
            return _cityData.count
        }
        else
        {
            var array: AnyObject = _cityData.objectAtIndex(section)
            return array.count
        }
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if _siteState == SiteState.SiteState_search{
            return 1
        }
        return _cityData.count
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var myView = UIView()
        myView.backgroundColor = CommonUtil.RGBA(25, g: 173, b: 239, a: 0.9)
        var titleLabel = UILabel(frame: CGRectMake(10, 0, 90, 22))
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.backgroundColor = UIColor.clearColor()
        if _siteState == SiteState.SiteState_search
        {
            titleLabel.text = _keyStr as String
            
        }
        else
        {
            titleLabel.text = _arraySection.objectAtIndex(section)as? String
        }
        myView.addSubview(titleLabel)
        return myView
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
