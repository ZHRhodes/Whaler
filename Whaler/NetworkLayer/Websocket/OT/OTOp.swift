//
//  OTOp.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

fileprivate let noop = OTOp(n: 0, s: "")

struct OTOp: Codable {
  var n: Int
  var s: String
  
  init(n: Int = 0, s: String = "") {
    self.n = n
    self.s = s
  }
  
  var isNoop: Bool {
    return n == 0 && s.isEmpty
  }
}

extension Array where Element == OTOp {
  typealias OTOpCount = (ret: Int, del: Int, ins: Int)
  func opCount() -> OTOpCount {
    var ret = 0, del = 0, ins = 0
    forEach { (op) in
      if op.n > 0 {
        ret += op.n
      } else if op.n < 0 {
        del += op.n
      } else if op.n == 0 {
        ins += op.s.count
      }
    }
    return (ret, del, ins)
  }
  
  mutating func compose(with b: [OTOp]) throws -> [OTOp] {
    guard count != 0, b.count != 0 else { return [] }
    var ab = [OTOp]()
    
    let (reta, _, ins) = opCount()
    let (retb, del, _) = opCount()
    
    guard reta + ins == retb + del else { throw OTError.composeRequiresTwoConsecutiveOps }
    
    var (ia, oa) = getNextOp(from: 0)
    var (ib, ob) = b.getNextOp(from: 0)
    
    while !oa.isNoop || !ob.isNoop {
      if oa.n < 0 { // delete a
        ab.append(oa)
        (ia, oa) = getNextOp(from: ia)
        continue
      }
      if ob.n == 0 && ob.s != "" { // insert b
        ab.append(ob)
        (ib, ob) = getNextOp(from: ib)
        continue
      }
      if oa.isNoop || ob.isNoop {
        throw OTError.composeEncounteredAShortOpSequence
      }
      
      if oa.n > 0 && ob.n > 0 { // both retain
        let sign = (oa.n - ob.n).signum()
        if sign == 1 {
          oa.n -= ob.n
          ab.append(ob)
          (ib, ob) = getNextOp(from: ib)
        } else if sign == -1 {
          ob.n -= oa.n
          ab.append(oa)
          (ia, oa) = getNextOp(from: ia)
        } else {
          ab.append(oa)
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = getNextOp(from: ib)
        }
      } else if oa.n == 0 && ob.n < 0 { // insert delete
        let sign = (oa.s.count + ob.n)
        if sign == 1 {
          let idx = oa.s.index(oa.s.startIndex, offsetBy: -ob.n)
          oa = OTOp(n: 0, s: String(oa.s[idx...]))
          (ib, ob) = getNextOp(from: ib)
        } else if sign == -1 {
          ob.n += oa.s.count
          (ia, oa) = getNextOp(from: ia)
        } else {
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = getNextOp(from: ib)
        }
      } else if oa.n == 0 && ob.n > 0 { // insert retain
        let sign = (oa.s.count - ob.n).signum()
        if sign == 1 {
          let idx = oa.s.index(oa.s.startIndex, offsetBy: ob.n)
          ab.append(OTOp(n: 0, s: String(oa.s[...idx])))
          oa = OTOp(n: 0, s: String(oa.s[idx...]))
          (ib, ob) = getNextOp(from: ib)
        } else if sign == -1 {
          ob.n -= oa.s.count
          ab.append(oa)
          (ia, oa) = getNextOp(from: ia)
        } else {
          ab.append(oa)
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = getNextOp(from: ib)
        }
      } else if oa.n > 0 && ob.n < 0 { // retain delete
        let sign = (oa.n + ob.n).signum()
        if sign == 1 {
          oa.n += ob.n
          ab.append(ob)
          (ib, ob) = getNextOp(from: ib)
        } else if sign == -1 {
          ob.n += oa.n
          oa.n *= -1
          ab.append(oa)
          (ia, oa) = getNextOp(from: ia)
        } else {
          ab.append(ob)
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = getNextOp(from: ib)
        }
      }
    }
    ab = ab.opMerge()
    return ab
  }
  
  mutating func opMerge() -> [OTOp] {
    var o = -1
    var l = count
    
    for (i, op) in enumerated() {
      if op.isNoop {
        l -= 1
        continue
      }
      var last = OTOp()
      if o > -1 {
        last = self[o]
      }
      if last.n == 0 && last.s != "" && op.n == 0 {
        self[i].s = last.s + op.s
        l -= 1
      } else if (last.n < 0 && op.n < 0) || (last.n > 0 && op.n > 0) {
        self[i].n += last.n
        l -= 1
      } else {
        o += 1
      }
      self[o] = op
    }
    
    return [OTOp](self[...l])
  }
  
  func getNextOp(from index: Int) -> (count: Int, op: OTOp) {
    var index = index
    while index < count {
      let op = self[index]
      if !op.isNoop {
        return (index + 1, op)
      }
      index += 1
    }
    return (index, OTOp(n: 0, s: ""))
  }
}
