//
//  PauseableTimer.swift
//  TheoryDrills
//
//  Created by Greg Pascale on 1/21/19.
//  Copyright © 2019 Greg Pascale. All rights reserved.
//

import Foundation

class PauseableTimer {
    
    var timer: Timer!
    let block: ((Timer) -> Void)!
    private(set) var timeInterval: TimeInterval
    private(set) var isPaused: Bool {
        didSet {
            if (isPaused == oldValue) {
                return
            }
            if (isPaused) {
                self._timeLeft = self.timer.fireDate.timeIntervalSinceNow
                self.timer.invalidate()
            }
            else {
                self.timer = createTimer(timeInterval: self._timeLeft)
            }
        }
    }
    var _timeLeft: TimeInterval!
    var timeLeft : TimeInterval {
        get {
            return (self.isPaused)
                ? self._timeLeft
                : self.timer.fireDate.timeIntervalSinceNow
        }
    }
    
    init(timeInterval: TimeInterval, block: ((Timer) -> Void)!) {
        self.timeInterval = timeInterval
        self.block = block
        self.isPaused = false
        self.timer = self.createTimer(timeInterval: timeInterval)
    }
    
    func pause() {
        self.isPaused = true
    }
    
    func resume() {
        self.isPaused = false
    }
    
    func isValid() -> Bool {
        return self.timer != nil ? self.timer.isValid : false
    }
    
    func invalidate() {
        self.timer.invalidate()
    }
    
    private func createTimer(timeInterval: TimeInterval) -> Timer! {
        return Timer.scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: false,
            block: block
        )
    }
}
