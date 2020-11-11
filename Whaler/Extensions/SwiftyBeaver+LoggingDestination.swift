//
//  SwiftyBeaver+LoggingDestination.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/10/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import SwiftyBeaver

extension SwiftyBeaver: LoggingDestination {
  static func debug(log: Any, context: Any?) {
    SwiftyBeaver.debug(log, context: context)
  }
  
  static func info(log: Any, context: Any?) {
    SwiftyBeaver.info(log, context: context)
  }
  
  static func warning(log: Any, context: Any?) {
    SwiftyBeaver.warning(log, context: context)
  }
  
  static func error(log: Any, context: Any?) {
    SwiftyBeaver.error(log, context: context)
  }
}

