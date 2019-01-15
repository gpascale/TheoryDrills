//
//  JSUtils.swift
//  TheoryDrills
//
//  Created by Greg Pascale on 1/12/19.
//  Copyright © 2019 Greg Pascale. All rights reserved.
//

import Foundation
import JavaScriptCore

enum JSError : LocalizedError {
    case FileNotFoundError
    case ExecutionError(exception: JSValue, stack: String?, line: Int, column: Int)
    
    public var errorDescription: String? {
        switch self {
            case .ExecutionError(let params):
                let (exception, stack, line, column) = params
                return """
                   \(String(describing: exception))
                    in method \(String(describing: stack!))
                    line: \(String(describing: line)),
                    column: \(String(describing: column))
                """
            default:
                return "File not found"
        }
    }
}

func throwIfException(context: JSContext) throws {
    if (context.exception != nil) {
        let stacktrace = context.exception.objectForKeyedSubscript("stack").toString()
        let lineNumber = Int(context.exception.objectForKeyedSubscript("line").toInt32())
        let column = Int(context.exception.objectForKeyedSubscript("column").toInt32())
        throw JSError.ExecutionError(exception: context.exception, stack: stacktrace, line: lineNumber, column: column)
    }
}

class JSUtils {
    static func runJSFile(filename: String) throws -> JSContext {
        guard let jsSourcePath = try Bundle.main.path(forResource: filename, ofType: "js") else {
            throw JSError.FileNotFoundError
        }
        let jsContext = JSContext()!
        let jsSource = try String(contentsOfFile:jsSourcePath, encoding: String.Encoding.utf8)
        
        jsContext.evaluateScript(jsSource)
        try throwIfException(context: jsContext)
        
        return jsContext
    }
    
    static func runCommand(jsContext: JSContext, code: String) throws {
        jsContext.evaluateScript(code)
        try throwIfException(context: jsContext)
    }
    
    static func getGlobalObjectInfo(jsContext: JSContext) -> [String:Any]? {
        let obj = jsContext.globalObject
        let dict = obj?.toDictionary()
        guard let nsdict = dict as! [String:Any]? else {
            return nil
        }
        return nsdict
    }
}
