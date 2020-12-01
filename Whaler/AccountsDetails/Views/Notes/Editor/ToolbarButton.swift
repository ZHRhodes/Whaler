//
//  ToolbarButton.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/29/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

class ToolbarButton: UIButton {
  let option: EditorToolbarOption
  
  init(option: EditorToolbarOption) {
    self.option = option
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
