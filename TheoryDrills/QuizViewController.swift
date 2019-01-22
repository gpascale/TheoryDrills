//
//  ViewController.swift
//  TheoryDrills
//
//  Created by Greg Pascale on 1/12/19.
//  Copyright © 2019 Greg Pascale. All rights reserved.
//

import UIKit
import JavaScriptCore

class QuizViewController: UIViewController, TimedQuestionerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.timedQuestioner = TimedQuestioner(delegate: self, questionGenerator: Questioner())
    self.speaker = QuestionSpeaker(speechUtils: SpeechUtils())
  }
  
  func playStatusDidChange(newStatus: PlayStatus) {
    switch(newStatus) {
    case .Playing:
      self.playPauseButton.title = "Pause"
      self.progressTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { _ in
        self.progressView.progress = self.timedQuestioner.progress
      })
    case .Paused:
      self.timedQuestioner.pause()
      self.progressTimer.invalidate()
      self.playPauseButton.title = "Play"
    default:
      self.playPauseButton.title = "Play"
      self.progressTimer.invalidate()
      self.questionTextLabel.text = ""
      self.answerTextLabel.text = ""
    }
  }

  func shouldAskQuestion(question: Question) {
    self.questionTextLabel.text = question.question
    self.answerTextLabel.text = ""
    self.speaker.speak(text: question.question)
  }
  
  func shouldShowAnswer(question: Question) {
    self.answerTextLabel.text = question.answer
    if (!self.isSilent) {
      self.speaker.speak(text: question.answer, interrupt: true)
    }
  }
  
  @IBAction func skipCurrentQuestion(_ sender: Any) {
//    if (!self.answerTimer.isValid) {
//      return
//    }
//    self.speakAnswer()
//    self.questionTimer.invalidate()
//    self.progressTimer.invalidate()
//    self.answerTimer.invalidate()
//    self.progressView.progress = 0
//    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
//      self.questionTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true, block: { _ in
//        self.askQuestion()
//      })
//      self.askQuestion()
//    }
  }
  
  @IBAction func togglePlayPause(_ sender: UIBarButtonItem) {
    print("toggle", self.timedQuestioner.playStatus)
    switch(self.timedQuestioner.playStatus) {
    case .Stopped, .Paused:
      self.timedQuestioner.play()
    case .Playing:
      self.timedQuestioner.pause()
    }
  }
  
  
  @IBOutlet weak var playPauseButton: UIBarButtonItem!
  @IBOutlet weak var questionTextLabel: UILabel!
  @IBOutlet weak var answerTextLabel: UILabel!
  @IBOutlet weak var progressView: UIProgressView!
  
  var questioner: Questioner!
  var timedQuestioner: TimedQuestioner!
  var progressTimer: Timer!
  var speaker : QuestionSpeaker!
  var isSilent: Bool = false
    
}

