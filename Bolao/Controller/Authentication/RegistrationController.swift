//
//  RegistrationController.swift
//  Bolao
//
//  Created by Vagner Machado on 26/09/22.
//

import UIKit
import Firebase
import SVProgressHUD

class RegistrationController: UIViewController {
  
  //MARK: - Properties
  
  private let logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.tintColor = .white
    iv.image = UIImage(systemName: "trophy")
    return iv
  }()
  
  private lazy var emailContainerView: UIView = {
    guard let image = UIImage(systemName: "envelope") else { return UIView() }
    let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
    return view
  }()
  
  private lazy var passwordContainerView: UIView = {
    guard let image = UIImage(systemName: "lock") else { return UIView() }
    let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
    return view
  }()
  
  private lazy var fullNameContainerView: UIView = {
    guard let image = UIImage(systemName: "envelope") else { return UIView() }
    let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)
    return view
  }()
  
  private lazy var userNameContainerView: UIView = {
    guard let image = UIImage(systemName: "lock") else { return UIView() }
    let view = Utilities().inputContainerView(withImage: image, textField: userNameTextField)
    return view
  }()
  
  private let emailTextField: UITextField = {
    let tf = Utilities().textFiled(withPlaceholder: "Email")
    return tf
  }()
  
  private let passwordTextField: UITextField = {
    let tf = Utilities().textFiled(withPlaceholder: "Senha")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let fullNameTextField: UITextField = {
    let tf = Utilities().textFiled(withPlaceholder: "Nome")
    return tf
  }()
  
  private let userNameTextField: UITextField = {
    let tf = Utilities().textFiled(withPlaceholder: "Usuário")
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private lazy var registrationButton: UIButton =  {
    let button = UIButton(type: .system)
    button.setTitle("Registrar", for: .normal)
    button.setTitleColor(.grassGreen, for: .normal)
    button.backgroundColor = .white
    button.heightAnchor.constraint(equalToConstant : 50).isActive = true
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
    return button
  }()
  
  private lazy var accountCreatedButton: UIButton = {
    let button = Utilities().attributedButton("Já possui uma conta? ", "Logar")
    button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
    return button
  }()
  
  //MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  //MARK: - Selectors
  
  @objc func handleRegistration() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    let signUpManager = FirebaseAuthManager()
    signUpManager.createUser(email: email, password: password) {[weak self] (success) in
      guard self != nil else { return }
      if (success) {
        SVProgressHUD.showSuccess(withStatus:"User was sucessfully created.")
      } else {
        SVProgressHUD.showError(withStatus:"There was an error.")
      }
    }
  }
  
  @objc func handleShowLogin() {
    navigationController?.popViewController(animated: true)
  }
  
  //MARK: - Helpers
  func configureUI() {
    view.backgroundColor = .grassGreen
    
    view.addSubview(logoImageView)
    logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
    logoImageView.setDimensions(width: 120, height: 120)
    
    let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullNameContainerView, userNameContainerView, registrationButton])
    stack.axis = .vertical
    stack.spacing = 20
    stack.distribution = .fillEqually
    
    view.addSubview(stack)
    stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
    
    view.addSubview(accountCreatedButton)
    accountCreatedButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 40, paddingRight: 40)
  }
  
}
