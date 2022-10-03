//
//  UserService.swift
//  Bolao
//
//  Created by Vagner Machado on 30/09/22.
//

import Firebase


struct UserService {
  
  static let shared = UserService()

  func fetchUser(completion: @escaping(User) -> Void) {
    let token = TokenManager.shared.accessToken
    
    let defaults = UserDefaults.standard
    if let dictionary = defaults.object(forKey: "userData") as? [String: AnyObject] {
      let user = User(token: token, dictionary: dictionary)
      completion(user)
    } else {
      print("ops")
    }
  }
  

//  Firebase
//  func fetchUser(completion: @escaping(User) -> Void) {
//    guard let uid = Auth.auth().currentUser?.uid else { return }
//    print("user: \(uid)")
//
//    REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
//      guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
//
//      let user = User(uid: uid, dictionary: dictionary)
//      completion(user)
//    }
//  }
  
}
