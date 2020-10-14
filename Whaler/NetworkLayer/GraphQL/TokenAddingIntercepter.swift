//
//  TokenAddingIntercepter.swift
//  Whaler
//
//  Created by Zachary Rhodes on 10/11/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import Apollo

class TokenAddingInterceptor: ApolloInterceptor {
  func interceptAsync<Operation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : GraphQLOperation {
    guard let token = Lifecycle.accessToken else { return }
    request.addHeader(name: "Authorization", value: token)
    chain.proceedAsync(request: request,
                       response: response,
                       completion: completion)
  }
}
