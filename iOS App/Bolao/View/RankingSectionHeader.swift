//
//  RankingSectionHeader.swift
//  Bolao
//
//  Created by Vagner Machado on 27/10/22.
//

import Foundation
import UIKit

class SectionFooter: UICollectionReusableView {
  var positionLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .grassGreen
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.sizeToFit()
    label.text = "#"
    return label
  }()

  var nameLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .grassGreen
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.sizeToFit()
    label.text = "Nome \t\t\t\t\t\t\t"
    return label
  }()

  var scoreLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .grassGreen
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.sizeToFit()
    label.text = "Pts"
    return label
  }()

  var acertosLabel: UILabel = {
    let label: UILabel = UILabel()
    label.textColor = .grassGreen
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.sizeToFit()
    label.text = "Ac"
    return label
  }()

  
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    let paddingTop = (frame.height - 40) / 2

    addSubview(positionLabel)
    positionLabel.anchor(top: topAnchor, left: self.leftAnchor, paddingTop: paddingTop, paddingLeft: 20)

    addSubview(nameLabel)
    nameLabel.anchor(top: topAnchor, left: positionLabel.rightAnchor, paddingTop: paddingTop, paddingLeft: 8)

    addSubview(acertosLabel)
    acertosLabel.anchor(top: topAnchor, right: self.rightAnchor, paddingTop: paddingTop, paddingRight: 20)

    addSubview(scoreLabel)
    scoreLabel.anchor(top: topAnchor, right: acertosLabel.leftAnchor, paddingTop: paddingTop, paddingRight: 16)

//    let stack = UIStackView(arrangedSubviews: [positionLabel, nameLabel, scoreLabel, acertosLabel])
//    stack.axis = .horizontal
//    stack.distribution = .fillProportionally
//    stack.spacing = 4
//
//    addSubview(stack)
//    stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
