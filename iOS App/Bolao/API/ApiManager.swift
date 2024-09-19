//
//  ApiManager.swift
//  Bolao
//
//  Created by Vagner Machado on 08/10/22.
//

import Foundation


class ApiManager {
  
  func doBet(match: Match, completion: @escaping(Bool) -> Void) {
    
    //Configura parametros
    let parameterDictionary = ["matchcode": match.matchcode,
                               "hometeamgoals": String(match.bet!.hometeamGoals),
                               "awayteamgoals": String(match.bet!.awayteamGoals)
    ]
    
    let paramsArray = [parameterDictionary]
    
    
    
    //Configura requisição
    let path = "bets"
    guard let params = try? JSONSerialization.data(withJSONObject: paramsArray, options: []) else { return }
    guard let serviceUrl = URL(string: "\(API_URL)\(path)") else { return }
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(TokenManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    request.httpBody = params
    
    
    //Executa requisição
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print(error)
        completion(false)
      } else if let data = data ,let responseCode = response as? HTTPURLResponse {
        do {
          guard let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<AnyObject> else { return }
          
          switch responseCode.statusCode {
          case 200...299:
            print(responseCode.statusCode)
            completion(true)
          case 400...499:
            let errorObject = responseJson[0]
            print(responseCode.statusCode)
            print(errorObject)
            completion(false)
          case 500...599:
            print(responseCode.statusCode)
            completion(false)

          default:
            print(responseCode.statusCode)
            completion(false)
            break
          }
        }
        catch let parseJSONError {
          print("error on parsing request to JSON : \(parseJSONError)")
          completion(false)
        }
      }
    }.resume()
  }
  
  
  func getBets(completion: @escaping(ApiResult) -> Void) {
    print("DEBUG: getBets")
    
    //Configura requisição
    let path = "bets"
    guard let serviceUrl = URL(string: "\(API_URL)\(path)") else { return }
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(TokenManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    
    
    //Executa requisição
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print(error)
        completion(ApiResult.failure(.connectionError))
      } else if let data = data ,let responseCode = response as? HTTPURLResponse {
        do {
          guard let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<AnyObject> else { return }
          
          switch responseCode.statusCode {
          case 200:
            print(responseCode.statusCode)
            completion(ApiResult.success_array(responseJson))
          case 400...499:
            let errorObject = responseJson[0]
            print(responseCode.statusCode)
            print(errorObject)
            completion(ApiResult.failure(.authorizationError(["error":errorObject])))
          case 500...599:
            print(responseCode.statusCode)
            completion(ApiResult.failure(.serverError))
            
          default:
            print(responseCode.statusCode)
            completion(ApiResult.failure(.unknownError))
            break
          }
        }
        catch let parseJSONError {
          print("error on parsing request to JSON : \(parseJSONError)")
          completion(ApiResult.failure(.parseJsonError(parseJSONError)))
        }
      }
    }.resume()
  }
  
  
  func getBets(by matchcode: String?, completion: @escaping(ApiResult) -> Void) {
    //Configura requisição
    var path = "bets/matches"
    if let matchcode = matchcode {
      path.append("/\(matchcode)")
    }
    
    guard let serviceUrl = URL(string: "\(API_URL)\(path)") else { return }
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(TokenManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    
    
    //Executa requisição
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print(error)
        completion(ApiResult.failure(.connectionError))
      } else if let data = data, let responseCode = response as? HTTPURLResponse {
        do {
          guard let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] else { return }
          
          switch responseCode.statusCode {
          case 200:
            print(responseCode.statusCode)
            completion(ApiResult.success(responseJson))
//          case 400...499:
//            let errorObject = responseJson[0]
//            print(responseCode.statusCode)
//            print(errorObject)
//            completion(ApiResult.failure(.authorizationError(["error":errorObject])))
          case 500...599:
            print(responseCode.statusCode)
            completion(ApiResult.failure(.serverError))
            
          default:
            print(responseCode.statusCode)
            completion(ApiResult.failure(.unknownError))
            break
          }
        }
        catch let parseJSONError {
          print("error on parsing request to JSON : \(parseJSONError)")
          completion(ApiResult.failure(.parseJsonError(parseJSONError)))
        }
      }
    }.resume()
  }
  
  
  func getPlayoffsMatchesAndBets(by stage: String?, completion: @escaping(ApiResult) -> Void) {
    //Configura requisição
    var path = "bets/matches"
    if let stage = stage {
      path.append("?stage=\(stage)")
    }
    
    guard let serviceUrl = URL(string: "\(API_URL)\(path)") else { return }
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(TokenManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    
    
    //Executa requisição
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print(error)
        completion(ApiResult.failure(.connectionError))
      } else if let data = data ,let responseCode = response as? HTTPURLResponse {
        do {
          guard let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<AnyObject> else { return }
          
          switch responseCode.statusCode {
          case 200:
            print(responseCode.statusCode)
            completion(ApiResult.success_array(responseJson))
          case 400...499:
            let errorObject = responseJson[0]
            print(responseCode.statusCode)
            print(errorObject)
            completion(ApiResult.failure(.authorizationError(["error":errorObject])))
          case 500...599:
            print(responseCode.statusCode)
            completion(ApiResult.failure(.serverError))
            
          default:
            print(responseCode.statusCode)
            completion(ApiResult.failure(.unknownError))
            break
          }
        }
        catch let parseJSONError {
          print("error on parsing request to JSON : \(parseJSONError)")
          completion(ApiResult.failure(.parseJsonError(parseJSONError)))
        }
      }
    }.resume()
  }
  
  
  func getMatchesAndBets(by group: String?, completion: @escaping(ApiResult) -> Void) {
    //Configura requisição
    var path = "bets/matches"
    if let group = group {
      path.append("?group=\(group)")
    }
    
    guard let serviceUrl = URL(string: "\(API_URL)\(path)") else { return }
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(TokenManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    
    
    //Executa requisição
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print(error)
        completion(ApiResult.failure(.connectionError))
      } else if let data = data ,let responseCode = response as? HTTPURLResponse {
        do {
          guard let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<AnyObject> else { return }
          
          switch responseCode.statusCode {
          case 200:
            print(responseCode.statusCode)
            completion(ApiResult.success_array(responseJson))
          case 400...499:
            let errorObject = responseJson[0]
            print(responseCode.statusCode)
            print(errorObject)
            completion(ApiResult.failure(.authorizationError(["error":errorObject])))
          case 500...599:
            print(responseCode.statusCode)
            completion(ApiResult.failure(.serverError))
            
          default:
            print(responseCode.statusCode)
            completion(ApiResult.failure(.unknownError))
            break
          }
        }
        catch let parseJSONError {
          print("error on parsing request to JSON : \(parseJSONError)")
          completion(ApiResult.failure(.parseJsonError(parseJSONError)))
        }
      }
    }.resume()
  }
  
  func getMatches(completion: @escaping(ApiResult) -> Void) {
    print("DEBUG: getMatches")
    
    //Configura requisição
    let path = "matches"
    guard let serviceUrl = URL(string: "\(API_URL)\(path)") else { return }
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(TokenManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    
    
    //Executa requisição
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print(error)
        completion(ApiResult.failure(.connectionError))
      } else if let data = data ,let responseCode = response as? HTTPURLResponse {
        do {
          guard let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<AnyObject> else { return }
          
          switch responseCode.statusCode {
          case 200:
            print(responseCode.statusCode)
            completion(ApiResult.success_array(responseJson))
          case 400...499:
            let errorObject = responseJson[0]
            print(responseCode.statusCode)
            print(errorObject)
            completion(ApiResult.failure(.authorizationError(["error":errorObject])))
          case 500...599:
            print(responseCode.statusCode)
            completion(ApiResult.failure(.serverError))
            
          default:
            print(responseCode.statusCode)
            completion(ApiResult.failure(.unknownError))
            break
          }
        }
        catch let parseJSONError {
          print("error on parsing request to JSON : \(parseJSONError)")
          completion(ApiResult.failure(.parseJsonError(parseJSONError)))
        }
      }
    }.resume()
  }
  
  
  func getTeams(completion: @escaping(ApiResult) -> Void) {
    print("DEBUG: getTeams")
    
    //Configura requisição
    let path = "teams"
    guard let serviceUrl = URL(string: "\(API_URL)\(path)") else { return }
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(TokenManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    
    //Executa requisição
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print(error)
        completion(ApiResult.failure(.connectionError))
      } else if let data = data ,let responseCode = response as? HTTPURLResponse {
        do {
          
          guard let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<AnyObject> else { return }
          switch responseCode.statusCode {
          case 200:
            print(responseJson)
            completion(ApiResult.success_array(responseJson))
          case 400...499:
            let errorObject = responseJson[0]
            completion(ApiResult.failure(.authorizationError(["error":errorObject])))
          case 500...599:
            completion(ApiResult.failure(.serverError))
            
          default:
            completion(ApiResult.failure(.unknownError))
            break
          }
        }
        catch let parseJSONError {
          print("error on parsing request to JSON : \(parseJSONError)")
          completion(ApiResult.failure(.parseJsonError(parseJSONError)))
        }
      }
    }.resume()
  }

  
  func getRanking(completion: @escaping(ApiResult) -> Void) {
    print("DEBUG: getRanking")
    
    //Configura requisição
    let path = "ranking"
    guard let serviceUrl = URL(string: "\(API_URL)\(path)") else { return }
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(TokenManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
    
    //Executa requisição
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print(error)
        completion(ApiResult.failure(.connectionError))
      } else if let data = data ,let responseCode = response as? HTTPURLResponse {
        do {
          
          guard let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<AnyObject> else { return }
          switch responseCode.statusCode {
          case 200:
            print(responseJson)
            completion(ApiResult.success_array(responseJson))
          case 400...499:
            let errorObject = responseJson[0]
            completion(ApiResult.failure(.authorizationError(["error":errorObject])))
          case 500...599:
            completion(ApiResult.failure(.serverError))
            
          default:
            completion(ApiResult.failure(.unknownError))
            break
          }
        }
        catch let parseJSONError {
          print("error on parsing request to JSON : \(parseJSONError)")
          completion(ApiResult.failure(.parseJsonError(parseJSONError)))
        }
      }
    }.resume()
  }
  
  
  
  
  
}
