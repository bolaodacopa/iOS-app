//
//  TokenManager.swift
//  Bolao
//
//  Created by Vagner Machado on 03/10/22.
//

import Foundation


struct TokenManager {
  
  static let shared = TokenManager()

  let APP_KEY = "Bolao2022"

  var accessToken: String {
    get {
      if let data = KeychainHelper.standard.read(service: "accessToken", account: APP_KEY) {
        let token = String(data: data, encoding: .utf8)!
        return token
      } else {
        print("Token: ")
        return ""
      }
    }
    set {
      let data = Data(newValue.utf8)
      KeychainHelper.standard.save(data, service: "accessToken", account: APP_KEY)
    }
  }
  
  func delete() {
    KeychainHelper.standard.delete(service: "accessToken", account: APP_KEY)
  }

}


final class KeychainHelper {
    
    static let standard = KeychainHelper()
    private init() {}
    
  func save(_ data: Data, service: String, account: String) {

    // Create query
    let query = [
      kSecValueData: data,
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: account,
    ] as CFDictionary
      
    // Add data in query to keychain
    let status = SecItemAdd(query, nil)
      
    if status != errSecSuccess {
      // Print out the error
      print("Error: \(status)")
    }
    
    if status == errSecDuplicateItem {
      // Item already exist, thus update it.
      let query = [
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecClass: kSecClassGenericPassword,
      ] as CFDictionary

      let attributesToUpdate = [kSecValueData: data] as CFDictionary
      // Update existing item
      SecItemUpdate(query, attributesToUpdate)
    }
  }
  
  func read(service: String, account: String) -> Data? {
      
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecClass: kSecClassGenericPassword,
      kSecReturnData: true
    ] as CFDictionary
      
    var result: AnyObject?
    SecItemCopyMatching(query, &result)
    
    return (result as? Data)
  }
  
  func delete(service: String, account: String) {
      
    let query = [
      kSecAttrService: service,
      kSecAttrAccount: account,
      kSecClass: kSecClassGenericPassword,
    ] as CFDictionary
      
    // Delete item from keychain
    SecItemDelete(query)
  }
  
}
