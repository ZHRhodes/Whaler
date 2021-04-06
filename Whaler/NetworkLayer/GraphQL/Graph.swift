//
//  Graph.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/10/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Apollo

class Graph {
  static let shared = Graph()
  
  private(set) lazy var apollo: ApolloClient = {
    let client = URLSessionClient()
    let cache = InMemoryNormalizedCache()
    let store = ApolloStore(cache: cache)
    let provider = CustomInterceptorProvider(store: store, client: client)
    let url = Configuration.apiUrl.appendingPathComponent("query")
    let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                 endpointURL: url)
    return ApolloClient(networkTransport: transport, store: store)
  }()
}
