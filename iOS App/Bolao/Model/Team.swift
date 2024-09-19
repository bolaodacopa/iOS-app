//
//  Teams.swift
//  Bolao
//
//  Created by Vagner Machado on 03/10/22.
//

import Foundation

struct Team {
  let id: Int
  let fifaCode: String
  let name: String
  let flagImageString: String
  
    
  init(dictionary: [String : AnyObject]) {
    self.id = dictionary["id"] as? Int ?? 0
    self.fifaCode = dictionary["fifacode"] as? String ?? ""
    self.name = dictionary["name"] as? String ?? ""
    self.flagImageString = dictionary["flag"] as? String ?? ""
  }
}


