import Foundation
import ApolloCodegenLib

func runApolloCodegen(with accessToken: String, success: () -> Void) {
  let parentFolderOfScriptFile = FileFinder.findParentFolder()
  let sourceRootURL = parentFolderOfScriptFile
    .apollo.parentFolderURL() // Result: Sources folder
    .apollo.parentFolderURL() // Result: Codegen folder
    .apollo.parentFolderURL() // Result: Whaler source root folder

  let cliFolderURL = sourceRootURL
    .apollo.childFolderURL(folderName: "Codegen")
    .apollo.childFolderURL(folderName: "ApolloCLI")

  let endpoint = URL(string: "https://getwhalergo.herokuapp.com/query")!

  let output = sourceRootURL.apollo.childFolderURL(folderName: "Whaler")

  let schemaDownloadOptions = ApolloSchemaOptions(endpointURL: endpoint,
                                                  headers: ["Authorization:\(accessToken)"],
                                                  outputFolderURL: output)
  do {
    try ApolloSchemaDownloader.run(with: cliFolderURL,
                                   options: schemaDownloadOptions)
  } catch {
    exit(1)
  }

  let targetURL = sourceRootURL
    .apollo.childFolderURL(folderName: "Whaler")

  do {
    try FileManager.default.apollo.createFolderIfNeeded(at: targetURL)
  } catch {
    exit(1)
  }


  let codegenOptions = ApolloCodegenOptions(targetRootURL: targetURL)

  do {
    try ApolloCodegen.run(from: targetURL,
                          with: cliFolderURL,
                          options: codegenOptions)
    success()
  } catch {
    exit(1)
  }
}

struct Response: Codable {
  let data: Data
  
  struct Data: Codable {
    let tokens: Tokens
    
    struct Tokens: Codable {
      var accessToken: String
    }
  }
}

//TODO: hardcoding credentials here is temporary
func fetchAccessToken(completion: @escaping (String) -> Void) {
  let parameters = "{\"email\" : \"zack@getwhaler.com\", \"password\" : \"testtest\"}"
  let postData = parameters.data(using: .utf8)

  var request = URLRequest(url: URL(string: "https://getwhalergo.herokuapp.com/api/user/login")!, timeoutInterval: 30.0)
  request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

  request.httpMethod = "POST"
  request.httpBody = postData

  let task = URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data else {
      print(String(describing: error))
      exit(1)
    }
    
    let response: Response
    do {
      response = try JSONDecoder().decode(Response.self, from: data)
    } catch let error {
      print("Failed to decode response from Apollo script. Error: \(error)")
      exit(1)
    }
    completion(response.data.tokens.accessToken)
  }

  task.resume()
}

var semaphore = DispatchSemaphore (value: 0)
fetchAccessToken(completion: { accessToken in
                  runApolloCodegen(with: accessToken) {
                    semaphore.signal()
                  }
})
semaphore.wait()
