//
//  RegistrationController.swift
//  Bolao
//
//  Created by Vagner Machado on 26/09/22.
//

import UIKit
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
    emailTextField.delegate = self
    let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
    return view
  }()
  
  private lazy var passwordContainerView: UIView = {
    guard let image = UIImage(systemName: "lock") else { return UIView() }
    passwordTextField.delegate = self
    let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
    return view
  }()
  
  private lazy var fullNameContainerView: UIView = {
    guard let image = UIImage(systemName: "person") else { return UIView() }
    fullNameTextField.delegate = self
    let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)
    return view
  }()
  
  private lazy var userNameContainerView: UIView = {
    guard let image = UIImage(systemName: "figure.soccer") else { return UIView() }
    userNameTextField.delegate = self
    let view = Utilities().inputContainerView(withImage: image, textField: userNameTextField)
    return view
  }()
  
  private let emailTextField: UITextField = { //email
    let tf = Utilities().textFiled(withPlaceholder: "Email")
    tf.autocapitalizationType = .none
    return tf
  }()
  
  private let passwordTextField: UITextField = { //password
    let tf = Utilities().textFiled(withPlaceholder: "Senha")
    tf.autocapitalizationType = .none
    tf.isSecureTextEntry = true
    return tf
  }()
  
  private let fullNameTextField: UITextField = { //name
    let tf = Utilities().textFiled(withPlaceholder: "Nome")
    tf.autocapitalizationType = .none
    return tf
  }()
  
  private let userNameTextField: UITextField = { //username
    let tf = Utilities().textFiled(withPlaceholder: "Usuário")
    tf.autocapitalizationType = .none
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
    guard let fullname = fullNameTextField.text else { return }
    guard let username = userNameTextField.text else { return }
    
    let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username)
    //    AuthService.shared.registerUser(credentials: credentials) { error, ref in
    //      guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
    //      guard let tab = window.rootViewController as? MainTabBarController else { return }
    //      tab.authenticateUserAndConfigureUI()
    //      self.dismiss(animated: true)
    //    }
    
    AuthService.shared.registrarUsuario(credentials: credentials, completion: { result in
      
      switch result {
      case .success:
        //do login
        self.handleLogin(username, password)
        
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
    })
  }
  
  func handleLogin(_ username: String, _ password: String) {
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
          print("Check your Internet connection")
        case .authorizationError(let errorJson):
          print(errorJson.description)
        default:
          print("Unknow Error")
        }
      case .success_array(_):
        print("")
      }
    }
  }
  
  @objc func handleShowLogin() {
    navigationController?.popViewController(animated: true)
  }
  
  //MARK: - Helpers
  func configureUI() {
    view.backgroundColor = .grassGreen
    self.hideKeyboardWhenTappedAround()
    
    view.addSubview(logoImageView)
    logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
    logoImageView.setDimensions(width: 120, height: 120)
    
    let stack = UIStackView(arrangedSubviews: [fullNameContainerView, emailContainerView, userNameContainerView, passwordContainerView, registrationButton])
    stack.axis = .vertical
    stack.spacing = 20
    stack.distribution = .fillEqually
    
    view.addSubview(stack)
    stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
    
    view.addSubview(accountCreatedButton)
    accountCreatedButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 40, paddingRight: 40)
  }
  
}


extension RegistrationController : UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if fullNameTextField.isFirstResponder {
      fullNameTextField.placeholder = ""
    } else if emailTextField.isFirstResponder {
      emailTextField.placeholder = ""
    } else if userNameTextField.isFirstResponder {
      userNameTextField.placeholder = ""
    } else if passwordTextField.isFirstResponder {
      passwordTextField.placeholder = ""
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.placeholder == "" {
      if fullNameTextField == textField {
        fullNameTextField.placeholder = "Nome"
      } else if emailTextField == textField {
        emailTextField.placeholder = "Email"
      } else if userNameTextField == textField {
        userNameTextField.placeholder = "Usuário"
      } else if passwordTextField == textField {
        passwordTextField.placeholder = "Senha"
      }
    }
  }
}
