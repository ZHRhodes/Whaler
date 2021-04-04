//
//  UIColor+Extensions.swift
//  Whaler
//
//  Created by Zachary Rhodes on 6/28/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import UIKit
import SwiftUI

extension UIColor {
  static let lightText = UIColor(named: "lightText")!
  static let secondaryText = UIColor(named: "secondaryText")!
  static let primaryText = UIColor(named: "primaryText")!
  static let primaryTextInverted = UIColor(named: "primaryTextInverted")!
  static let primaryBackground = UIColor(named: "primaryBackground")!
  static let primaryBackgroundInverted = UIColor(named: "primaryBackgroundInverted")!
  static let darkBackground = UIColor(named: "darkBackground")!
  static let borderLineColor = UIColor(named: "borderLineColor")!
  
  static let brandPurple = UIColor(named: "brandPurple")!
  static let brandPurpleLight = UIColor(named: "brandPurpleLight")!
  static let brandPurpleDark = UIColor(named: "brandPurpleDark")!
  
  static let brandPink = UIColor(named: "brandPink")!
  static let brandPinkLight = UIColor(named: "brandPinkLight")!
  static let brandPinkDark = UIColor(named: "brandPinkDark")!
  
  static let brandGreen = UIColor(named: "brandGreen")!
  static let brandGreenLight = UIColor(named: "brandGreenLight")!
  static let brandGreenDark = UIColor(named: "brandGreenDark")!
  
  static let brandRed = UIColor(named: "brandRed")!
  static let brandRedLight = UIColor(named: "brandRedLight")!
  static let brandRedDark = UIColor(named: "brandRedDark")!
  
  static let brandYellow = UIColor(named: "brandYellow")!
  static let brandYellowLight = UIColor(named: "brandYellowLight")!
  static let brandYellowDark = UIColor(named: "brandYellowDark")!
  
  static let cellBackground = UIColor(named: "cellBackground")!
  static let cellShadow = UIColor(named: "cellShadow")!
}

extension UIColor {
  static let brandColors: [UIColor] = [.brandGreenDark,
                                       .brandPurpleDark,
                                       .brandRedDark,
                                       .brandYellowDark,
                                       .brandPinkDark]
}

extension UIColor {
  public convenience init?(hex: String) {
    let r, g, b, a: CGFloat

    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      let hexColor = String(hex[start...])

      if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
          a = CGFloat(hexNumber & 0x000000ff) / 255

          self.init(red: r, green: g, blue: b, alpha: a)
          return
        }
      }
    }
    
    return nil
  }
}
