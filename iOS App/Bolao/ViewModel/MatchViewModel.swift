//
//  MatchViewModel.swift
//  Bolao
//
//  Created by Vagner Machado on 11/10/22.
//

import Foundation


struct MatchViewModel {
  
  let match: Match
  
  init(match: Match) {
    self.match = match
  }
  
  var hometeamFlagUrl: URL? {
    return URL(string: match.hometeam.flagImageString.replacingOccurrences(of: "20px", with: "240px"))
  }

  var awayteamFlagUrl: URL? {
    return URL(string: match.awayteam.flagImageString.replacingOccurrences(of: "20px", with: "240px"))
  }
  
  var hometeam: Team {
    return match.hometeam
  }
  
  var awayteam: Team {
    return match.awayteam
  }
  
  var matchscore: String {
    if (match.finishedmatch.isEqual("N")) {
      return ""
    } else {
      return "\(match.hometeamGoals) x \(match.awayteamGoals)"
    }
  }

  var betscore: String {
    if let bet = match.bet {
      return "\(bet.hometeamGoals) x \(bet.awayteamGoals)"
    } else {
      return "x"
    }
  }


}
