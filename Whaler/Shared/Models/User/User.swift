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

struct User: Codable {
  let id: String
  let email: String
  let firstName: String
  let lastName: String
  let isAdmin: Bool
  let organizationId: String
//  let workspaces: [WorkspaceRemote]?
  let organization: Organization?
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

extension User: FullNameProviding {}
