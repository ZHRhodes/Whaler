//
//  CustomNetworkFetchInterceptor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 4/5/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import Apollo
import ApolloCore

/// An interceptor which actually fetches data from the network.
class CustomNetworkFetchInterceptor: ApolloInterceptor, Cancellable {
  let client: URLSessionClient
  private var currentTask: Atomic<URLSessionTask?> = Atomic(nil)
  
  /// Designated initializer.
  ///
  /// - Parameter client: The `URLSessionClient` to use to fetch data
  init(client: URLSessionClient) {
    self.client = client
  }
  
  func interceptAsync<Operation: GraphQLOperation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
    let task = sendRequest(attempt: 0,
                           chain: chain,
                           request: request,
                           response: response,
                           completion: completion)
    
    self.currentTask.mutate { $0 = task }
  }
  
  private func sendRequest<Operation: GraphQLOperation>(
    attempt: Int,
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) -> URLSessionTask? {
    let maxAttempts = 5
    if attempt > maxAttempts {
      let customError = CustomError("Exceeded max attempts to refresh token.")
      Log.error(customError.message)
      chain.handleErrorAsync(customError,
                             request: request,
                             response: response,
                             completion: completion)
    }
    
    let urlRequest: URLRequest
    do {
      urlRequest = try request.toURLRequest()
    } catch {
      chain.handleErrorAsync(error,
                             request: request,
                             response: response,
                             completion: completion)
      return nil
    }
    
    return self.client.sendRequest(urlRequest) { [weak self] result in
      guard let self = self else { return }
      
      defer {
        self.currentTask.mutate { $0 = nil }
      }
      
      guard chain.isNotCancelled else {
        return
      }
      
      switch result {
      case .failure(let error):
        chain.handleErrorAsync(error,
                               request: request,
                               response: response,
                               completion: completion)
      case .success(let (data, httpResponse)):
        if httpResponse.statusCode == 403 {
          Lifecycle.refreshAPITokens { (success) in
            guard success,
                  let token = Lifecycle.accessToken else {
              let customError = CustomError("Refresh token request failed.")
              Log.error(customError.message)
              chain.handleErrorAsync(customError,
                                     request: request,
                                     response: response,
                                     completion: completion)
              return
            }
          
            request.addHeader(name: "Authorization", value: token)
            
            let postRefreshTask = self.sendRequest(attempt: attempt+1,
                                                   chain: chain,
                                                   request: request,
                                                   response: response,
                                                   completion: completion)
            self.currentTask.mutate { $0 = postRefreshTask }
          }
        } else {
          self.handleSuccessfulResponse(chain: chain,
                                        request: request,
                                        httpResponse: httpResponse,
                                        rawData: data,
                                        completion: completion)
        }
      }
    }
  }
  
  private func handleSuccessfulResponse<Operation: GraphQLOperation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    httpResponse: HTTPURLResponse,
    rawData: Data,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
    
    let response = HTTPResponse<Operation>(response: httpResponse,
                                           rawData: rawData,
                                           parsedResponse: nil)
    chain.proceedAsync(request: request,
                       response: response,
                       completion: completion)
  }
  
  func cancel() {
    guard let task = self.currentTask.value else {
      return
    }
    
    task.cancel()
  }
}
