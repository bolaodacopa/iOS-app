//
//  MatchService.swift
//  Bolao
//
//  Created by Vagner Machado on 02/10/22.
//

import Foundation

struct MatchService {
  
  static let shared = MatchService()
  
  
  func getTest(completion: @escaping(ApiResult) -> Void) {

    //Configura parametros
//    let parameterDictionary = ["username": username,
//                               "password": password
//    ]
    
    //Configura requisição
    let path = "signin"
    //guard let params = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else { return }
    //guard let serviceUrl = URL(string: "\(AUTH_URL)\(path)") else { return }
    guard let serviceUrl = URL(string: "https://bolaodacopa.tk/api/teste/teste.txt") else { return }
    print(serviceUrl)
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(TokenManager.shared.accessToken)", forHTTPHeaderField: "Authentication")
    //request.httpBody = params
    
    //Configura Sessao
    var sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.httpAdditionalHeaders = [
      "Authorization": "Bearer \(TokenManager.shared.accessToken)"
    ]
    let session = URLSession(configuration: sessionConfiguration)

    //Executa requisição
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
          print(error)
        completion(ApiResult.failure(.connectionError))
      } else if let data = data ,let responseCode = response as? HTTPURLResponse {
          do {
            guard let responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }

            switch responseCode.statusCode {
            case 200:
              completion(ApiResult.success(responseJson))
            case 400...499:
              completion(ApiResult.failure(.authorizationError(responseJson)))
            case 500...599:
              completion(ApiResult.failure(.serverError))

            default:
              completion(ApiResult.failure(.unknownError))
              break
            }
          }
          catch let parseJSONError {
            print("error on parsing request to JSON : \(parseJSONError)")
            completion(ApiResult.failure(.unknownError))
          }
      }
    }.resume()
  }
  
}
