//
//  BetController.swift
//  Bolao
//
//  Created by Vagner Machado on 19/10/22.
//

import UIKit
import SDWebImage
import SVProgressHUD


class BetController: UIViewController {
  
  // MARK: - Properties
  var onDoneBlock : ((Bool) -> Void)?
  
  var match: Match
  
  init(match: Match) {
    self.match = match
    super.init(nibName: nil, bundle: nil)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private let hometeamFlagImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.setDimensions(width: 120, height: 80)
    return iv
  }()
  
  private let awayteamFlagImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.setDimensions(width: 120, height: 80)
    return iv
  }()
  
  private let homefifacodeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .center
    return label
  }()
  
  private let awayfifacodeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .center
    return label
  }()
  
  private let hometeamNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .clear
    label.numberOfLines = 2
    label.textAlignment = .center
    return label
  }()
  
  private let awayteamNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18)
    label.textColor = .clear
    label.numberOfLines = 2
    label.textAlignment = .center
    return label
  }()
  
  private let hometeamTextField: UITextField = {
    let tf = Utilities().scoreTextFiled()
    return tf
  }()
  
  private let awayteamTextField: UITextField = {
    let tf = Utilities().scoreTextFiled()
    return tf
  }()
  
  private lazy var scoreSeparator: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 40)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .center
    label.text = ":"
    return label
  }()
  
  
  private lazy var betButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Palpite", for: .normal)
    button.setTitleColor(.grassGreen, for: .normal)
    button.backgroundColor = .white
    button.heightAnchor.constraint(equalToConstant : 50).isActive = true
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    button.addTarget(self, action: #selector(handleBet), for: .touchUpInside)
    return button
  }()
  
  
  // MARK: - Lifecicle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SVProgressHUD.dismiss()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if isBeingDismissed {
      onDoneBlock!(true)
    }
  }
  
  // MARK: - Selectors
  
  @objc func handleBet() {
    
    if match.bet != nil {
      if let hometeamScore = Int(hometeamTextField.text!) {
        self.match.bet?.hometeamGoals = hometeamScore
      }
      if let awayteamScore = Int(awayteamTextField.text!) {
        self.match.bet?.awayteamGoals = awayteamScore
      }
    } else {
      guard let home = Int(hometeamTextField.text!) as? AnyObject else { return }
      guard let away = Int(awayteamTextField.text!) as? AnyObject else { return }
      let dictionary = ["hometeamgoals": home,
                          "awayteamgoals": away
      ]
      self.match.bet = Bet(dictionary: dictionary)
    }
    
    
    doBet()
  }
  
  // MARK: - API
  
  func doBet() {
    BetService.shared.doBet(match: match) { success in
      if success {
        SVProgressHUD.showSuccess(withStatus: "Boa sorte")
        DispatchQueue.main.async {
          self.dismiss(animated: true)
        }
      } else {
        SVProgressHUD.showError(withStatus: "Tente novamente")
      }
    }
  }
  
  
  // MARK: - Helpers
  func configureUI() {
    view.backgroundColor = .grassGreen
    self.hideKeyboardWhenTappedAround()
    
    let homestack = UIStackView(arrangedSubviews: [hometeamFlagImageView, homefifacodeLabel, hometeamNameLabel])
    homestack.axis = .vertical
    homestack.distribution = .fillProportionally
    homestack.spacing = 4
    
    let awaystack = UIStackView(arrangedSubviews: [awayteamFlagImageView, awayfifacodeLabel, awayteamNameLabel])
    awaystack.axis = .vertical
    awaystack.distribution = .fillProportionally
    awaystack.spacing = 4
    
    let betstack = UIStackView(arrangedSubviews: [hometeamTextField, scoreSeparator, awayteamTextField])
    betstack.axis = .horizontal
    betstack.distribution = .fillProportionally
    betstack.spacing = 4
    
    
    let stack = UIStackView(arrangedSubviews: [homestack, betstack, awaystack])
    stack.axis = .horizontal
    stack.distribution = .fillProportionally
    stack.spacing = 4
    
    
    let fullstack = UIStackView(arrangedSubviews: [stack, betButton])
    fullstack.axis = .vertical
    fullstack.spacing = 20
    fullstack.distribution = .fillProportionally
    view.addSubview(fullstack)
    fullstack.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 48, paddingLeft: 20, paddingBottom: 48, paddingRight: 20)
    
  }
  
  
  func configure() {
    
    let viewModel = MatchViewModel(match: match)
    
    hometeamNameLabel.text = viewModel.hometeam.name
    homefifacodeLabel.text = viewModel.hometeam.fifaCode
    hometeamFlagImageView.sd_setImage(with: viewModel.hometeamFlagUrl, completed: nil)
    
    awayteamNameLabel.text = viewModel.awayteam.name
    awayfifacodeLabel.text = viewModel.awayteam.fifaCode
    awayteamFlagImageView.sd_setImage(with: viewModel.awayteamFlagUrl, completed: nil)
    
    if let homegoals = match.bet?.hometeamGoals {
      hometeamTextField.text = homegoals.description
    }

    if let awaygoals = match.bet?.awayteamGoals {
      awayteamTextField.text = awaygoals.description
    }

    
    if (match.finishedmatch.isEqual("N")) {
      //matchScoreLabel.text = ""
    } else {
      //matchScoreLabel.text = "\(match.hometeamGoals) x \(match.awayteamGoals)"
    }
  }
}
