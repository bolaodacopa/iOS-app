//
//  RankingController.swift
//  Bolao
//
//  Created by Vagner Machado on 23/09/22.
//

import UIKit

class RankingController: UIViewController {
  
  // MARK: - Properties
  
  // MARK: - Lifecicle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  // MARK: - Selectors
  
  
  // MARK: - Helpers
  func configureUI() {
    view.backgroundColor = .white
    navigationItem.title = "Ranking"
  }
}
