//
//  NoteEditorInteractor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/8/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Combine
import Starscream

class NoteEditorInteractor {
  weak var viewController: NoteEditorViewController?
  
  let accountId: String
  var socket: WebSocketClient?
  var note: Note?
  
  init(accountId: String, socket: WebSocketClient?) {
    self.accountId = accountId
    self.socket = socket
  }
}
