//
//  PlayerCell.swift
//  Bolao
//
//  Created by Vagner Machado on 24/10/22.
//

import UIKit

class PlayerCell: UICollectionViewCell {
  
  //MARK : Properties
  
  var user: User?
  var player: Player? {
    didSet {
      configure()
    }
  }
  
  private let myRankingLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .left
    return label
  }()

  private let playerNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .left
    return label
  }()

  private let playerUsernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.italicSystemFont(ofSize: 14)
    label.textColor = .systemGray5
    label.numberOfLines = 1
    label.textAlignment = .left
    return label
  }()

  private let playerScoreLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .white
    label.numberOfLines = 1
    label.textAlignment = .right
    return label
  }()

  private let playerRightScoreLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
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

    addSubview(myRankingLabel)
    myRankingLabel.anchor(top: topAnchor, left: self.leftAnchor, paddingTop: paddingTop, paddingLeft: 20)

    addSubview(playerNameLabel)
    playerNameLabel.anchor(top: topAnchor, left: myRankingLabel.rightAnchor, paddingTop: paddingTop, paddingLeft: 8)

    addSubview(playerUsernameLabel)
    playerUsernameLabel.anchor(top: playerNameLabel.bottomAnchor, left: myRankingLabel.rightAnchor, paddingTop: 0, paddingLeft: 8)
    
    addSubview(playerRightScoreLabel)
    playerRightScoreLabel.anchor(top: topAnchor, right: self.rightAnchor, paddingTop: paddingTop, paddingRight: 20)

    addSubview(playerScoreLabel)
    playerScoreLabel.anchor(top: topAnchor, right: playerRightScoreLabel.leftAnchor, paddingTop: paddingTop, paddingRight: 16)

//    if user != nil {
//      if #available(iOS 15.0, *) {
//        playerNameLabel.textColor = .systemCyan
//      }
//    }

//    let stack = UIStackView(arrangedSubviews: [myRankingLabel, playerNameLabel, playerScoreLabel, playerRightScoreLabel])
//    stack.axis = .horizontal
//    stack.distribution = .fillProportionally
//    stack.spacing = 4
//
//    addSubview(stack)
//    stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
  }
  
  func configure() {
    myRankingLabel.text = "#\(player?.myrank.description ?? "")"
    playerNameLabel.text = player?.name
    playerUsernameLabel.text = player?.username
    playerScoreLabel.text = player?.score.description
    playerRightScoreLabel.text = player?.correctmatches.description
    
//    playerNameLabel.textColor = .red

    configureUI()
  }
  
}
