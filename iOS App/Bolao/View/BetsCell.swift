//
//  Bets.swift
//  Bolao
//
//  Created by Vagner Machado on 06/12/22.
//

import UIKit

class BetsCell: UICollectionViewCell {
  
  //MARK : Properties
  
  var match: Match?
  var bet: Bet? {
    didSet {
      configure()
    }
  }
  
  private let playerUsernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .left
    return label
  }()

  private let scoreLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .right
    return label
  }()

  //MARK : Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .grassGreen
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //MARK : Selectors
  
  
  //MARK : Helpers
  func configureUI() {
    
    let paddingTop = (frame.height - 20) / 2

    addSubview(playerUsernameLabel)
    playerUsernameLabel.anchor(top: topAnchor, left: self.leftAnchor, paddingTop: paddingTop, paddingLeft: 20)

    addSubview(scoreLabel)
    scoreLabel.anchor(top: topAnchor, right: self.rightAnchor, paddingTop: paddingTop, paddingRight: 20)

  }
  
  func configure() {
    playerUsernameLabel.text = bet?.username
    scoreLabel.text = "\(bet?.hometeamGoals ?? 0) : \(bet?.awayteamGoals ?? 0)"
    configureUI()
  }
  
}
