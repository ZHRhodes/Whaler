//
//  CustomInterceptorProvider.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/11/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Apollo

struct CustomInterceptorProvider: InterceptorProvider {
  private let store: ApolloStore
  private let client: URLSessionClient
  
  init(store: ApolloStore, client: URLSessionClient) {
    self.store = store
    self.client = client
  }
  
  func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation : GraphQLOperation {
    return [
      TokenAddingInterceptor(),
      MaxRetryInterceptor(),
      LegacyCacheReadInterceptor(store: self.store),
      CustomNetworkFetchInterceptor(client: self.client),
      ResponseCodeInterceptor(),
      LegacyParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
      AutomaticPersistedQueryInterceptor(),
      LegacyCacheWriteInterceptor(store: self.store),
    ]
  }
}


