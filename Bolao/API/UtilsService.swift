//
//  UtilsService.swift
//  Bolao
//
//  Created by Vagner Machado on 02/10/22.
//


struct AuthCredentials {
  let email: String
  let password: String
  let fullname: String
  let username: String
}

enum ApiResult {
  case success([String: AnyObject])
  case failure(RequestError)
}

enum RequestError: Error {
  case unknownError
  case connectionError
  case authorizationError([String: AnyObject])
  case invalidRequest
  case notFound
  case invalidResponse
  case serverError
  case serverUnavailable
}
