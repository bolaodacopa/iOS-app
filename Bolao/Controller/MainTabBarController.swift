//
//  MainTabBarController.swift
//  Bolao
//
//  Created by Vagner Machado on 23/09/22.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
  
  // MARK: - Properties
  var user: User? {
    didSet {
      guard let nav = viewControllers?[0] as? UINavigationController else { return }
      guard let matches = nav.viewControllers.first as? MatchesController else { return }
      matches.user = user
    }
  }
  
  // MARK: - Lifecicle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .grassGreen
    authenticateUserAndConfigureUI()
  }
  
  // MARK: - API
  
  func fetchUser() {
    UserService.shared.fetchUser { user in
    }
  }
  
  func authenticateUserAndConfigureUI() {
    //if Auth.auth().currentUser == nil {
    if TokenManager.shared.accessToken == "" {
      DispatchQueue.main.async {
        let nav = UINavigationController(rootViewController: LoginController())
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
      }
    } else {
      configureUI()
      configureViewControllers()
      fetchUser()
    }
  }
  
  
  // MARK: - Selectors

  func logUserOut() {
    do {
      try Auth.auth().signOut()
    } catch let error {
      print(error.localizedDescription)
    }
  }

  
  // MARK: - Helpers

  func configureUI() {
    let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
    let navAppearance: UINavigationBarAppearance = UINavigationBarAppearance()

    if #available(iOS 15.0, *) {
      UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
      UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    } else if #available(iOS 13.0, *) {
      tabBarAppearance.configureWithDefaultBackground()
      UITabBar.appearance().standardAppearance = tabBarAppearance
      
      navAppearance.configureWithDefaultBackground()
      UINavigationBar.appearance().standardAppearance = navAppearance
    }
  }

  func configureViewControllers() {
    let matches = MatchesController()
    guard let image = UIImage(systemName: "soccerball")  else { return }
    let matchesNav = templateNavigationController(image: image, rootViewController: matches)
    
    let ranking = RankingController()
    guard let image = UIImage(systemName: "trophy")  else { return }
    let rankingNav = templateNavigationController(image: image, rootViewController: ranking)

//    let user = UserController()
//    guard let image = UIImage(systemName: "person")  else { return }
//    let userNav = templateNavigationController(image: image, rootViewController: user)

    let news = NewsController()
    guard let image = UIImage(systemName: "newspaper")  else { return }
    let newsNav = templateNavigationController(image: image, rootViewController: news)

    viewControllers = [matchesNav, rankingNav, newsNav]
  }
  
  func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
    let nav = UINavigationController(rootViewController: rootViewController)
    nav.tabBarItem.image = image
    nav.navigationBar.barTintColor = .white
    return nav
  }
  
}
