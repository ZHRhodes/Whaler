//
//  TrackingChange.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/22/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

enum TrackingState: String {
  case tracked, untracked
}

struct TrackingChange<T> {
  let value: T
  let newTrackingState: TrackingState
}
