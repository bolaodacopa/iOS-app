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
  
  var stage: Bool?
  
  var user: User? {
    didSet {
      guard let nav = viewControllers?[1] as? UINavigationController else { return }

      guard let ranking = nav.viewControllers.first as? RankingController else { return }
      ranking.user = user
    }
  }
  
  private lazy var profileButton: UIBarButtonItem = {
    let img = UIImage(systemName: "person")
    let leftBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(profileButtonTapped))
    return leftBarButtonItem
  }()

  private lazy var stageButton: UIBarButtonItem = {
    let img = UIImage(systemName: "slider.horizontal.3")
    let rightBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(stageButtonTapped))
    return rightBarButtonItem
  }()


  // MARK: - Lifecicle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .grassGreen
    stage = false
    authenticateUserAndConfigureUI()
  }
  
  // MARK: - API
  func fetchUser() {
    UserService.shared.fetchUser { user in
      self.user = user
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
  
  
  
  @objc func stageButtonTapped() {
    
    var actions: [(String, UIAlertAction.Style)] = []
    actions.append(("Grupo", UIAlertAction.Style.default))
    actions.append(("Playoffs", UIAlertAction.Style.default))
    actions.append(("Cancelar", UIAlertAction.Style.cancel))

    //self = ViewController
    Alerts.showActionsheet(viewController: self, title: "Fase", message: user?.username ?? "", actions: actions) { [self] (index) in
      if index == 0 {
        stage = true
      } else if index == 1 {
        stage = false
      }
      //Mostra filtro
      DispatchQueue.main.async {
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
        guard let tab = window.rootViewController as? MainTabBarController else { return }
        tab.authenticateUserAndConfigureUI()
      }
      actions.removeAll()
    }
  }

  
  @objc func profileButtonTapped() {
    
    //    let user = UserController()
    //    guard let image = UIImage(systemName: "person")  else { return }
    //    let userNav = templateNavigationController(image: image, rootViewController: user)

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

    let bets = GroupPageViewController()
    bets.navigationItem.leftBarButtonItem = profileButton
    bets.navigationItem.rightBarButtonItem = stageButton
    guard let image = UIImage(systemName: "soccerball")  else { return }
  
    let playoffs = PlayoffsPageViewController()
    playoffs.navigationItem.leftBarButtonItem = profileButton
    playoffs.navigationItem.rightBarButtonItem = stageButton
    guard let image = UIImage(systemName: "soccerball")  else { return }
    let playoffsNav = templateNavigationController(image: image, rootViewController: playoffs)

    let ranking = RankingController(collectionViewLayout: UICollectionViewFlowLayout())
    ranking.navigationItem.leftBarButtonItem = profileButton
    guard let image = UIImage(systemName: "trophy")  else { return }
    let rankingNav = templateNavigationController(image: image, rootViewController: ranking)

    let news = NewsController()
    guard let image = UIImage(systemName: "newspaper")  else { return }
    let newsNav = templateNavigationController(image: image, rootViewController: news)
    newsNav.setNavigationBarHidden(true, animated: false)


//    let matches = MatchesController(collectionViewLayout: UICollectionViewFlowLayout())
//    matches.collectionView.isPagingEnabled = true
//    matches.navigationItem.leftBarButtonItem = profileButton
//    guard let image = UIImage(systemName: "soccerball")  else { return }
//    let matchesNav = templateNavigationController(image: image, rootViewController: matches)

//    let teams = TeamsController(collectionViewLayout: UICollectionViewFlowLayout())
//    teams.navigationItem.leftBarButtonItem = profileButton
//    guard let image = UIImage(systemName: "soccerball")  else { return }
//    let teamsNav = templateNavigationController(image: image, rootViewController: teams)


    viewControllers = [playoffsNav, rankingNav, newsNav]

//    if (stage ?? true) {
//      viewControllers = [playoffsNav, rankingNav, newsNav]
//    } else {
//      viewControllers = [betsNav, rankingNav, newsNav]
//    }
    
  }
  
  func templateNavigationController(image: UIImage, rootViewController: UIViewController) -> UINavigationController {
    let nav = UINavigationController(rootViewController: rootViewController)
    nav.tabBarItem.image = image
    nav.navigationBar.barTintColor = .white
    return nav
  }
  
}
