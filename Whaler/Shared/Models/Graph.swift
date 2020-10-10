//
//  Graph.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/10/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Apollo


//
//class Graph {
//  static let shared = Graph()
//
//  // Configure the network transport to use the singleton as the delegate.
//  private lazy var networkTransport: HTTPNetworkTransport = {
//    let transport = HTTPNetworkTransport(url: URL(string: "https://getwhaler.herokuapp.com/v1/graphql")!)
//    transport.delegate = self
//    return transport
//  }()
//
//  // Use the configured network transport in your Apollo client.
//  private(set) lazy var client = ApolloClient(networkTransport: self.networkTransport)
//}
//
//// MARK: - Pre-flight delegate
//
//extension Graph: HTTPNetworkTransportPreflightDelegate {
//  func networkTransport(_ networkTransport: HTTPNetworkTransport,
//                        shouldSend request: URLRequest) -> Bool {
//    return Network.accessToken != nil
//  }
//
//  func networkTransport(_ networkTransport: HTTPNetworkTransport,
//                        willSend request: inout URLRequest) {
//
//    // Get the existing headers, or create new ones if they're nil
//    var headers = request.allHTTPHeaderFields ?? [String: String]()
//
//    // Add any new headers you need
//    headers["Authorization"] = "Bearer " + (Lifecycle.accessToken ?? "")
//
//    // Re-assign the updated headers to the request.
//    request.allHTTPHeaderFields = headers
//  }
//}
//
//extension GraphQLID {
//  var int: Int {
//    return Int(self) ?? -1
//  }
//}
//
