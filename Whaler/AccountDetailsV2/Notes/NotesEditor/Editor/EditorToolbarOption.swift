//
//  EditorToolbarOption.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/29/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

enum EditorToolbarOption: CaseIterable {
  case header1, header2, bold, italic, underline, bulletList, numberList, table, link, image
  
  var icon: UIImage {
    switch self {
    case .header1:
      return UIImage(named: "h1")!
    case .header2:
      return UIImage(named: "h2")!
    case .bold:
      return UIImage(named: "bold")!
    case .italic:
      return UIImage(named: "italic")!
    case .underline:
      return UIImage(named: "underline")!
    case .bulletList:
      return UIImage(named: "bulletList")!
    case .numberList:
      return UIImage(named: "numList")!
    case .table:
      return UIImage(named: "table")!
    case .link:
      return UIImage(named: "link")!
    case .image:
      return UIImage(named: "insertImage")!
    }
  }
}
