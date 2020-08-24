//
//  String+Extensions.swift
//  Whaler
//
//  Created by Zachary Rhodes on 8/23/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

extension String {
  func fromBase64() -> String? {
    guard let data = Data(base64Encoded: self) else {
      return nil
    }

    return String(data: data, encoding: .utf8)
  }

  func toBase64() -> String {
    return Data(self.utf8).base64EncodedString()
  }
}
