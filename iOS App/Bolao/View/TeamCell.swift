//
//  MatchesCell.swift
//  Bolao
//
//  Created by Vagner Machado on 09/10/22.
//

import UIKit

class TeamCell: UICollectionViewCell {
  
  //MARK : Properties
  
  var team: Team? {
    didSet {
      configure()
    }
  }
  
  private let teamFlagImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    iv.setDimensions(width: 80, height: 40)
    //    iv.layer.cornerRadius = 80/2
    return iv
  }()
  
  private let fifacodeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .white
    label.numberOfLines = 1
    return label
  }()
  
  private let teamNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .white
    label.numberOfLines = 1
    return label
  }()
  
  
  //MARK : Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .grassGreen
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  //MARK : Selectors
  
  
  //MARK : Helpers
  func configureUI() {
    
    addSubview(teamFlagImageView)
    teamFlagImageView.anchor(top: topAnchor, left: self.leftAnchor, paddingTop: 30, paddingLeft: 8)
    
    
    let stack = UIStackView(arrangedSubviews: [fifacodeLabel, teamNameLabel])
    stack.axis = .vertical
    stack.distribution = .fillProportionally
    stack.spacing = 4
    
    addSubview(stack)
    stack.anchor(top: teamFlagImageView.topAnchor, left: teamFlagImageView.rightAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8)
    
  }
  
  func configure() {
    teamNameLabel.text = team?.name
    fifacodeLabel.text = team?.fifaCode
    if let urlString = team?.flagImageString.replacingOccurrences(of: "20px", with: "240px") {
      teamFlagImageView.sd_setImage(with: URL(string: urlString), completed: nil)
    }
  }
  
}
