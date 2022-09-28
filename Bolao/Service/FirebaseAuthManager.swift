//
//  FirebaseAuthManager.swift
//  Bolao
//
//  Created by Vagner Machado on 27/09/22.
//

import FirebaseAuth
import UIKit

class FirebaseAuthManager {
  func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
      if let user = authResult?.user {
        print(user)
        completionBlock(true)
      } else {
        completionBlock(false)
      }
    }
  }
}
