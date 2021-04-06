//
//  UserManagementInterceptor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Apollo

class UserManagementInterceptor: ApolloInterceptor {
  func interceptAsync<Operation>(chain: RequestChain,
                                 request: HTTPRequest<Operation>,
                                 response: HTTPResponse<Operation>?,
                                 completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) where Operation : GraphQLOperation {
    
  }
}
