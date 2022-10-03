//
//  User.swift
//  Bolao
//
//  Created by Vagner Machado on 30/09/22.
//

import Foundation

struct DefaultsKeys {
    static let fullname = "fullname"
    static let username = "username"
}


struct User {
  let fullname: String
  let email: String
  let username: String
  let token: String
  //  let uid: String
  
  init(token: String, dictionary: [String: AnyObject]) {
    self.token = token
    self.fullname = dictionary["fullname"] as? String ?? "Placeholder name"
    self.email = dictionary["email"] as? String ?? ""
    self.username = dictionary["username"] as? String ?? ""
  }
  
  
  //  Firebase
  //  init(uid: String, dictionary: [String: AnyObject]) {
  //    self.uid = uid
  //    self.fullname = dictionary["fullname"] as? String ?? ""
  //    self.email = dictionary["email"] as? String ?? ""
  //    self.username = dictionary["username"] as? String ?? ""
  //  }
}
