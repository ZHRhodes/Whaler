//
//  Grouper.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/5/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation

struct Grouper<X: Hashable, Y> {
  private(set) var groups: [X]
  private var items: [X: [Y]]
  
  var hasNoValues: Bool {
    items.allSatisfy { $1.isEmpty }
  }
  
  var values: [Y] {
    return items.values.flatMap { $0 }
  }
  
  init(groups: [X]) {
    self.groups = groups
    items = .init(uniqueKeysWithValues: groups.map { ($0, []) })
  }
  
  mutating func resetValues() {
    items = .init(uniqueKeysWithValues: groups.map { ($0, []) })
  }
  
  subscript(_ group: X) -> [Y] {
    return items[group] ?? []
  }
  
  mutating func append(_ item: Y, to group: X) {
    items[group]?.append(item)
  }
  
  @discardableResult
  mutating func remove(from group: X, at index: Int) -> Y? {
    return items[group]?.remove(at: index)
  }
  
  mutating func insert(_ item: Y, to group: X, at index: Int) {
    items[group]?.insert(item, at: index)
  }
}

extension Grouper: CustomStringConvertible {
  var description: String {
    var ret = ""
    for group in groups {
      ret.append("\n\(group):")
      guard let itemsForGroup = items[group] else { continue }
      for (index, item) in itemsForGroup.enumerated() {
        ret.append("\n   \(index): \(item)")
      }
    }
    
    ret.append("\n\nTotal number of items: \(values.count)")
    return ret
  }
}

extension Grouper: Codable where X: Codable, Y: Codable {}
