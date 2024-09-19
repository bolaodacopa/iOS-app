//
//  Match.swift
//  Bolao
//
//  Created by Vagner Machado on 10/10/22.
//

import Foundation

struct Match {
  let matchcode: String
  let matchgroup: String
  let formatteddate: String
  let round: Int

  let hometeam: Team
  let awayteam: Team
  let hometeamGoals: Int
  let awayteamGoals: Int
  let finishedmatch: String
  
  var bet: Bet?
  
  
  init?(dictionary: [String : AnyObject], _ bet: Bet?) {
    self.finishedmatch = dictionary["finishedmatch"] as? String ?? "N"
    
    self.matchcode = dictionary["matchcode"] as? String ?? "Z"
    self.matchgroup = dictionary["matchgroup"] as? String ?? "Z"
    self.formatteddate = dictionary["formatteddate"] as? String ?? ""
    self.round = dictionary["round"] as? Int ?? 99

    guard let mandante = dictionary["hometeam"] as? [String:AnyObject] else { return nil }
    self.hometeam = Team(dictionary: mandante)
    self.hometeamGoals = dictionary["hometeamgoals"] as? Int ?? 0

    guard let visitante = dictionary["awayteam"] as? [String:AnyObject] else { return nil }
    self.awayteam = Team(dictionary: visitante)
    self.awayteamGoals = dictionary["awayteamgoals"] as? Int ?? 0
    
    if let bet = bet {
      self.bet = bet
    }
    
  }
  
}
