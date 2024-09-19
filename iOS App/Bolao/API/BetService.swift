//
//  BetService.swift
//  Bolao
//
//  Created by Vagner Machado on 12/10/22.
//

import Foundation
import SVProgressHUD

struct BetService {
  
  static let shared = BetService()
  
  
  func fetchBets(completion: @escaping([Bet]) -> Void) {
    var bets = [Bet]()
    
    ApiManager().getBets { result in
      switch result {
      case .success(let returnJson):
          print(returnJson)
        
      case .success_array(let betsArray):
        for obj in betsArray {
          let obj = Bet(dictionary: obj as! [String:AnyObject])
          bets.append(obj!)
        }
        completion(bets)
        
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
    completion(bets)
  }

  
  func doBet(match: Match, completion: @escaping(Bool) -> Void) {
    ApiManager().doBet(match: match) { result in
      completion(result)
    }
  }
  
  
  
  func fetchBets(by matchcode: String, completion: @escaping(Match, [Bet]) -> Void) {

    ApiManager().getBets(by: matchcode) { result in
      var bets = [Bet]()
      var match: Match

      switch result {
      case .success(let returnJson):
        //match
        guard let obj = returnJson["match"] as? [String : AnyObject] else { return }
        match = Match(dictionary: obj, nil)!
        
        //bets
        if let betsArray = returnJson["bets"] as? [[String : AnyObject]] {
          for bet in betsArray {
            bets.append(Bet(dictionary: bet)!)
          }
        }

        completion(match, bets)

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
        
      default:
        break
      }
    }
  }
  
  
  func fetchRanking(completion: @escaping([Player]) -> Void) {
    var players = [Player]()
    
    ApiManager().getRanking { result in
      switch result {
      case .success(let returnJson):
          print(returnJson)
        
      case .success_array(let playersArray):
        for obj in playersArray {
          let obj = Player(dictionary: obj as! [String:AnyObject])
          players.append(obj)
        }
        completion(players)
        
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
    completion(players)
  }
  
  
//  func fetchMatches(completion: @escaping([Match]) -> Void) {
//    var matches = [Match]()
//
//    ApiManager().getMatches { result in
//      switch result {
//      case .success(let returnJson):
//        print(returnJson)
//        SVProgressHUD.showSuccess(withStatus: returnJson.debugDescription)
//
//      case .success_array(let matchesArray):
//        for obj in matchesArray {
//          if let obj = Match(dictionary: obj as! [String:AnyObject]) {
//            matches.append(obj)
//          }
//        }
//        completion(matches)
//
//      case .failure(let failure):
//        switch failure {
//        case .connectionError:
//          SVProgressHUD.showError(withStatus: "Verifique sua conexão com a internet")
//        case .authorizationError(let errorJson):
//          SVProgressHUD.showError(withStatus: errorJson.description)
//        case .parseJsonError(let error):
//          SVProgressHUD.showError(withStatus: error.localizedDescription)
//        default:
//          SVProgressHUD.showError(withStatus: "Erro Desconhecido")
//        }
//
//      }
//    }
//    completion(matches)
//  }
//
//
  

  
}

