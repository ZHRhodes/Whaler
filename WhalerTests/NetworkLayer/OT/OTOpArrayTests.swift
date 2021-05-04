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
  
  func testOpsMerge() throws {
    var ops: [OTOp] = [OTOp(n: 5),
                       OTOp(n: 2),
                       OTOp(),
                       OTOp(s: "lo"),
                       OTOp(s: "rem"),
                       OTOp(),
                       OTOp(n: -3),
                       OTOp(n: -2),
                       OTOp()]
    let mergedOps = ops.opMerge()
    XCTAssertEqual(mergedOps.count, 3)
  }
  
  func testOpsEqual() throws {
    var a = [OTOp]()
    var b = [OTOp]()
    XCTAssertEqual(a, b)
    
    a = [OTOp(n: 7), OTOp(s: "lorem"), OTOp(n: -5)]
    XCTAssertNotEqual(a, b)
    
    b = [OTOp(n: 7), OTOp(s: "lorem"), OTOp(n: -5)]
    XCTAssertEqual(a, b)
  }
  
  func composeTestCases() -> [(a: [OTOp], b: [OTOp], ab: [OTOp])] {
    [
      (
        [OTOp](arrayLiteral: OTOp(n: 3), OTOp(n: -1)),
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tag"), OTOp(n: 2)),
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tag"), OTOp(n: 2), OTOp(n: -1))
      ),
      (
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tag"), OTOp(n: 2)),
        [OTOp](arrayLiteral: OTOp(n: 4), OTOp(n: -2)),
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tag"), OTOp(n: -2))
      ),
      (
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tag")),
        [OTOp](arrayLiteral: OTOp(n: 2), OTOp(n: -1), OTOp(n: 1)),
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tg"))
      )
    ]
  }
  
  func testOpsCompose() throws {
    for testCase in composeTestCases() {
      var testCase = testCase
      let ab = try testCase.a.compose(with: testCase.b)
      XCTAssertEqual(ab, testCase.ab)
    }
  }
}
