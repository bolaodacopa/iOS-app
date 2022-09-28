//
//  MainTabBarController.swift
//  Bolao
//
//  Created by Vagner Machado on 23/09/22.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  // MARK: - Properties
  
  // MARK: - Lifecicle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    configureViewControllers()
  }
  
  // MARK: - Selectors
  
  
  // MARK: - Helpers

  func setupUI() {
    let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
    let navAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
    if #available(iOS 13.0, *) {
      tabBarAppearance.configureWithDefaultBackground()
      UITabBar.appearance().standardAppearance = tabBarAppearance
      
      navAppearance.configureWithDefaultBackground()
      UINavigationBar.appearance().standardAppearance = navAppearance
    }
    if #available(iOS 15.0, *) {
      UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
      UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }
  }

  func configureViewControllers() {
    let matches = MatchesController()
    guard let image = UIImage(systemName: "soccerball")  else { return }
    let matchesNav = templateNavigationController(image: image, rootViewController: matches)
    
    let ranking = RankingController()
    guard let image = UIImage(systemName: "trophy")  else { return }
    let rankingNav = templateNavigationController(image: image, rootViewController: ranking)

    let user = UserController()
    guard let image = UIImage(systemName: "person")  else { return }
    let userNav = templateNavigationController(image: image, rootViewController: user)

    viewControllers = [matchesNav, rankingNav, userNav]
//    viewControllers = [matchesNav, rankingNav]
  }
  
  func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
    let nav = UINavigationController(rootViewController: rootViewController)
    nav.tabBarItem.image = image
    nav.navigationBar.barTintColor = .white
    return nav
  }
  
}
