//
//  Person.swift
//  Bolao
//
//  Created by Vagner Machado on 24/10/22.
//

import Foundation

struct Player {
  let name: String
  let username: String
  let score: Int
  let correctmatches: Int
  let myrank: Int
  
    
  init(dictionary: [String : AnyObject]) {
    self.name = dictionary["name"] as? String ?? ""
    self.username = dictionary["username"] as? String ?? ""
    self.score = dictionary["total"] as? Int ?? 0
    self.correctmatches = dictionary["correctmatches"] as? Int ?? 0
    self.myrank = dictionary["myrank"] as? Int ?? 0
  }
}
