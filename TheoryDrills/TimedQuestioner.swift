//
//  TimedQuestioner.swift
//  TheoryDrills
//
//  Created by Greg Pascale on 1/21/19.
//  Copyright © 2019 Greg Pascale. All rights reserved.
//

import Foundation

enum PlayStatus {
  case Playing
  case Paused
  case Stopped
}

protocol TimedQuestionerDelegate {
  func shouldAskQuestion(question: Question)
  func shouldShowAnswer(question: Question)
  func playStatusDidChange(newStatus: PlayStatus)
}

class TimedQuestioner  {
  
  var questioner : Questioner!
  var timer : PauseableTimer!
  var delegate: TimedQuestionerDelegate!
  var currentQuestion: Question!
  var progress : Float {
    get {
      return Float((self.timer.timeLeft) / self.timer.timeInterval)
    }
  }
  var playStatus : PlayStatus = PlayStatus.Stopped {
    didSet {
      if (playStatus == oldValue) {
        return
      }
      
      switch(playStatus) {
        case .Playing:
          switch(oldValue) {
          case .Paused:
            self.timer.resume()
          case .Stopped:
            self.doAskQuestion()
          default:
            print("fuck you, swift")
          }
        case .Paused:
          self.timer.pause()
        case .Stopped:
          self.timer.invalidate()
      }
      
      self.delegate.playStatusDidChange(newStatus: playStatus)
    }
  }
  
  init(delegate: TimedQuestionerDelegate,
       questionGenerator: Questioner) {
    self.delegate = delegate
    self.questioner = questionGenerator
  }
  
  private func doAskQuestion() {
    self.currentQuestion = self.questioner.askQuestion()
    self.timer = PauseableTimer.init(timeInterval: 7, block: { _ in
      self.doAnswer()
    })
    self.delegate.shouldAskQuestion(question: self.currentQuestion)
  }
  
  private func doAnswer() {
    self.delegate.shouldShowAnswer(question: self.currentQuestion)
    self.timer = PauseableTimer.init(timeInterval: 3, block: { _ in
      self.doAskQuestion()
    })
  }
  
  func play() {
    self.playStatus = .Playing
  }
  
  func pause() {
    self.playStatus = .Paused
  }
  
  func stop() {
    self.playStatus = .Stopped
  }
  
  
}
