//
//  OTOpArrayTests.swift
//  WhalerTests
//
//  Created by Zachary Rhodes on 5/1/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

import XCTest
@testable import Whaler

class OTOpArrayTests: XCTestCase {
  override func setUpWithError() throws {
    
  }
  
  override func tearDownWithError() throws {
    
  }
  
  func testOpsCount() throws {
    var ops = [OTOp]()
    checkLen(ops: ops, bl: 0, tl: 0)
    ops.append(OTOp(n: 5))
    checkLen(ops: ops, bl: 5, tl: 5)
    ops.append(OTOp(s: "abc"))
    checkLen(ops: ops, bl: 5, tl: 8)
    ops.append(OTOp(n: 2))
    checkLen(ops: ops, bl: 7, tl: 10)
    ops.append(OTOp(n: -2))
    checkLen(ops: ops, bl: 9, tl: 10)
  }
  
  func checkLen(ops: [OTOp], bl: Int, tl: Int) {
    let (ret, del, ins) = ops.opCount()
    var l = ret + del
    if l != bl {
      XCTFail("Base len \(l) != \(bl)")
    }
    l = ret + ins
    if l != tl {
      XCTFail("Target len \(l) != \(tl)")
    }
  }
}
