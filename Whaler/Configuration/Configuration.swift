//
//  Configuration.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/31/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

enum Configuration {
  static var apiUrl: URL = {
    return URL(string: Bundle.main.object(forInfoDictionaryKey: "API_URL") as! String)!
  }()
}
