//
//  UserController.swift
//  Bolao
//
//  Created by Vagner Machado on 23/09/22.
//

import UIKit
import SVProgressHUD

class UserController: UIViewController {
  
  // MARK: - Properties
  
  // MARK: - Lifecicle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SVProgressHUD.dismiss()
  }

  // MARK: - Selectors
  

  // MARK: - Helpers
  func configureUI() {
    view.backgroundColor = .white
    navigationItem.title = "Perfil"
  }

}
