//
//  MatchCell.swift
//  Bolao
//
//  Created by Vagner Machado on 10/10/22.
//

import UIKit

protocol MatchCellDelegate: AnyObject {
  func handleMatchTapped()
}

class MatchCell: UICollectionViewCell {
  
  //MARK : Properties
  
  var match: Match? {
    didSet {
      configure()
    }
  }

  weak var delegate: MatchCellDelegate?
  
  private let hometeamFlagImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.setDimensions(width: 60, height: 40)
    return iv
  }()
  
  private let awayteamFlagImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.setDimensions(width: 60, height: 40)
    return iv
  }()
  
  private let homefifacodeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .white
    label.numberOfLines = 1
    return label
  }()
  
  private let awayfifacodeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .right
    return label
  }()
  
  private let hometeamNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .white
    label.numberOfLines = 2
    return label
  }()
  
  private let awayteamNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .white
    label.numberOfLines = 2
    label.textAlignment = .right
    return label
  }()
  
  private lazy var betScoreLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 28)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .center
    return label
  }()

  private lazy var matchScoreLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .center
    return label
  }()


  //MARK : Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    betScoreLabel.text = "x"
  }
  
  //MARK : Selectors
  
  @objc func handleCellTapped() {
    delegate?.handleMatchTapped()
  }
  
  
  //MARK : Helpers
  func configureUI() {
    backgroundColor = .grassGreen
    let tap = UITapGestureRecognizer(target:self, action: #selector(handleCellTapped))
    tap.cancelsTouchesInView = false
    self.addGestureRecognizer(tap)
    self.isUserInteractionEnabled = true

    
    addSubview(hometeamFlagImageView)
    let paddingTop = (frame.height - 40) / 2
    hometeamFlagImageView.anchor(top: topAnchor, left: self.leftAnchor, paddingTop: paddingTop, paddingLeft: 8, paddingRight: 8)

    addSubview(awayteamFlagImageView)
    awayteamFlagImageView.anchor(top: topAnchor, right: self.rightAnchor, paddingTop: paddingTop, paddingLeft: 8, paddingRight: 8)


    let homestack = UIStackView(arrangedSubviews: [homefifacodeLabel, hometeamNameLabel])
    homestack.axis = .vertical
    homestack.distribution = .fillProportionally
    homestack.spacing = 4

    let awaystack = UIStackView(arrangedSubviews: [awayfifacodeLabel, awayteamNameLabel])
    awaystack.axis = .vertical
    awaystack.distribution = .fillProportionally
    awaystack.spacing = 4
    
    addSubview(matchScoreLabel)
    matchScoreLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
    
    let stack = UIStackView(arrangedSubviews: [homestack, betScoreLabel, awaystack])
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = 4

    addSubview(stack)
    stack.anchor(top: topAnchor, left: hometeamFlagImageView.rightAnchor, right: awayteamFlagImageView.leftAnchor, paddingTop: paddingTop, paddingLeft: 8, paddingRight: 8)
    
  }
  
  func configure() {
    
    guard let match = match else { return }
    let viewModel = MatchViewModel(match: match)
    
    hometeamNameLabel.text = viewModel.hometeam.name
    homefifacodeLabel.text = viewModel.hometeam.fifaCode
    hometeamFlagImageView.sd_setImage(with: viewModel.hometeamFlagUrl, completed: nil)
    
    awayteamNameLabel.text = viewModel.awayteam.name
    awayfifacodeLabel.text = viewModel.awayteam.fifaCode
    awayteamFlagImageView.sd_setImage(with: viewModel.awayteamFlagUrl, completed: nil)


    betScoreLabel.text = viewModel.betscore
    //matchScoreLabel.text = viewModel.matchscore
    
    if (match.finishedmatch.isEqual("N")) {
      matchScoreLabel.text = ""
    } else {
      matchScoreLabel.text = "\(match.hometeamGoals) x \(match.awayteamGoals)"
    }
  }
  
}
