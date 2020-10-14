//
//  LegacyInterceptorProvider.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/11/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Apollo

class NetworkInterceptorProvider: LegacyInterceptorProvider {
  override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
    var interceptors = super.interceptors(for: operation)
    interceptors.insert(TokenAddingInterceptor(), at: 0)
    return interceptors
  }
}
