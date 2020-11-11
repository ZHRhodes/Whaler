//
//  Log.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/10/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

protocol LoggingDestination {
  static func debug(log: Any, context: Any?)
  static func info(log: Any, context: Any?)
  static func warning(log: Any, context: Any?)
  static func error(log: Any, context: Any?)
}

enum LoggingContext: String {
  case networking = "Context: Networking",
       salesforce = "Context: Salesforce",
       cache = "Context: Cache",
       keychain = "Context: Keychain",
       lifecycle = "Context: Lifecycle",
       textEditor = "Context: TextEditor"
}

enum Log {
  static var destinations: [LoggingDestination.Type] = []
  
  static func debug(_ message: String,
                    extraData: [String: Any] = [:],
                    context: LoggingContext? = nil,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
    let formattedLog = format(message, extraData: extraData, file: file, function: function, line: line)
    destinations.forEach { $0.debug(log: formattedLog, context: context) }
  }
  
  static func info(_ message: String,
                   extraData: [String: Any] = [:],
                   context: LoggingContext? = nil,
                   file: String = #file,
                   function: String = #function,
                   line: Int = #line) {
    let formattedLog = format(message, extraData: extraData, file: file, function: function, line: line)
    destinations.forEach { $0.info(log: formattedLog, context: context) }
  }
  
  static func warning(_ message: String,
                      extraData: [String: Any] = [:],
                      context: LoggingContext? = nil,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line) {
    let formattedLog = format(message, extraData: extraData, file: file, function: function, line: line)
    destinations.forEach { $0.warning(log: formattedLog, context: context) }
  }
  
  static func error(_ message: String,
                    extraData: [String: Any] = [:],
                    context: LoggingContext? = nil,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
    let formattedLog = format(message, extraData: extraData, file: file, function: function, line: line)
    destinations.forEach { $0.error(log: formattedLog, context: context) }
  }
  
  // MARK: Private Functions
  
  private static func format(_ message: String,
                             extraData: [String: Any],
                             file: String,
                             function: String,
                             line: Int) -> String {
    let lastFileComponent = file.components(separatedBy: "/").last ?? file
    var logMessage = "\(lastFileComponent).\(function):\(line)\n" + message
    if !extraData.isEmpty {
      logMessage.append(" " + extraData.description)
    }
    return logMessage
  }
}

