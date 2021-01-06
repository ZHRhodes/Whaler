//
//  ToolbarDelegate.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/19/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Cocoa
import UIKit

class ToolbarDelegate: NSObject {
  @objc
  func backTapped() {
    NotificationCenter.default.post(name: .back, object: self)
  }
}

#if targetEnvironment(macCatalyst)
extension NSToolbarItem.Identifier {
    static let back = NSToolbarItem.Identifier("com.example.Whaler.back")
}

extension ToolbarDelegate: NSToolbarDelegate {
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        let identifiers: [NSToolbarItem.Identifier] = [
          .toggleSidebar,
          .back
        ]
        return identifiers
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarDefaultItemIdentifiers(toolbar)
    }
    
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem?
        
        switch itemIdentifier {
        case .toggleSidebar:
          toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
          toolbarItem?.action = #selector(backTapped)
          toolbarItem?.target = self
        case .back:
          toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
          toolbarItem?.image = UIImage(named: "backArrow2")?.withTintColor(.lightGray)
          toolbarItem?.action = #selector(backTapped)
          toolbarItem?.target = self
        default:
          toolbarItem = nil
        }
        
        return toolbarItem
    }
}
#endif