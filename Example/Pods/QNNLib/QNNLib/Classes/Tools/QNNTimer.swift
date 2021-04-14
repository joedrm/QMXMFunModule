//
//  QNNTimer.swift
//  QNN
//
//  Created by ymy on 2017/7/3.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

import UIKit

public class QNNTimer: NSObject {
    private var timer: Timer!
    public var timerFiredBlock: ((Any?)->Void)?
    
    public class func scheduledTimer(timeInterval: TimeInterval, userInfo: Any?, repeats: Bool,  actionBlock:@escaping ((Any?)->Void)) -> QNNTimer {
        let qnnTimer = QNNTimer()
        qnnTimer.timerFiredBlock = actionBlock
        
        qnnTimer.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: qnnTimer, selector: #selector(timerFired(timer:)), userInfo: userInfo, repeats: repeats)
        return qnnTimer
    }
    
    @objc func timerFired(timer: Timer) {
        timerFiredBlock?(timer.userInfo)
    }
    
    /// 销毁定时器
    public func invalidate() {
        if let _ = timer {
            timer.invalidate()
            timer = nil
        }
        timerFiredBlock = nil
    }
    
    /// 暂停定时器
    public func pauseTimer() {
        timer.pauseTimer()
    }
    
    /// 重启定时器
    public func resumeTimer() {
        timer.resumeTimer()
    }
    
    /// 一段时间后重启定时器
    public func resumeTimerAfterTimeIntarval(timeIntarval: TimeInterval) {
        timer.resumeTimerAfterTimeIntarval(timeIntarval: timeIntarval)
    }
    
    deinit {
        debugPrintOnly("QNNTimer---------deinit")
    }
}
