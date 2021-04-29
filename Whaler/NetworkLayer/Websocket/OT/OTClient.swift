//
//  OTClient.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/26/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

protocol OTClientDelegate: class {
  func send(rev: Int, ops: [OTOp])
}

class OTClient {
  var doc: OTDoc
  var rev: Int
  var buf: [OTOp]
  var wait: [OTOp]
  
  weak var delegate: OTClientDelegate?
  
  init(doc: OTDoc, rev: Int, buf: [OTOp], wait: [OTOp]) {
    self.doc = doc
    self.rev = rev
    self.buf = buf
    self.wait = wait
  }
  
  func send(rev: Int, ops: [OTOp]) {
    delegate?.send(rev: rev, ops: ops)
  }
  
  func apply(ops: [OTOp]) throws {
    try doc.apply(ops: ops)
    if !buf.isEmpty {
      buf = try buf.compose(with: ops)
    } else if !wait.isEmpty {
      buf = ops
    } else {
      wait = ops
      send(rev: rev, ops: ops)
    }
  }
  
  func ack() throws {
    if !buf.isEmpty {
      send(rev: rev+1, ops: buf)
      wait = buf
      buf.removeAll(keepingCapacity: true)
    } else if !wait.isEmpty {
      wait.removeAll(keepingCapacity: true)
    } else {
      throw OTError.noPendingOperations
    }
    rev += 1
  }
  
  func recv(ops: [OTOp]) throws {
    var ops = ops
    if !wait.isEmpty {
      (ops, wait) = try ops.transform(with: wait)
    }
    if !buf.isEmpty {
      (ops, buf) = try ops.transform(with: buf)
    }
    try doc.apply(ops: ops)
    rev += 1
  }
}
