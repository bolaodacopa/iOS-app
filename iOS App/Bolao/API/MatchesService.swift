//
//  MatchService.swift
//  Bolao
//
//  Created by Vagner Machado on 02/10/22.
//

import Foundation
import SVProgressHUD

struct MatchesService {
  
  static let shared = MatchesService()
  
  
  func fetchTeams(completion: @escaping([Team]) -> Void) {
    var teams = [Team]()
    
    ApiManager().getTeams { result in
      switch result {
      case .success(let returnJson):
          print(returnJson)
        
      case .success_array(let teamsArray):
        for obj in teamsArray {
          let obj = Team(dictionary: obj as! [String:AnyObject])
          teams.append(obj)
        }
        completion(teams)
        
      case .failure(let failure):
        switch failure {
        case .connectionError:
          SVProgressHUD.showError(withStatus: "Verifique sua conexão com a internet")
        case .authorizationError(let errorJson):
          SVProgressHUD.showError(withStatus: errorJson.description)
        case .parseJsonError(let error):
          SVProgressHUD.showError(withStatus: error.localizedDescription)
        default:
          SVProgressHUD.showError(withStatus: "Erro Desconhecido")
        }
      }
    }
    completion(teams)
  }
  
  
  func fetchPlayoffsMatchesAndBets(by stage: String?, completion: @escaping([Match]) -> Void) {
    var matches = [Match]()

    ApiManager().getPlayoffsMatchesAndBets(by: stage) { result in
      switch result {
      case .success(let returnJson):
        print(returnJson)
        SVProgressHUD.showSuccess(withStatus: returnJson.debugDescription)
        
      case .success_array(let matchesArray):
        for obj in matchesArray {
          guard var match = Match(dictionary: obj["match"] as! [String:AnyObject], nil) else { return }
          if let bet = obj["bet"] as? [String:AnyObject] {
            match.bet = Bet(dictionary: bet)
          }
          matches.append(match)
        }
        completion(matches)
        
      case .failure(let failure):
        switch failure {
        case .connectionError:
          SVProgressHUD.showError(withStatus: "Verifique sua conexão com a internet")
        case .authorizationError(let errorJson):
          SVProgressHUD.showError(withStatus: errorJson.description)
        case .parseJsonError(let error):
          SVProgressHUD.showError(withStatus: error.localizedDescription)
        default:
          SVProgressHUD.showError(withStatus: "Erro Desconhecido")
        }
        
      }
    }
    completion(matches)
  }
  
  func fetchMatchesAndBets(by group: String?, completion: @escaping([Match]) -> Void) {
    var matches = [Match]()

    ApiManager().getMatchesAndBets(by: group) { result in
      switch result {
      case .success(let returnJson):
        print(returnJson)
        SVProgressHUD.showSuccess(withStatus: returnJson.debugDescription)
        
      case .success_array(let matchesArray):
        for obj in matchesArray {
          guard var match = Match(dictionary: obj["match"] as! [String:AnyObject], nil) else { return }
          if let bet = obj["bet"] as? [String:AnyObject] {
            match.bet = Bet(dictionary: bet)
          }
          matches.append(match)
        }
        completion(matches)
        
      case .failure(let failure):
        switch failure {
        case .connectionError:
          SVProgressHUD.showError(withStatus: "Verifique sua conexão com a internet")
        case .authorizationError(let errorJson):
          SVProgressHUD.showError(withStatus: errorJson.description)
        case .parseJsonError(let error):
          SVProgressHUD.showError(withStatus: error.localizedDescription)
        default:
          SVProgressHUD.showError(withStatus: "Erro Desconhecido")
        }
        
      }
    }
    completion(matches)
  }
  
  
  
  func fetchMatches(completion: @escaping([Match]) -> Void) {
    var matches = [Match]()

    ApiManager().getMatches { result in
      switch result {
      case .success(let returnJson):
        print(returnJson)
        SVProgressHUD.showSuccess(withStatus: returnJson.debugDescription)
        
      case .success_array(let matchesArray):
        for obj in matchesArray {
          if let obj = Match(dictionary: obj as! [String:AnyObject], nil) {
            matches.append(obj)
          }
        }
        completion(matches)
        
      case .failure(let failure):
        switch failure {
        case .connectionError:
          SVProgressHUD.showError(withStatus: "Verifique sua conexão com a internet")
        case .authorizationError(let errorJson):
          SVProgressHUD.showError(withStatus: errorJson.description)
        case .parseJsonError(let error):
          SVProgressHUD.showError(withStatus: error.localizedDescription)
        default:
          SVProgressHUD.showError(withStatus: "Erro Desconhecido")
        }
        
      }
    }
    completion(matches)
  }
  
  
  

  
}

