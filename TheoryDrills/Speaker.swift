//
//  Speaker.swift
//  TheoryDrills
//
//  Created by Greg Pascale on 1/22/19.
//  Copyright © 2019 Greg Pascale. All rights reserved.
//

import Foundation
import AVFoundation

class QuestionSpeaker {
    
    // Access the shared, singleton audio session instance
    var session = AVAudioSession.sharedInstance()
    var speechSynth = AVSpeechSynthesizer()
    var speechUtils: SpeechUtils
    
    init(speechUtils: SpeechUtils!) {
        self.speechUtils = speechUtils
        do {
            // Configure the audio session for movie playback
            try self.session.setCategory(AVAudioSession.Category.playback,
                                    mode: AVAudioSession.Mode.spokenAudio,
                                    options: [])
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }
    }
    
    func speak(text: String, interrupt: Bool = true) {
        if (interrupt && self.speechSynth.isSpeaking) {
            self.speechSynth.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        let fixedText = speechUtils.fix(text: text)
        self.speechSynth.speak(AVSpeechUtterance(string: fixedText!))
    }
}
