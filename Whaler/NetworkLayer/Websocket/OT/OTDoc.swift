//
//  OTDoc.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

class OTDoc: Codable {
//  enum CodingKeys: String, CodingKey {
//    case lines, size
//  }
  
  var lines = [[Int32]]()
  var size: Int = 0
  
  init(s: String) {
    lines = s
      .split { (c) -> Bool in c.isNewline }
      .map { substr -> [Int32] in
        substr.compactMap { c -> Int32? in
          //TODO: find a better way to convert Character to Int32
          guard c.lowercased() != "" else { return nil }
          return Int32(c.unicodeScalars.first!.value - Unicode.Scalar("0").value) //Thread 1: Swift runtime failure: arithmetic overflow
        }
      }
    size = s.count
  }
  
//  required init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    lines = try container.decode([[Int32]].self, forKey: .lines)
//    size = try container.decode(Int.self, forKey: .size)
//  }
  
  func toString() -> String {
    let joinedLines: [Int32] = Array(lines.joined(separator: [Int32(10)]))
    let strings: String = joinedLines.map { String(Character(UnicodeScalar($0))) }.joined()
    return strings
//    let data = Data(bytes: joinedLines, count: joinedLines.count * MemoryLayout<UInt32>.stride)
//    return String(data: data, encoding: .utf32) ?? "-1"
  }
  
  func pos(index: Int, last: Pos) -> Pos {
    var n = index - last.index + last.offset
    for (i, l) in lines[last.line...].enumerated() {
      if l.count >= n {
        return Pos(index: index, line: i + last.line, offset: n)
      }
      n -= l.count + 1
    }
    return Pos(index: index, line: -1, offset: -1)
  }
  
  func apply(ops: [OTOp]) throws {
    var d = lines
    var p = Pos()
    var pops = [PosOp]()
    
    for (_, op) in ops.enumerated() {
      if op.n > 0 {
        p = pos(index: p.index + op.n, last: p)
        if !p.isValid {
          throw OTError.invalidDocumentIndex(p.index)
        }
      } else if op.n < 0 {
        pops.append(PosOp(pos: p, op: op))
        p = pos(index: p.index - op.n, last: p)
        if !p.isValid {
          throw OTError.invalidDocumentIndex(p.index)
        }
      } else if !op.s.isEmpty {
        pops.append(PosOp(pos: p, op: op))
      }
    }
    
    guard (p.line == d.count-1) && (p.offset == d[p.line].count) else {
      throw OTError.operationDidntOperateOnWholeDoc
    }
    
    for i in (0..<pops.count).reversed() {
      let pop = pops[i]
      if pop.op.n < 0 {
        size += pop.op.n
        let end = pos(index: pop.pos.index - pop.op.n, last: pop.pos)
        if !end.isValid {
          throw OTError.invalidDocumentIndex(end.index)
        }
        let line = d[pop.pos.line]
        if pop.pos.line == end.line {
          let rest = line[end.offset...]
          d[pop.pos.line] = Array(line[..<pop.pos.offset] + rest)
          break
        }
        let rest = d[end.line][end.offset...]
        d[pop.pos.line] = Array(line[..<pop.pos.offset] + rest)
        d = Array<Array<Int32>>(d[..<(pop.pos.line+1)] + d[(end.line+1)...])
      } else if !pop.op.s.isEmpty {
        let insd = OTDoc(s: pop.op.s)
        size += insd.size
        var insl = insd.lines
        let line = d[pop.pos.line]
        let last = insl.count - 1
        insl[last].append(contentsOf: line[pop.pos.offset...])
        insl[0] = line[..<pop.pos.offset] + insl[0]
        if insl.count == 1 {
          d[pop.pos.line] = insl[0]
          break
        }
        d[(pop.pos.line + insl.count)...] = d[(pop.pos.line + 1)...]
        d[pop.pos.line...] = ArraySlice(insl)
      }
    }
  }
}

fileprivate struct PosOp {
  var pos: Pos
  var op: OTOp
}

struct Pos {
  var index: Int = 0
  var line: Int = 0
  var offset: Int = 0
  
  var isValid: Bool {
    return line >= 0 && offset >= 0
  }
}
