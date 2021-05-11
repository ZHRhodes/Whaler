//
//  Array+OTExtension.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/28/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation

extension Array where Element == OTOp {
  typealias OTOpCount = (ret: Int, del: Int, ins: Int)
  func opCount() -> OTOpCount {
    var ret = 0, del = 0, ins = 0
    forEach { (op) in
      if op.n > 0 {
        ret += op.n
      } else if op.n < 0 {
        del += -op.n
      } else if op.n == 0 {
        ins += op.s.count
      }
    }
    return (ret, del, ins)
  }
  
  func compose(with b: [OTOp]) throws -> [OTOp] {
    guard !isEmpty, !b.isEmpty else { return [] }
    var ab = [OTOp]()
    
    let (reta, _, ins) = opCount()
    let (retb, del, _) = b.opCount()
    
    guard reta + ins == retb + del else {
      throw OTError.composeRequiresConsecutiveOps
    }
    
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
        (ib, ob) = b.getNextOp(from: ib)
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
          (ib, ob) = b.getNextOp(from: ib)
        } else if sign == -1 {
          ob.n -= oa.n
          ab.append(oa)
          (ia, oa) = getNextOp(from: ia)
        } else {
          ab.append(oa)
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = b.getNextOp(from: ib)
        }
      } else if oa.n == 0 && ob.n < 0 { // insert delete
        let sign = (oa.s.count + ob.n)
        if sign == 1 {
          let idx = oa.s.index(oa.s.startIndex, offsetBy: -ob.n)
          oa = OTOp(n: 0, s: String(oa.s[idx...]))
          (ib, ob) = b.getNextOp(from: ib)
        } else if sign == -1 {
          ob.n += oa.s.count
          (ia, oa) = getNextOp(from: ia)
        } else {
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = b.getNextOp(from: ib)
        }
      } else if oa.n == 0 && ob.n > 0 { // insert retain
        let sign = (oa.s.count - ob.n).signum()
        if sign == 1 {
          let idx = oa.s.index(oa.s.startIndex, offsetBy: ob.n)
          ab.append(OTOp(n: 0, s: String(oa.s[..<idx])))
          oa = OTOp(n: 0, s: String(oa.s[idx...]))
          (ib, ob) = b.getNextOp(from: ib)
        } else if sign == -1 {
          ob.n -= oa.s.count
          ab.append(oa)
          (ia, oa) = getNextOp(from: ia)
        } else {
          ab.append(oa)
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = b.getNextOp(from: ib)
        }
      } else if oa.n > 0 && ob.n < 0 { // retain delete
        let sign = (oa.n + ob.n).signum()
        if sign == 1 {
          oa.n += ob.n
          ab.append(ob)
          (ib, ob) = b.getNextOp(from: ib)
        } else if sign == -1 {
          ob.n += oa.n
          oa.n *= -1
          ab.append(oa)
          (ia, oa) = getNextOp(from: ia)
        } else {
          ab.append(ob)
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = b.getNextOp(from: ib)
        }
      }
    }
    ab = ab.opMerge()
    return ab
  }
  
  mutating func opMerge() -> [OTOp] {
    var o = -1
    var l = count
    
    for (_, op) in enumerated() {
      var op = op
      if op.isNoop {
        l -= 1
        continue
      }
      var last = OTOp()
      if o > -1 {
        last = self[o]
      }
      if last.n == 0 && last.s != "" && op.n == 0 {
        op.s = last.s + op.s
        l -= 1
      } else if (last.n < 0 && op.n < 0) || (last.n > 0 && op.n > 0) {
        op.n += last.n
        l -= 1
      } else {
        o += 1
      }
      self[o] = op
    }
    
    return [OTOp](self[..<l])
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
  
  func transform(with b: [OTOp]) throws -> ([OTOp], [OTOp]) {
    guard !isEmpty, !b.isEmpty else { return ([], []) }
    var a1 = [OTOp](), b1 = [OTOp]()
    
    let (reta, dela, _) = opCount()
    let (retb, delb, _) = b.opCount()
    
    guard reta + dela == retb + delb else {
      throw OTError.transformRequiresConcurrentOps
    }
    
    var (ia, oa) = getNextOp(from: 0)
    var (ib, ob) = b.getNextOp(from: 0)
    
    while !oa.isNoop || !ob.isNoop {
      var om = OTOp() //modified op
      if oa.n == 0 && oa.s != "" { // insert a
        om.n = oa.s.count //set modified retain to op a s.count
        a1.append(oa) //add original op a (oa) to working a
        b1.append(om) //add modified op a (om) to working b
        (ia, oa) = getNextOp(from: ia) //update op a and index -- skipping noops
        continue
      }
      if ob.n == 0 && ob.s != "" { // insert b
        om.n = ob.s.count //now it's a b insert, so set modified op retain to b s.count
        a1.append(om) //add modified b to working a
        b1.append(ob) //add original b to working b
        (ib, ob) = b.getNextOp(from: ib) //skip noops
        continue
      }
      if oa.isNoop || ob.isNoop {
        throw OTError.transformEncounteredAShortOpSequence
      }
      
      if oa.n > 0 && ob.n > 0 { // both retain
        let sign = (oa.n - ob.n).signum()
        if sign == 1 { //a is retaining more
          om.n = ob.n //set modified n to the lesser amount (b)
          oa.n -= ob.n //set a retain to the leftover amount, the extra
          (ib, ob) = b.getNextOp(from: ib) //move b forward
        } else if sign == -1 { //b is retaining more
          om.n = oa.n //set modified amount to the lesser amount (a)
          ob.n -= oa.n //b retain set to leftover
          (ia, oa) = getNextOp(from: ia) //move a forward
        } else { //a and b are retaining the same amount
          om.n = oa.n //set modified n to the amount both are retaining
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = b.getNextOp(from: ib)
        }
        a1.append(om)
        b1.append(om)
      } else if oa.n < 0 && ob.n < 0 { // both delete
        let sign = (-oa.n + ob.n).signum()
        if sign == 1 { //a is deleting more
          oa.n -= ob.n
          (ib, ob) = b.getNextOp(from: ib)
        } else if sign == -1 { //b is deleting more
          ob.n -= oa.n
          (ia, oa) = getNextOp(from: ia)
        } else { //a and b are retaining the same amount
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = b.getNextOp(from: ib)
        }
      } else if oa.n < 0 && ob.n > 0 { // delete, retain
        let sign = (-oa.n - ob.n).signum()
        if sign == 1 { //a is deleting more than b is retaining
          om.n = -ob.n
          oa.n += ob.n
          (ib, ob) = b.getNextOp(from: ib)
        } else if sign == -1 { //a is deleting less than b is retaining
          om.n = oa.n
          ob.n += oa.n
          (ia, oa) = getNextOp(from: ia)
        } else { //a is deleting the same amount that b is retaining
          om.n = oa.n
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = b.getNextOp(from: ib)
        }
        a1.append(om)
      } else if oa.n > 0 && ob.n < 0 { // retain, delete
        let sign = (oa.n + ob.n)
        if sign == 1 { //a is retaining more than b is deleting
          om.n = ob.n
          oa.n += ob.n
          (ib, ob) = b.getNextOp(from: ib)
        } else if sign == -1 { //a is retaining less than b is deleting
          om.n = -oa.n
          ob.n += oa.n
          (ia, oa) = getNextOp(from: ia)
        } else { //a is retaining the same amount that b is deleting
          om.n = -oa.n
          (ia, oa) = getNextOp(from: ia)
          (ib, ob) = b.getNextOp(from: ib)
        }
        b1.append(om)
      }
    }
    a1 = a1.opMerge()
    b1 = b1.opMerge()
    return (a1, b1)
  }
  
  init(currentText: String, changeRange: NSRange, replacementText: String) {
    self.init()
    
    if 0 < changeRange.lowerBound {
      append(OTOp(retain: changeRange.lowerBound))
    }
    
    let isDelete = replacementText.isEmpty
    if isDelete {
      append(OTOp(delete: changeRange.length))
      let newEndIndex = (currentText.count - changeRange.length)
      if changeRange.upperBound < newEndIndex {
        append(OTOp(retain: newEndIndex - changeRange.upperBound))
      }
    } else {
      append(OTOp(insert: replacementText))
      let newEndIndex = (currentText.count + changeRange.length)
      if changeRange.upperBound < newEndIndex {
        append(OTOp(retain: newEndIndex - changeRange.upperBound))
      }
    }
  }
}
