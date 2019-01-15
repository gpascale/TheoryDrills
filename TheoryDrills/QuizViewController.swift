//
//  ViewController.swift
//  TheoryDrills
//
//  Created by Greg Pascale on 1/12/19.
//  Copyright © 2019 Greg Pascale. All rights reserved.
//

import UIKit
import JavaScriptCore
import AVKit

enum PlayStatus {
    case Playing
    case Paused
    case Stopped
}

class QuizViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questioner = Questioner()
        self.speaker = AVSpeechSynthesizer()
        self.speechUtils = SpeechUtils()
    }
    
    func play() {
        self.questionTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true, block: { (r) in
            self.askQuestion()
        })
        self.askQuestion()
        self.playPauseButton.title = "Pause"
        self.playStatus = .Playing
        
        // Access the shared, singleton audio session instance
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure the audio session for movie playback
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: AVAudioSession.Mode.spokenAudio,
                                    options: [])
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }

    }
    
    func pause() {
        self.questionTimer.invalidate()
        self.answerTimer.invalidate()
        self.progressTimer.invalidate()
        self.progressView.progress = 0
        self.playPauseButton.title = "Play"
        self.playStatus = .Paused
        self.questionTextLabel.text = ""
        self.answerTextLabel.text = ""
    }
    
    func askQuestion() {
        (self.question, self.answer) = self.questioner.askQuestion()
    
        self.questionTextLabel.text = question
        self.answerTextLabel.text = ""
        
        self.speaker.speak(AVSpeechUtterance(string: self.speechUtils.fix(text: question)))
        
        self.answerTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (r) in
            self.speakAnswer()
        })
        
        self.questionStart = Date()
        self.progressTimer?.invalidate()
        self.progressTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { _ in
            let timeElapsed = Date().timeIntervalSince(self.questionStart)
            self.progressView.progress = Float(1.0 - (timeElapsed / 5.0))
        })
        self.progressView.progress = 1
    }
    
    func speakAnswer() {
        if (self.speaker.isSpeaking) {
            self.speaker.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        self.speaker.speak(AVSpeechUtterance(string: self.speechUtils.fix(text: self.answer)))
        self.answerTextLabel.text = self.answer
    }

    @IBAction func skipCurrentQuestion(_ sender: Any) {
        if (!self.answerTimer.isValid) {
            return
        }
        self.speakAnswer()
        self.questionTimer.invalidate()
        self.progressTimer.invalidate()
        self.answerTimer.invalidate()
        self.progressView.progress = 0
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.questionTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true, block: { _ in
                self.askQuestion()
            })
            self.askQuestion()
        }
    }
    
    @IBAction func togglePlayPause(_ sender: UIBarButtonItem) {
        if (self.playStatus == .Paused) {
            self.play()
        }
        else if (self.playStatus == .Playing) {
            self.pause()
        }
    }
    
    
    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var question: String = ""
    var answer: String = ""
    var playStatus : PlayStatus = PlayStatus.Paused
    var questioner : Questioner!
    var questionTimer : Timer!
    var answerTimer: Timer!
    var progressTimer: Timer!
    var questionStart: Date!
    var speaker : AVSpeechSynthesizer!
    var speechUtils : SpeechUtils!
}

