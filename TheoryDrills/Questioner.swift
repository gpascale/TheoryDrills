//
//  Questioner.swift
//  TheoryDrills
//
//  Created by Greg Pascale on 1/14/19.
//  Copyright © 2019 Greg Pascale. All rights reserved.
//

import JavaScriptCore

struct Question {
    var question: String
    var answer: String
}

class Questioner {
    
    init() {
        do {
            self.jsContext = try JSUtils.runJSFile(filename: "MTQ.bundle")
        }
        catch {
            print("Javascript Error:\n", error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }
    
    func askQuestion() -> Question {
        let type = [ "DegreeQuestions", "ChordQuestions", "IntervalQuestions" ].randomElement()
        let MTQ = jsContext.objectForKeyedSubscript("MTQ")
        let questionsModule = MTQ?.objectForKeyedSubscript(type)
        let questionsInstance = questionsModule?.construct(withArguments: nil)
        let question = questionsInstance?.invokeMethod("generate", withArguments: nil)
        let questionObj = question?.toDictionary() as! [String: String]
        return Question(question: questionObj["questionText"]!, answer: questionObj["answer"]!)
    }
    
    var jsContext : JSContext!
}
