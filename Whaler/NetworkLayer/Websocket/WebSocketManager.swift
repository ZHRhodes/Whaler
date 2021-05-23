//
//  WebSocketManager.swift
//  Whaler
//
//  Created by Zachary Rhodes on 12/13/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Starscream
import Just

class WebSocketManager {
  static var shared: WebSocketManager!
  
  var sockets: [WebSocket: WebSocketInfo] = [:]
  private var otClients: [String: (OTClient, WebSocketClient)] = [:]
  private var inFlightMessageIds = Set<String>()

  func registerConnection(id: String, delegate: LiteWebSocketDelegate) -> WebSocketClient? {
    guard let token = Lifecycle.accessToken else { return nil }
    let request = makeRequest(url: Configuration.apiUrl.appendingPathComponent("socket"),
                              id: id,
                              accessToken: token)
    let socket = makeSocket(with: request)
    socket.connect()
    sockets[socket] = WebSocketInfo(id: id, delegate: delegate)
    return socket
  }
  
  func makeOTClient(resourceId: String, docString: String, revision: Int, over socket: WebSocketClient) -> OTClient {
    let newClient = OTClient(doc: OTDoc(s: docString),
                             rev: revision,
                             buf: [],
                             wait: [],
                             resourceId: resourceId)
    newClient.delegate = self
    otClients[resourceId] = (newClient, socket)
    return newClient
  }
  
  func otClient(_ resourceId: String) -> OTClient? {
    return otClients[resourceId]?.0
  }
  
  func disconnectClient(with resourceId: String) {
    guard let (_, socket) = otClients[resourceId] else { return }
    socket.disconnect()
  }
  
  private func makeRequest(url: URL, id: String, accessToken: String) -> URLRequest {
    var request = URLRequest(url: url)
    request.timeoutInterval = 5
    request.setValue(id, forHTTPHeaderField: "ObjectId")
    request.setValue(accessToken, forHTTPHeaderField: "Authorization")
    return request
  }
  
  private func makeSocket(with request: URLRequest) -> WebSocket {
    let socket = WebSocket(request: request)
    socket.delegate = self
    socket.enableCompression = false
    return socket
  }
  
  func send<T: Codable>(message: SocketMessage<T>, over socket: WebSocketClient) {
    let messageId = UUID().uuidString
    var message = message
    message.messageId = messageId
    inFlightMessageIds.insert(messageId)
    socket.send(message: message)
  }
}

extension WebSocketManager: OTClientDelegate {
  func send(rev: Int, ops: [OTOp], sender: OTClient) {
    DispatchQueue.global(qos: .utility).async {
      let resourceId = sender.resourceId
      let docChange = DocumentChange(resourceId: resourceId,
                                     rev: rev,
                                     ops: ops)
      guard let (_, socket) = self.otClients[resourceId] else { return }
      let messageId = UUID().uuidString
      self.inFlightMessageIds.insert(messageId)
      let message = SocketMessage(type: .docChange,
                                  data: docChange)
      WebSocketManager.shared.send(message: message, over: socket)
      let data = try! JSONEncoder().encode(message)
      Just.post(URL(string: "https://getwhaler.herokuapp.com")!, params: [:], data: [:], json: nil, headers: [:], files: [:], auth: nil, cookies: [:], allowRedirects: true, timeout: nil, urlQuery: nil, requestBody: data, asyncProgressHandler: nil, asyncCompletionHandler: nil)

    }
  }
}

extension WebSocketManager: WebSocketDelegate {
  func websocketDidConnect(socket: WebSocketClient) {
    Log.debug("WebSocket did connect.")
    guard let webSocket = socket as? WebSocket,
          let delegate = sockets[webSocket]?.delegate else { return }
    delegate.connectionEstablished(socket: socket)
  }
  
  func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
    if let error = error {
//      socket.connect()
      Log.debug("WebSocket did disconnect with error: \(error)")
    }
    Log.debug("WebSocket did disconnect.")
  }
  
  func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
    Log.debug("WebSocket did receive message:\n\(text)")
    guard let webSocket = socket as? WebSocket,
          let delegate = sockets[webSocket]?.delegate,
          let data = text.data(using: .utf8) else {
      Log.warning("Failed preconditions for receiving WebSocket message")
      return
    }
    
    do {
      let untypedMessage = try JSONDecoder().decode(SocketMessage<AnyCodable>.self,
                                                    from: data)
      let wasSender = inFlightMessageIds.contains(untypedMessage.messageId)
      inFlightMessageIds.remove(untypedMessage.messageId)
      switch untypedMessage.type {
      case .docChange:
        let typedMessage = try JSONDecoder().decode(SocketMessage<DocumentChange>.self,
                                                    from: data)
        delegate.didReceiveMessage(.docChange(typedMessage.data), socket: socket)
      case .resourceConnection:
        let typedMessage = try JSONDecoder().decode(SocketMessage<ResourceConnection>.self,
                                                    from: data)
        delegate.didReceiveMessage(.resourceConnection(typedMessage.data),
                                   socket: socket)
      case .resourceConnectionConf:
        let typedMessage = try JSONDecoder().decode(SocketMessage<ResourceConnectionConf>.self,
                             from: data)
        delegate.didReceiveMessage(.resourceConnectionConf(typedMessage.data),
                                   socket: socket)
      case .docChangeReturn:
        let typedMessage = try JSONDecoder().decode(SocketMessage<DocumentChangeReturn>.self, from: data)
        delegate.didReceiveMessage(.docChangeReturn(typedMessage.data, wasSender: wasSender), socket: socket)
      }
    } catch {
      Log.error("Failed to decode socket message. \(error.localizedDescription)")
    }
  }
  
  func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    Log.debug("WebSocket did receive data.")
  }
}

fileprivate extension WebSocketClient {
  func send<T: Codable>(message: SocketMessage<T>) {
    do {
      let data = try JSONEncoder().encode(message)
      write(data: data)
    } catch {
      Log.warning("Failed to send message:\n\(message)")
    }
  }
}
