//
//  OTDocTests.swift
//  WhalerTests
//
//  Created by Zachary Rhodes on 4/29/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import XCTest
@testable import Whaler

class OTDocTests: XCTestCase {
  struct OpTest {
    var text: String
    var want: String
    var ops: [OTOp]
  }
  
  func testDocPos() throws {
    let doc = OTDoc(s: "abc")
    let off = doc.pos(index: 3, last: Pos())
    XCTAssertTrue(off.isValid)
  }
  
  func testDocApply() throws {
    let tests = [OpTest]([
      OpTest(text: "abc",
             want: "atag",
             ops: [OTOp(n: 1),
                   OTOp(s: "tag"),
                   OTOp(n: -2)]),
      OpTest(text: "abc\ndef",
             want: "\nabc\ndef",
             ops: [OTOp(s: "\n"),
                   OTOp(n: 7)]),
      OpTest(text: "abc\ndef\nghi",
             want: "abcghi",
             ops: [OTOp(n: 3),
                   OTOp(n: -5),
                   OTOp(n: 3)]),
      OpTest(text: "abc\ndef\nghi",
             want: "ahoi",
             ops: [OTOp(n: 1),
                   OTOp(n: -3),
                   OTOp(s: "h"),
                   OTOp(n: -4),
                   OTOp(s: "o"),
                   OTOp(n: -2),
                   OTOp(n: 1)]),
    ])
    
    for (_, test) in tests.enumerated() {
      let doc = OTDoc(s: test.text)
      try doc.apply(ops: test.ops)
      let got = doc.toString()
      XCTAssertEqual(got, test.want)
    }
  }
  
  func testTransformCursorMovesCursorAfterForward() throws {
    let doc = OTDoc(s: "123456789")
    doc.cursors = [OTCursor(id: "1", position: 3), OTCursor(id: "2", position: 7)]
    let ops = [OTOp(n: 4), OTOp(s: "a"), OTOp(n: 5)]
    try doc.apply(ops: ops)
    
    XCTAssertEqual(doc.cursors.count, 2)
    
    XCTAssertEqual(doc.cursors[0].id, "1")
    XCTAssertEqual(doc.cursors[0].position, 3)
    
    XCTAssertEqual(doc.cursors[1].id, "2")
    XCTAssertEqual(doc.cursors[1].position, 8)
  }
  
  func testTransformCursorMovesCursorBack() throws {
    let doc = OTDoc(s: "123456789")
    doc.cursors = [OTCursor(id: "1", position: 3), OTCursor(id: "2", position: 7)]
    let ops = [OTOp(n: 4), OTOp(n: -1), OTOp(n: 4)]
    try doc.apply(ops: ops)
    
    XCTAssertEqual(doc.cursors.count, 2)
    
    XCTAssertEqual(doc.cursors[0].id, "1")
    XCTAssertEqual(doc.cursors[0].position, 3)
    
    XCTAssertEqual(doc.cursors[1].id, "2")
    XCTAssertEqual(doc.cursors[1].position, 6)
  }
}
