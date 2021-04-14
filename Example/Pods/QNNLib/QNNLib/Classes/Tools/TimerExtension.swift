//
//  TimerExtension.swift
//  QNN
//
//  Created by ymy on 2017/7/3.
//  Copyright © 2017年 qianshengqian. All rights reserved.
//

public extension Timer {
    //  定时器暂停
    func pauseTimer() {
        guard self.isValid else { return }
        self.fireDate = Date.distantFuture
    }
    
    //  定时器重启
    func resumeTimer() {
        guard self.isValid else { return }
        self.fireDate = Date.distantPast
    }
    
    //  一段时间之后重启定时器
    func resumeTimerAfterTimeIntarval(timeIntarval: TimeInterval) {
        guard self.isValid else { return }
        self.fireDate = Date(timeIntervalSinceNow: timeIntarval)
    }
}
