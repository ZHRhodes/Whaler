//
//  AddAccountViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/30/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

class FilterTag: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    
  }
}

class AddAccountViewController: UIViewController {
  var accounts = [Account]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureFilterBar()
  }
  
  private func configureFilterBar() {
    
  }
}
