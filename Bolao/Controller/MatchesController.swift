//
//  MatchesController.swift
//  Bolao
//
//  Created by Vagner Machado on 23/09/22.
//

import UIKit
import SDWebImage

class MatchesController: UIViewController {
  
  // MARK: - Properties
  
  var user: User? {
    didSet {
      configureProfileButton()
      getTest()
    }
  }
  
  // MARK: - Lifecicle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - API
  
  func getTest() {
    MatchService.shared.getTest() { result in
      switch result {
      case .success(let returnJson):
        print(returnJson)
        DispatchQueue.main.async {
          print("get test result")
        }
        
      case .failure(let failure):
        switch failure {
        case .connectionError:
          print("Check your Internet connection")
        case .authorizationError(let errorJson):
          print(errorJson.description)
        default:
          print("Unknow Error")
        }
      }
    }
  }
  
  
  // MARK: - Selectors
  
  @objc func profileButtonTapped() {
    var actions: [(String, UIAlertAction.Style)] = []
    actions.append(("Sair", UIAlertAction.Style.default))
    actions.append(("Cancelar", UIAlertAction.Style.cancel))
    
    //self = ViewController
    Alerts.showActionsheet(viewController: self, title: "Logout", message: user?.username ?? "", actions: actions) { (index) in
      if index == 0 {
        //Limpa credenciais
        TokenManager.shared.delete()
        
        //Mostra tela de login
        DispatchQueue.main.async {
          guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
          guard let tab = window.rootViewController as? MainTabBarController else { return }
          tab.authenticateUserAndConfigureUI()
        }
      }
      actions.removeAll()
    }
    
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .white
    navigationItem.title = "Palpites"
  }
  
  func configureProfileButton() {
    
    let img = UIImage(systemName: "person")
    let leftBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(profileButtonTapped))
    navigationItem.leftBarButtonItem = leftBarButtonItem
    
//Imagem
//    guard let user = user else { return }
//    let imageView = UIImageView()
//    guard let profileImageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/en/thumb/f/f3/Flag_of_Russia.svg/900px-Flag_of_Russia.jpg") else { return }
//    imageView.sd_setImage(with: profileImageUrl, completed: nil)
    
  }
  
}
