//
//  OTError.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

enum OTError: Error {
  case failedToApplyOpToDoc
  case composeRequiresTwoConsecutiveOps
  case composeEncounteredAShortOpSequence
  case noPendingOperations
}
