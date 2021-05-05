//
//  OTClientTests.swift
//  WhalerTests
//
//  Created by Zachary Rhodes on 5/3/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import XCTest
@testable import Whaler

class OTClientTests: XCTestCase {
  let delegate = ClientDelegate()
  
  var doc: OTDoc!
  var client: OTClient!
  
  override func setUp() {
    super.setUp()
    doc = OTDoc(s: "old!")
    client = OTClient(doc: doc, rev: 0, buf: [], wait: [], resourceId: "")
    client.delegate = delegate
  }
  
  override func tearDown() {
    doc = nil
    client = nil
    super.tearDown()
  }
  
  @discardableResult
  func applyA() throws -> [OTOp] {
    let a: [OTOp] = [OTOp(s: "g"), OTOp(n: 4)]
    try client.apply(ops: a)
    return a
  }
  
  @discardableResult
  func applyB() throws -> [OTOp] {
    let b: [OTOp] = [OTOp(n: 2), OTOp(n: -2), OTOp(n: 1)]
    try client.apply(ops: b)
    return b
  }
  
  @discardableResult
  func applyC() throws -> [OTOp] {
    let c = [OTOp(n: 2), OTOp(s: " cool"), OTOp(n: 1)]
    try client.apply(ops: c)
    return c
  }
  
  @discardableResult
  func recvD() throws -> [OTOp] {
    let recvOps = [OTOp(n: 1), OTOp(s: " is"), OTOp(n: 3)]
    try client.recv(ops: recvOps)
    return recvOps
  }
  
  func testApplyAString() throws {
    try applyA()
    let s = doc.toString()
    XCTAssertEqual(s, "gold!")
  }
  
  func testApplyAWaitingForAck() throws {
    let a = try applyA()
    XCTAssertEqual(a, client.wait, "Expected waiting for ack")
    XCTAssertEqual(a, delegate.sent[0], "Expected waiting for ack")
  }
  
  func testApplyABString() throws {
    try applyA()
    try applyB()
    let s = doc.toString()
    XCTAssertEqual(s, "go!")
  }
  
  func testApplyABBuffering() throws {
    try applyA()
    let b = try applyB()
    XCTAssertEqual(b, client.buf, "Expected buffering")
    XCTAssertEqual(delegate.sent.count, 1, "Expected buffering")
  }
  
  func testApplyABCString() throws {
    try applyA()
    try applyB()
    try applyC()
    
    let s = doc.toString()
    XCTAssertEqual(s, "go cool!")
  }
  
  func testApplyABCChangeBuffer() throws {
    try applyA()
    try applyB()
    try applyC()
    
    let cb = [OTOp(n: 2), OTOp(n: -2), OTOp(s: " cool"), OTOp(n: 1)]
    XCTAssertEqual(cb, client.buf, "Expected combining buffer")
    XCTAssertEqual(delegate.sent.count, 1, "Expected combining buffer")
  }
  
  func testApplyABCRecvString() throws {
    try applyA()
    try applyB()
    try applyC()
    try recvD()

    let s = doc.toString()
    XCTAssertEqual(s, "go is cool!")
  }
  
  func testApplyABCRecvTransformWait() throws {
    try applyA()
    try applyB()
    try applyC()
    try recvD()
    
    XCTAssertEqual([OTOp(s: "g"), OTOp(n: 7)],
                   client.wait,
                   "Expected transform wait")
  }
  
  func testApplyABCRecvTransformBuf() throws {
    try applyA()
    try applyB()
    try applyC()
    try recvD()
    
    let cb = [OTOp(n: 5), OTOp(n: -2), OTOp(s: " cool"), OTOp(n: 1)]
    XCTAssertEqual(cb,
                   client.buf,
                   "Expected tranform buf")
  }
  
  func testApplyABCRecvAckFlushesBuffer() throws {
    try applyA()
    try applyB()
    try applyC()
    try recvD()
    try client.ack()
    
    let cb = [OTOp(n: 5), OTOp(n: -2), OTOp(s: " cool"), OTOp(n: 1)]
    XCTAssertEqual(client.buf.count, 0, "Expected flushed")
    XCTAssertEqual(client.wait, cb, "Expected flushed")
    XCTAssertEqual(delegate.sent.count, 2, "Expected flushed")
    XCTAssertEqual(delegate.sent[1], cb, "Expected flushed")
  }
  
  func testApplyABCRecvAckAckFlushesAll() throws {
    try applyA()
    try applyB()
    try applyC()
    try recvD()
    try client.ack()
    try client.ack()
    XCTAssertEqual(client.buf.count, 0, "Expected flushed")
    XCTAssertEqual(client.wait.count, 0, "Expected flushed")
    XCTAssertEqual(delegate.sent.count, 2, "Expected flushed")
  }
}

class ClientDelegate: OTClientDelegate {
  var sent = [[OTOp]]()
  
  func send(rev: Int, ops: [OTOp], sender: OTClient) {
    sent.append(ops)
  }
}
