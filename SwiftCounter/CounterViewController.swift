//
//  CounterViewController.swift
//  SwiftCounter
//
//  Created by kaka on 15/4/19.
//  Copyright (c) 2015年 kaka. All rights reserved.
//

import UIKit

class CounterViewController : UIViewController{
    
    var timeLabel: UILabel?
    var timeButtons: [UIButton]?
    var startStopButton: UIButton?
    var clearButton: UIButton?
    var timer: NSTimer?
    var isCounting: Bool = false {
        willSet(newVal){
            if newVal{
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true)
            }else{
                timer?.invalidate()
                timer = nil
            }
            setSettingButtonsEnabled(!newVal)
            
        }
    }
    
    var remainingSeconds: Int = 0 {
        willSet(newSeconds){
            if newSeconds > 0 {
                let mins = newSeconds / 60
                let seconds = newSeconds % 60
                self.timeLabel!.text = NSString(format: "%02d:%02d", mins, seconds)
            }else{
                self.timeLabel!.text = "00:00"
            }

        }
    }
    
    let timeButtonInfos = [("1分", 60), ("3分", 180), ("5分钟", 300), ("秒", 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setupTimeLabel()
        setuptimeButtons()
        setupActionButtons()

    }
    
    func setupTimeLabel(){
        timeLabel = UILabel()
        timeLabel!.text = "00:00"
        timeLabel!.textColor = UIColor.whiteColor()
        timeLabel!.font = UIFont(name: "", size:80)
        timeLabel!.backgroundColor = UIColor.blackColor()
        timeLabel!.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(timeLabel!)
    }
    
    func setuptimeButtons(){
        var buttons = [UIButton]()
        for(index, (title, _)) in enumerate(timeButtonInfos){
            let button: UIButton = UIButton()
            button.tag = index
            button.setTitle("\(title)", forState: .Normal)
            button.backgroundColor = UIColor.orangeColor()
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            button.addTarget(self, action: "timeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            buttons.append(button)
            
            self.view.addSubview(button)
        }
        timeButtons = buttons
    }
    
    func setupActionButtons() {
        
        startStopButton = UIButton()
        startStopButton!.backgroundColor = UIColor.redColor()
        startStopButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        startStopButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        startStopButton!.setTitle("启动/停止", forState: UIControlState.Normal)
        startStopButton!.addTarget(self, action: "startStopButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(startStopButton!)
        
        clearButton = UIButton()
        clearButton!.backgroundColor = UIColor.redColor()
        clearButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        clearButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        clearButton!.setTitle("复位", forState: UIControlState.Normal)
        clearButton!.addTarget(self, action: "clearButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(clearButton!)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        timeLabel!.frame = CGRectMake(10, 40, self.view.bounds.size.width-20, 120)
        
        let gap = ( self.view.bounds.size.width - 10*2 - (CGFloat(timeButtons!.count) * 64) ) / CGFloat(timeButtons!.count - 1)
        for (index, button) in enumerate(timeButtons!) {
            let buttonLeft = 10 + (64 + gap) * CGFloat(index)
            button.frame = CGRectMake(buttonLeft, self.view.bounds.size.height-120, 64, 44)
        }
        
        startStopButton!.frame = CGRectMake(10, self.view.bounds.size.height-60, self.view.bounds.size.width-20-100, 44)
        clearButton!.frame = CGRectMake(10+self.view.bounds.size.width-20-100+20, self.view.bounds.size.height-60, 80, 44)
        
    }
    
    func startStopButtonTapped(sender: UIButton!) {
        isCounting = !isCounting
        if isCounting{
            createAndFireLocalNotificationAfterSeconds(remainingSeconds)
        }else{
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    
    func clearButtonTapped(sender: UIButton!) {
        remainingSeconds = 0
    }
    
    func timeButtonTapped(sender: UIButton!) {
        println(sender.tag)
        let(_, seconds) = timeButtonInfos[sender.tag]
        remainingSeconds += seconds
    }
    
    func updateTimer(timer: NSTimer) {
        remainingSeconds -= 1
        if(remainingSeconds <= 0){
            self.isCounting = false
            self.timeLabel?.text = "00:00"
            self.remainingSeconds = 0
            let alert = UIAlertView()
            alert.title = "计时完成！"
            alert.message = ""
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func setSettingButtonsEnabled(enabled: Bool){
        for button in self.timeButtons!{
            button.enabled = enabled
            button.alpha = enabled ? 1.0 : 0.3
        }
        clearButton!.enabled = enabled
        clearButton!.alpha = enabled ? 1.0 : 0.3
        
    }
    
    func createAndFireLocalNotificationAfterSeconds(seconds: Int){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notification = UILocalNotification()
        let timeIntervalSinceNow = NSNumber(integer: seconds).doubleValue
        notification.fireDate = NSDate(timeIntervalSinceNow:timeIntervalSinceNow)
        notification.timeZone = NSTimeZone.systemTimeZone()
        notification.alertBody = "计时完成！";
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}
