//
//  SFSoqlProviding.swift
//  Whaler
//
//  Created by Zachary Rhodes on 11/2/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

protocol SoqlProviding {
  var soql: String { get }
  var soqlProperty: String { get }
}
