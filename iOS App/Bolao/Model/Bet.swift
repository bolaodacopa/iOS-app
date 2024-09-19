//
//  Bet.swift
//  Bolao
//
//  Created by Vagner Machado on 12/10/22.
//

import Foundation


struct Bet {
  
  var hometeamGoals: Int
  var awayteamGoals: Int
  var username: String

  
  init?(dictionary: [String : AnyObject]) {
    self.username = dictionary["username"] as? String ?? ""
    self.hometeamGoals = dictionary["hometeamgoals"] as? Int ?? 0
    self.awayteamGoals = dictionary["awayteamgoals"] as? Int ?? 0
  }
  
}
