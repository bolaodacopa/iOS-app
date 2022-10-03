//
//  FirebaseAuthManager.swift
//  Bolao
//
//  Created by Vagner Machado on 27/09/22.
//

import Foundation
import Firebase
import FirebaseDatabase


struct AuthService {
  static let shared = AuthService()
  
  //MARK: - Backend Bolao

  func logarUsuario(_ username: String, _ password: String, completion: @escaping(ApiResult) -> Void) {

    //Configura parametros
    let parameterDictionary = ["username": username,
                               "password": password
    ]
    
    //Configura requisição
    let path = "signin"
    guard let params = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else { return }
    guard let serviceUrl = URL(string: "\(AUTH_URL)\(path)") else { return }
    print(serviceUrl)
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = params
    
    //Executa requisição
    let session = URLSession.shared
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

  func registrarUsuario(credentials: AuthCredentials, completion: @escaping(ApiResult) -> Void) {

    let email = credentials.email
    let password = credentials.password
    let username = credentials.username
    let fullname = credentials.fullname

    //Configura parametros
    let parameterDictionary = ["username": username,
                               "email": email,
                               "name": fullname,
                               "password": password
    ]
    
    //Configura requisição
    let path = "signup"
    guard let params = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else { return }
    guard let serviceUrl = URL(string: "\(AUTH_URL)\(path)") else { return }
    print(serviceUrl)
    var request = URLRequest(url: serviceUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = params
    
    //Executa requisição
    let session = URLSession.shared
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
  
  
  //MARK: - Firebase
  
  func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void ) {
    Auth.auth().signIn(withEmail: email, password: password, completion: completion)
  }
  
  func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
    let email = credentials.email
    let password = credentials.password
    let username = credentials.username
    let fullname = credentials.fullname
    
    Auth.auth().createUser(withEmail: email, password: password) {(result, error) in
      if error != nil {
        print("DEBUG: deu ruim")
      }
      
      guard let uid = result?.user.uid else { return }
      let values = ["email": email,
                    "username": username,
                    "fullname": fullname]
      
      REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
  }
  
  
  
}
