//
//  User.swift
//  Whaler
//
//  Created by Zachary Rhodes on 9/7/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import UIKit

protocol FullNameProviding {
  var firstName: String { get }
  var lastName: String { get }
}

extension FullNameProviding {
  var initials: String {
    let firstInitial = firstName.first.map(String.init) ?? ""
    let lastInitial = lastName.first.map(String.init) ?? ""
    return firstInitial.uppercased() + lastInitial.uppercased()
  }
  
  var fullName: String {
    return "\(firstName) \(lastName)"
  }
}

protocol ColorProviding {
  var color: UIColor { get }
}

typealias NameAndColorProviding = FullNameProviding & ColorProviding

struct User: Codable, FullNameProviding, ColorProviding {
  let id: String
  let email: String
  let firstName: String
  let lastName: String
  let isAdmin: Bool
  let organizationId: String
//  let workspaces: [WorkspaceRemote]?
  let organization: Organization?
  
  var color: UIColor {
    return ColorProvider.default.color(for: id)
  }
}

extension User: SimpleItem {
  var name: String {
    [firstName, lastName].joined(separator: " ")
  }
  
  var icon: UIImage? {
    return nil
  }
}

extension User: Equatable {}

class ColorProvider {
  static let `default` = ColorProvider(colors: UIColor.brandColors)
  private let colors: [UIColor]
  
  init(colors: [UIColor]) {
    self.colors = colors
  }
  
  func color(for id: String) -> UIColor {
    return colors[abs(id.hash) % colors.count]
  }
}
