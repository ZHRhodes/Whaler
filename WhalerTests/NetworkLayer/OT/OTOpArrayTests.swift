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
      let ab = try testCase.a.compose(with: testCase.b)
      XCTAssertEqual(ab, testCase.ab)
    }
  }
  
  func transformTestCases() -> [(a: [OTOp], b: [OTOp], a1: [OTOp], b2: [OTOp])] {
    [
      (
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tag"), OTOp(n: 2)),
        [OTOp](arrayLiteral: OTOp(n: 2), OTOp(n: -1)),
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tag"), OTOp(n: 1)),
        [OTOp](arrayLiteral: OTOp(n: 5), OTOp(n: -1))
      ),
      (
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tag"), OTOp(n: 2)),
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tag"), OTOp(n: 2)),
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(s: "tag"), OTOp(n: 5)),
        [OTOp](arrayLiteral: OTOp(n: 4), OTOp(s: "tag"), OTOp(n: 2))
      ),
      (
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(n: -2)),
        [OTOp](arrayLiteral: OTOp(n: 2), OTOp(n: -1)),
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(n: -1)),
        [OTOp](arrayLiteral: OTOp(n: 1))
      ),
      (
        [OTOp](arrayLiteral: OTOp(n: 2), OTOp(n: -1)),
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(n: -2)),
        [OTOp](arrayLiteral: OTOp(n: 1)),
        [OTOp](arrayLiteral: OTOp(n: 1), OTOp(n: -1))
      )
    ]
  }
  
  func testOpsTransform() throws {
    for testCase in transformTestCases() {
      let (a1, b1) = try testCase.a.transform(with: testCase.b)
      XCTAssertEqual(a1, testCase.a1)
      XCTAssertEqual(b1, testCase.b2)
    }
  }
  
  func testInitWithInsertFirst() throws {
    let current = "abcd efgh ijkl mnop qrst uvwx yz"
    let ops = [OTOp].init(currentText: current,
                          changeRange: NSRange(location: 0, length: 0),
                          replacementText: "1234")
    XCTAssertEqual(ops.count, 2)
    XCTAssertEqual(ops[0], OTOp(s: "1234"))
    XCTAssertEqual(ops[1], OTOp(n: 32))
  }
  
  func testInitWithInsertMiddle() throws {
    let current = "abcd efgh ijkl mnop qrst uvwx yz"
    let ops = [OTOp].init(currentText: current,
                          changeRange: NSRange(location: 7, length: 0),
                          replacementText: "1234")
    XCTAssertEqual(ops.count, 3)
    XCTAssertEqual(ops[0], OTOp(n: 7))
    XCTAssertEqual(ops[1], OTOp(s: "1234"))
    XCTAssertEqual(ops[2], OTOp(n: 25))
  }
  
  func testInitWithInsertLast() throws {
    let current = "abcd efgh ijkl mnop qrst uvwx yz"
    let ops = [OTOp].init(currentText: current,
                          changeRange: NSRange(location: 32, length: 0),
                          replacementText: "1234")
    XCTAssertEqual(ops.count, 3)
    XCTAssertEqual(ops[0], OTOp(n: 32))
    XCTAssertEqual(ops[1], OTOp(s: "1234"))
    XCTAssertTrue(ops[2].isNoop)
  }
  
  func testInitWithDeleteMiddle() throws {
    let current = "abcd efgh ijkl mnop qrst uvwx yz"
    let ops = [OTOp].init(currentText: current,
                          changeRange: NSRange(location: 7, length: 2),
                          replacementText: "")
    XCTAssertEqual(ops.count, 3)
    XCTAssertEqual(ops[0], OTOp(n: 7))
    XCTAssertEqual(ops[1], OTOp(n: -2))
    XCTAssertEqual(ops[2], OTOp(n: 23))
  }
  
  func testInitWithDeleteLast() throws {
    let current = "abcd efgh ijkl mnop qrst uvwx yz"
    let ops = [OTOp].init(currentText: current,
                          changeRange: NSRange(location: 29, length: 3),
                          replacementText: "")
    XCTAssertEqual(ops.count, 3)
    XCTAssertEqual(ops[0], OTOp(n: 29))
    XCTAssertEqual(ops[1], OTOp(n: -3))
    XCTAssertTrue(ops[2].isNoop)
  }
  
  func testInitiWithDeleteFirst() throws {
    let current = "abcd efgh ijkl mnop qrst uvwx yz"
    let ops = [OTOp].init(currentText: current,
                          changeRange: NSRange(location: 0, length: 5),
                          replacementText: "")
    XCTAssertEqual(ops.count, 2)
    XCTAssertEqual(ops[0], OTOp(n: -5))
    XCTAssertEqual(ops[1], OTOp(n: 27))
  }
  
  func testInitWithReplaceRangeFirst() throws {
    let current = "abcd efgh ijkl mnop qrst uvwx yz"
    let ops = [OTOp].init(currentText: current,
                          changeRange: NSRange(location: 0, length: 3),
                          replacementText: "123")
    XCTAssertEqual(ops.count, 3)
    XCTAssertEqual(ops[0], OTOp(n: -3))
    XCTAssertEqual(ops[1], OTOp(s: "123"))
    XCTAssertEqual(ops[2], OTOp(n: 29))
  }
  
  func testInitWithReplaceRangeMiddle() throws {
    let current = "abcd efgh ijkl mnop qrst uvwx yz"
    let ops = [OTOp].init(currentText: current,
                          changeRange: NSRange(location: 7, length: 4),
                          replacementText: "1234")
    XCTAssertEqual(ops.count, 4)
    XCTAssertEqual(ops[0], OTOp(n: 7))
    XCTAssertEqual(ops[1], OTOp(n: -4))
    XCTAssertEqual(ops[2], OTOp(s: "1234"))
    XCTAssertEqual(ops[3], OTOp(n: 21))
  }
  
  func testInitWithReplaceRangeLast() throws {
    let current = "abcd efgh ijkl mnop qrst uvwx yz"
    let ops = [OTOp].init(currentText: current,
                          changeRange: NSRange(location: 29, length: 3),
                          replacementText: "123")
    XCTAssertEqual(ops.count, 4)
    XCTAssertEqual(ops[0], OTOp(n: 29))
    XCTAssertEqual(ops[1], OTOp(n: -3))
    XCTAssertEqual(ops[2], OTOp(s: "123"))
    XCTAssertTrue(ops[3].isNoop)
  }
}
