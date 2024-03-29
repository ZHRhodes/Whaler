//
//  UIFont+Extensions.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/20/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

let regularFontName = "OpenSans-Regular"
let boldFontName = "OpenSans-Bold"
let semiboldFontName = "OpenSans-SemiBold"

import UIKit

enum FontWeight {
  case regular, bold, semibold
}

extension UIFont {
  static func openSans(weight: FontWeight, size: CGFloat) -> UIFont {
    switch weight {
    case .regular:
      return UIFont(name: regularFontName, size: size)!
    case .bold:
      return UIFont(name: boldFontName, size: size)!
    case .semibold:
      return UIFont(name: semiboldFontName, size: size)!
    }
  }
}
