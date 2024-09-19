//
//  File.swift
//  Bolao
//
//  Created by Vagner Machado on 26/09/22.
//

import UIKit
import SVProgressHUD

class LoginController: UIViewController {
  
  //MARK: - Properties
  
  private let logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.tintColor = .white
    iv.image = UIImage(systemName: "trophy")
    return iv
  }()
  
  private lazy var usernameContainerView: UIView = {
    guard let image = UIImage(systemName: "figure.soccer") else { return UIView() }
    usernameTextField.delegate = self
    let view = Utilities().inputContainerView(withImage: image, textField: usernameTextField)
    return view
  }()
  
  private lazy var passwordContainerView: UIView = {
    guard let image = UIImage(systemName: "lock") else { return UIView() }
    passwordTextField.delegate = self
    let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
    return view
  }()
  
  private let usernameTextField: UITextField = {
    let tf = Utilities().textFiled(withPlaceholder: "Usuário")
    tf.autocapitalizationType = .none
    return tf
  }()
  
  private let passwordTextField: UITextField = {
    let tf = Utilities().textFiled(withPlaceholder: "Senha")
    tf.autocapitalizationType = .none
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private lazy var loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Log In", for: .normal)
    button.setTitleColor(.grassGreen, for: .normal)
    button.backgroundColor = .white
    button.heightAnchor.constraint(equalToConstant : 50).isActive = true
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    return button
  }()
  
  private lazy var createAccountButton: UIButton = {
    let button = Utilities().attributedButton("Não possui uma conta? ", "Registre-se")
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    return button
  }()
  
  //MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleTextFieldInputChange), name: UITextView.textDidBeginEditingNotification, object: nil)
  }
  
  //MARK: - Selectors
  
  @objc func handleTextFieldInputChange() {
    
  }
  
  func handleLogUserIn() {
    
    guard let username = usernameTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    AuthService.shared.logarUsuario(username, password) { result in
      switch result {
      case .success(let returnJson):
        print(returnJson)
        DispatchQueue.main.async {
          if let accessToken = returnJson["accessToken"] as? String {
            var tokenManager = TokenManager.shared
            tokenManager.accessToken = accessToken
          }
          //store user data
          let defaults = UserDefaults.standard
          defaults.set(returnJson, forKey: "userData")
          defaults.synchronize()
          
          //Show Main View
          guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
          guard let tab = window.rootViewController as? MainTabBarController else { return }
          tab.authenticateUserAndConfigureUI()
          self.dismiss(animated: true)
        }
        
      case .failure(let failure):
        switch failure {
        case .connectionError:
          SVProgressHUD.showError(withStatus: "Verifique sua conexão com a internet")
        case .authorizationError(let errorJson):
          SVProgressHUD.showError(withStatus: errorJson.description)
        default:
          SVProgressHUD.showError(withStatus: "Erro Desconhecido")
        }
      case .success_array(_):
        print("")
      }
    }
  }
  
  @objc func handleLogin() {
    
    handleLogUserIn()
    
    
    //Firebase
    //    guard let email = emailTextField.text else { return }
    //    guard let password = passwordTextField.text else { return }
    //    AuthService.shared.logUserIn(withEmail: email, password: password) { result, error in
    //      if let error = error {
    //        print(error.localizedDescription)
    //        return
    //      }
    //
    //      guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
    //      guard let tab = window.rootViewController as? MainTabBarController else { return }
    //      tab.authenticateUserAndConfigureUI()
    //      self.dismiss(animated: true)
    //    }
  }
  
  @objc func handleShowSignUp() {
    let controller = RegistrationController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  //MARK: - Helpers
  func configureUI() {
    view.backgroundColor = .grassGreen
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.isHidden = true
    self.hideKeyboardWhenTappedAround()
    
    view.addSubview(logoImageView)
    logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
    logoImageView.setDimensions(width: 120, height: 120)
    
    let stack = UIStackView(arrangedSubviews: [usernameContainerView, passwordContainerView, loginButton])
    stack.axis = .vertical
    stack.spacing = 20
    stack.distribution = .fillEqually
    
    view.addSubview(stack)
    stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
    
    
    view.addSubview(createAccountButton)
    createAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 40, paddingRight: 40)
  }
}


extension LoginController : UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if usernameTextField.isFirstResponder {
      usernameTextField.placeholder = ""
    } else if passwordTextField.isFirstResponder {
      passwordTextField.placeholder = ""
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.placeholder == "" {
      if usernameTextField == textField {
        usernameTextField.placeholder = "Usuário"
      } else if passwordTextField == textField {
        passwordTextField.placeholder = "Senha"
      }
    }
  }
}
