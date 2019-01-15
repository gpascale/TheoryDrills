//
//  SpeechUtils.swift
//  TheoryDrills
//
//  Created by Greg Pascale on 1/14/19.
//  Copyright © 2019 Greg Pascale. All rights reserved.
//

import JavaScriptCore

class SpeechUtils {

    init?() {
        do {
            self.jsContext = try JSUtils.runJSFile(filename: "speechUtils")
        }
        catch {
            print("Javascript Error:\n", error.localizedDescription)
            fatalError(error.localizedDescription)
        }
    }

    func fix(text: String) -> String! {
        let fixFn = self.jsContext.objectForKeyedSubscript("fix")
        return fixFn?.call(withArguments: [text]).toString()
    }
    
    var jsContext : JSContext!
}
