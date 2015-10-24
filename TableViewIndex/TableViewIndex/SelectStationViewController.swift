//
//  SelectStationViewController.swift
//  广州铁路
//
//  Created by michan on 15/3/5.
//  Copyright (c) 2015年 MC. All rights reserved.

protocol SelectStationViewCtlReturnedValue :NSObjectProtocol
{
    
    func sendreturnedValue(stationsInfoDic:NSMutableDictionary)
    
    
}
//
 enum TextFieldKey : Int {
    
    case StartKey
    case EndKey
}
enum SiteState : Int {
    
    case SiteState_search
    case SiteState_all
    
    
}

import UIKit

class SelectStationViewController: UIViewController,UITextFieldDelegate ,SelectStationViewDelegate{
    
    let ScreenW = UIScreen.mainScreen().bounds.width
    let ScreenH = UIScreen.mainScreen().bounds.height
    let HeadViewHeight:CGFloat = 50
    let NavigationHeight :CGFloat = 64
    let TextFieldX:CGFloat = 20
    let TextFieldY:CGFloat = 10
    let TextFieldHeight:CGFloat = 31
    let TextFieldChangeWidth = ( UIScreen.mainScreen().bounds.width
 - 60) / 3 * 2 + 5
    let TextFieldWidth = ( UIScreen.mainScreen().bounds.width
        - 40) / 3
    let TextFieldBackgroundColor = UIColor(red: 240 / 255, green: 248/255, blue: 255/255, alpha: 1)
    let TextFieldBorderColor = UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 1)
    let TextFieldPlaceholderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
    //MARK:属性
    var _textFieldKey:
    TextFieldKey?
    var _siteState:
    SiteState!
    var _Delegate:
    SelectStationViewCtlReturnedValue?
    
    
    
     //输入框
    var _textFieldStart:
    MCUITextField!
    var _textFieldEnd:
    MCUITextField!

    //搜索时最终输入的Str
    var _finalImportStr:
    NSString!
    //回调
    var _startBureau:
    NSString!
    var _startTelCode:
    NSString!

    var _destinationBureau:
    NSString!

    var _destinationTelCode:
    NSString!
    
    //输入的出发点是否有效
    var _isStartValid:
    Bool!
    var  _isEndValid:
    Bool!

    
    var _tableView:
    SelectStationView!
    //所有city/station   Array
    var _cityData:
    NSMutableArray!
    //备份
    var _cityDataBackups:
    NSMutableArray!
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
    
    var _dataModel:
    MCmodel!
    
    var _SaerchModel:
    MCSaerchModel!
    var _DataProcessingModel:
    MCDataProcessing!
    
    var _activity:
    UIActivityIndicatorView!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _SaerchModel = MCSaerchModel()
        _SaerchModel._Delegate = self
        
        
        _DataProcessingModel = MCDataProcessing()
        _DataProcessingModel._Delegate = self
        
        
        
        _cityData = NSMutableArray()
        _cityDataBackups = NSMutableArray()
        _stationSearchArray =  NSMutableArray()
        _attentionArray =  NSMutableArray()
        _arraySection = NSMutableArray()

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:UI
    func prepareUI(){
      self.title = "选择城市"
        self.view.backgroundColor = UIColor.whiteColor()
        var barButtonItem = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: "actionButton")
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.view.addSubview(self.headView())
        
        _activity = UIActivityIndicatorView()
        _activity.center = self.view.center
        _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        _activity.startAnimating()
        self.view.addSubview(_activity)
    }
    
    func prepareTableView(){
        var x:CGFloat = 0
        var y = HeadViewHeight + NavigationHeight
        var width:CGFloat = ScreenW
        var height = ScreenH - y
        _tableView = SelectStationView(frame: CGRectMake(x
            , y, width, height))
        _tableView.Delegate(self)
        self.view.addSubview(_tableView)
        
    }
    func headView() -> UIView{
        var x :CGFloat = 0
        var y = NavigationHeight
        var width = ScreenW
        var height = HeadViewHeight
        var changeWidth = TextFieldChangeWidth
        var view = UIView(frame: CGRectMake(x, y, width, height))
        x = TextFieldX
        y = TextFieldY
        width = TextFieldWidth
        height = TextFieldHeight
        var imageView = UIImageView(frame: CGRectMake(0, 0, 19, 19))
        imageView.image = UIImage(named: "start_station_icon_small")
        _textFieldStart = MCUITextField(frame: CGRectMake(x, y, changeWidth, height))
        _textFieldStart.leftview(imageView)
        _textFieldStart.borderStyle = UITextBorderStyle.RoundedRect
        _textFieldStart.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        _textFieldStart.autocorrectionType = UITextAutocorrectionType.No
        _textFieldStart.placeholder = "出发地 站名/简拼/区号"
        _textFieldStart.delegate = self
        _textFieldStart.adjustsFontSizeToFitWidth = true
        _textFieldStart.backgroundColor = TextFieldBackgroundColor
        _textFieldStart.layer.borderColor = TextFieldBorderColor.CGColor;
        _textFieldStart.layer.borderWidth = 0.5;
        _textFieldStart.layer.cornerRadius = 5;
        _textFieldStart.addTarget(self, action: "textFieldEditChanged:", forControlEvents: UIControlEvents.EditingChanged)
        view.addSubview(_textFieldStart)
        
        
        imageView = UIImageView(frame: CGRectMake(0, 0, 19, 19))
        imageView.image = UIImage(named: "end_station_icon_small")
        x += 2 * width
        
        
        
        _textFieldEnd = MCUITextField(frame: CGRectMake(x, y, width, height))
        _textFieldEnd.leftview(imageView)
        _textFieldEnd.borderStyle = UITextBorderStyle.RoundedRect
        _textFieldEnd.autocorrectionType = UITextAutocorrectionType.No
        _textFieldEnd.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        _textFieldEnd.placeholder = "目的地"
        _textFieldEnd.delegate = self
        _textFieldEnd.adjustsFontSizeToFitWidth = true
        _textFieldEnd.setValue(TextFieldPlaceholderColor, forKeyPath: "_placeholderLabel.textColor")
        _textFieldEnd.addTarget(self, action: "textFieldEditChanged:", forControlEvents: UIControlEvents.EditingChanged)
        view.addSubview(_textFieldEnd)

       // _textFieldKey = TextFieldKey.StartKey
        return view
        

        
    }
    //MARK:输入框动画
    func textFieldStartState(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self._textFieldEnd.frame = CGRectMake(self.TextFieldX + 2 * self.TextFieldWidth, self.TextFieldY, self.TextFieldWidth, self.TextFieldHeight)
            self._textFieldStart.frame = CGRectMake(self.TextFieldX, self.TextFieldY, self.TextFieldChangeWidth, self.TextFieldHeight)
            self._textFieldStart.backgroundColor = self.TextFieldBackgroundColor
        self._textFieldEnd.backgroundColor = UIColor.clearColor()
            self._textFieldStart.clearButtonMode = UITextFieldViewMode.Always
            self._textFieldEnd.clearButtonMode = UITextFieldViewMode.Never
            self._textFieldStart.layer.borderColor  = self.TextFieldBorderColor.CGColor
            self._textFieldStart.layer.borderWidth  = 0.5;
            self._textFieldStart.layer.cornerRadius = 5;
            self._textFieldEnd.layer.borderColor = UIColor.clearColor().CGColor;
            self._textFieldStart.placeholder = "出发地 站名/简拼/区号"
            //_textFieldStart水印颜色
            self._textFieldStart.setValue(UIColor.lightGrayColor(), forKeyPath: "_placeholderLabel.textColor")
           self._textFieldEnd.placeholder = "目的地"
            self._textFieldEnd.setValue(self.TextFieldPlaceholderColor, forKeyPath: "_placeholderLabel.textColor")
            
        })
        
    }
    func textFieldEndState(){
        
      var endX = TextFieldWidth + TextFieldX + 15
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            self._textFieldEnd.frame = CGRectMake(endX, self.TextFieldY, self.TextFieldChangeWidth, self.TextFieldHeight)
            self._textFieldStart.frame = CGRectMake(self.TextFieldX, self.TextFieldY, self.TextFieldWidth, self.TextFieldHeight)
            self._textFieldEnd.backgroundColor = self.TextFieldBackgroundColor
            self._textFieldStart.backgroundColor = UIColor.clearColor()
            self._textFieldEnd.clearButtonMode = UITextFieldViewMode.Always
            self._textFieldStart.clearButtonMode = UITextFieldViewMode.Never
            self._textFieldEnd.layer.borderColor = self.TextFieldBorderColor.CGColor
            self._textFieldEnd.layer.borderWidth = 0.5
            self._textFieldEnd.layer.cornerRadius = 5
            self._textFieldStart.layer.borderColor = UIColor.clearColor().CGColor
            self._textFieldEnd.placeholder = "目的地 站名/简拼/区号"
            self._textFieldStart.placeholder = "出发地"
            //UIColor * color =TextFieldPlaceholderColor;
            self._textFieldStart.setValue(self.TextFieldPlaceholderColor, forKeyPath: "_placeholderLabel.textColor")
            self._textFieldEnd.setValue(UIColor.lightGrayColor(), forKeyPath: "_placeholderLabel.textColor")
            

        })
        
    }
    //MARK: 回调
    func EV_OKOnClick(){
        var dic = NSMutableDictionary()
        dic.setObject(_textFieldStart.text as NSString, forKey: "start")
        dic.setObject(_startBureau ,forKey:"startBureau")
        dic .setObject(_startTelCode , forKey:"startTelCode")
        
        dic .setObject(_textFieldEnd.text as NSString ,forKey:"destination")
        dic .setObject(_destinationBureau ,forKey:"destinationBureau")
        dic .setObject(_destinationTelCode ,forKey:"destinationTelCode")
        
        _Delegate?.sendreturnedValue(dic)
    }
    //MARK:触发确定
    func  actionButton(){
        //判断输入出发地，目的地是否是为有效车站
        _isStartValid = _stationSearchArray.containsObject(_textFieldStart.text)
        _isEndValid = _stationSearchArray.containsObject(_textFieldEnd.text)
        
        //警告框Str
        var _warnStr = NSString()
        var alertView = UIAlertView(title: nil, message: nil, delegate: nil, cancelButtonTitle: "OK")
    //（出发点，目的地有效 || （出发点，目的地都为空时））就可以返回，反之提醒
        if (_isStartValid == true && _isEndValid == true) || ((_textFieldStart.text as NSString).length == 0) && ((_textFieldEnd.text as NSString).length == 0){
            //如果出发点或目的地不为空时值回调
            if( _textFieldStart.text as NSString).length > 0{
                self.EV_OKOnClick()
            }
            //出发点和目的地不能相同
            if (_textFieldStart.text as NSString).isEqualToString((_textFieldEnd.text as String)) == true && (_textFieldStart.text as NSString).length > 0  {
            alertView.message = "出发地和目的地不能相同"
                alertView.show()
            
            }
            else{
                self.navigationController?.popViewControllerAnimated(true)
            }

    
            
        }
        else
        {
            if _isStartValid == false{
                if( _textFieldStart.text as NSString).length == 0{
                    
                    _warnStr = "出发地不能为空"
                }
                else
                {
                   _warnStr = "出发站点无效"
                }
                
            }
            else if _isEndValid == false{
                
                if( _textFieldEnd.text as NSString).length == 0{
                    
                    _warnStr = "目的地不能为空"
                }
                else
                {
                    _warnStr = "目的站点无效"
                }
  
                
            }
            alertView.message = _warnStr as String
            alertView.show()
            
            
        }
        
    }
    
   //MARK: 实时监控textField的值
    func textFieldEditChanged(textField:UITextField){
        
        //每次textField的值改变时出发点，目的地视为无效车站，重新判断
        _isStartValid   = false
        _isEndValid     = false
        
        _finalImportStr = textField.text;
        
       // [self loadData];
        self.loadData()
        
    }
    //MARK:收键盘
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        self.resignFirst()
    }
    func resignFirst(){
        _textFieldStart.resignFirstResponder()
        _textFieldEnd.resignFirstResponder()
    }
    //MARK:UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        _tableView._tableView.setContentOffset(CGPointMake(0, 0), animated: false)
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        if _cityData.count == 0{
            _finalImportStr = ""
            self.loadData()
        }
        
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == _textFieldStart{
            
            _textFieldKey = TextFieldKey.StartKey
            
            //textField拉伸动画
            self.textFieldStartState()
        }
        else
        {
            
            
            //标志当前键盘是EndKey
            _textFieldKey = TextFieldKey.EndKey
            
            self.textFieldEndState()
            
        }
        _finalImportStr = textField.text;
        
        //刷新数据
        self .loadData()

    }
    //MARK:搜索刷新
    func loadData(){
      _tableView.userInteractionEnabled = false
        
       _SaerchModel.loadData(_finalImportStr)
        
    }
    
   // MARK:commitEditingStyle关注、删除
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if _siteState == SiteState.SiteState_search{
            
            var dic: AnyObject = _cityData.objectAtIndex(indexPath.row) as! NSDictionary
            //关注
           // var ss = dic.objectForKey("Bureau_name")as NSString
            _DataProcessingModel.attentionBureauStr(BureauStr: dic.objectForKey("Bureau_name")as! NSString, TelCode: dic.objectForKey("TelCode")as! NSString, StationsName: dic.objectForKey("Name")as! NSString, BureauLetter: dic.objectForKey("Bureau_code")as! NSString, AreaCode: dic.objectForKey("AreaCode")as! NSString)
            return
            
            
        }
        //判断是删除还是关注
        if _attentionArray.count > 0{
            if indexPath.section > 0{
                
                var array: AnyObject  = _cityData.objectAtIndex(indexPath.section)
                var dic: AnyObject = array.objectAtIndex(indexPath.row)
                //关注
                
                _DataProcessingModel.attentionBureauStr(BureauStr: dic.objectForKey("Bureau_name")as! NSString, TelCode: dic.objectForKey("TelCode")as! NSString, StationsName: dic.objectForKey("Name")as! NSString, BureauLetter: dic.objectForKey("Bureau_code")as! NSString, AreaCode: dic.objectForKey("AreaCode")as! NSString)

            }
            else{
                var array: AnyObject  = _cityData.objectAtIndex(indexPath.section)
                var dic: AnyObject = array.objectAtIndex(indexPath.row)
//删除
                _DataProcessingModel.deleteAttentionStationsName(dic.objectForKey("Name")as! NSString)
            }
            
        }
        else{
            var array: AnyObject  = _cityData.objectAtIndex(indexPath.section)
            var dic: AnyObject = array.objectAtIndex(indexPath.row)
            //关注
            
            _DataProcessingModel.attentionBureauStr(BureauStr: dic.objectForKey("Bureau_name")as! NSString, TelCode: dic.objectForKey("TelCode")as! NSString, StationsName: dic.objectForKey("Name")as! NSString, BureauLetter: dic.objectForKey("Bureau_code")as! NSString, AreaCode: dic.objectForKey("AreaCode")as! NSString)
        }

    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        if _siteState == SiteState.SiteState_search{
            return "关注"
        }
        if _attentionArray.count > 0{
            if indexPath.section > 0{
                return "关注"
            }
            else{
                return "删除"
            }
        }
        else{
            return "关注"
        }
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
                
                stationNameStr = dic.objectForKey("Name") as! NSString
                
                if stationNameStr.isEqualToString(_finalImportStr as String)
                {
                  if _textFieldKey == TextFieldKey.StartKey
                  {
                    
                    _startBureau = dic.objectForKey("Bureau_code") as! NSString
                    _startTelCode = dic.objectForKey("TelCode") as! NSString

                    }
                    else
                  {
                    _destinationBureau = dic.objectForKey("Bureau_code") as! NSString
                    _destinationTelCode = dic .objectForKey("TelCode") as! NSString
                    
                    
                    }
                    
                }
            }
        }
        
        
        else{
        
        
        if _cityData.count > indexPath.section{
            
          var array = _cityData.objectAtIndex(indexPath.section) as! NSArray
            
            dic = array.objectAtIndex(indexPath.row) as! NSDictionary
            stationNameStr = dic.objectForKey("Name") as! NSString
            
        }
        }
       // println(stationNameStr)
        if stationNameStr != nil{
        cell?.textLabel?.text = stationNameStr as? String
            var Bureau_name = dic.objectForKey("Bureau_name")as! NSString
            var AreaCode = dic.objectForKey("AreaCode") as! NSString
            
            var  detailTextStr:NSString = "\(Bureau_name)-\(AreaCode)"
            //println(detailTextStr)
            
            cell?.detailTextLabel?.text = detailTextStr as? String

        }
        _tableView.userInteractionEnabled = true
        _activity.stopAnimating()
        return cell!
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
            titleLabel.text = _keyStr as? String
        
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        if _siteState == SiteState.SiteState_search{
            
            var dic: AnyObject = _cityData.objectAtIndex(indexPath.row)
             //判断当前_textFieldKey
            if _textFieldKey == TextFieldKey.StartKey
            {
              _textFieldEnd.becomeFirstResponder()
                _textFieldStart.text = dic.objectForKey("Name")as? String
              _DataProcessingModel.historySource(_textFieldStart.text)
               _startBureau = dic.objectForKey("Bureau_code")as! NSString
            _startTelCode = dic.objectForKey("TelCode")as! NSString
                if (_textFieldEnd.text as NSString ).length == 0{
                    _textFieldKey = TextFieldKey.EndKey
                }
            }
            else if _textFieldKey == TextFieldKey.EndKey{
                if (_textFieldStart.text as NSString) == 0{
                    _textFieldKey = TextFieldKey.StartKey
                    _textFieldStart.becomeFirstResponder()
                    
                }
                _textFieldEnd.text = dic.objectForKey("Name")as? String
                _DataProcessingModel.historySource(_textFieldEnd.text)
                
                _destinationBureau = dic.objectForKey("Bureau_code")as! NSString
                _destinationTelCode = dic.objectForKey("TelCode")as! NSString
            }

            
        }
        else if _siteState == SiteState.SiteState_all
        {
            
            var array: AnyObject = _cityData.objectAtIndex(indexPath.section)
            var dic: AnyObject = array.objectAtIndex(indexPath.row)
            //判断当前_textFieldKey
            if _textFieldKey == TextFieldKey.EndKey
            {
                
                if (_textFieldStart.text as NSString).length == 0{
                    
                    _textFieldKey = TextFieldKey.StartKey
                    _textFieldStart.becomeFirstResponder()
                }
                _textFieldEnd.text = dic.objectForKey("Name")as? String
                _DataProcessingModel.historySource(_textFieldEnd.text)
           _destinationBureau = dic.objectForKey("Bureau_code")as! NSString
           _destinationTelCode = dic.objectForKey("TelCode")as! NSString
            
            }
            else{
                _startBureau = dic.objectForKey("Bureau_code")as! NSString
                _startTelCode = dic.objectForKey("TelCode")as! NSString
                if (_textFieldEnd.text as NSString).length == 0{
                   _textFieldKey = TextFieldKey.EndKey
                    self.textFieldEndState()
                    
                }
                _textFieldStart.text = dic.objectForKey("Name")as? String
                _DataProcessingModel.historySource(_textFieldStart.text)
            }
            
            
        }
    
         //_textFieldStart/_textFieldEnd不为空时触发
        if (_textFieldEnd.text as NSString).length > 0 && (_textFieldStart.text as NSString).length > 0{
            
           self.actionButton()
            
        }
    }
    
    
    
    func sectionIndexTitlesForABELTableView(tableView: SelectStationView) -> NSArray {
        
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        
        var _globalQueue:
        dispatch_queue_t!
        var _mainQueue:
        dispatch_queue_t!
        _mainQueue = dispatch_get_main_queue()
        _globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(_globalQueue, { () -> Void in
            self._dataModel = MCmodel()
            self._dataModel._Delegate = self
            //进来就取本地的关注的stations数据
            self.lodaAttention(false)
            //取数据库数据
            self._dataModel.lodaData()
            //提取History_stations在搜索是提高优先级
            self.lodaHistory()
            self._siteState = SiteState.SiteState_all
            

            dispatch_async(_mainQueue, { () -> Void in
                self.prepareTableView()

            })
            
        })
        
        
        
        // Do any additional setup after loading the view.
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
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
