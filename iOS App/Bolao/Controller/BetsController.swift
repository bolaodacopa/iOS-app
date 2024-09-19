//
//  BetsController.swift
//  Bolao
//
//  Created by Vagner Machado on 07/12/22.
//

import UIKit
import SVProgressHUD

private let reuseIdentifier = "BetsCell"

class BetsController: UICollectionViewController {
  
  // MARK: - Properties
  
  var user: User?
  var match: Match?
  
  private lazy var bets = [Bet]() {
    didSet {
      DispatchQueue.main.async { [self] in
        collectionView.reloadData()
      }
    }
  }

  // MARK: - Lifecicle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if User.isLogged() {
      fetchBetsForMatch()
    }
    configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SVProgressHUD.dismiss()
  }
  
  // MARK: - Selectors
  
  // MARK: - API
  @objc func fetchBetsForMatch() {
    BetService.shared.fetchBets(by: match!.matchcode) { match, bets in
      self.match = match
      self.bets = bets
    }
  }
  
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .white
    parent?.parent?.navigationItem.title = "Ranking"
    
    collectionView.register(BetsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.alwaysBounceVertical = true
    
  }
  
}


//MARK: UICollectionViewDelegate/DataSource
extension BetsController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return bets.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BetsCell
    
    let bet = bets[indexPath.row]
    cell.bet = bet
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //    DispatchQueue.main.async {
    //      let match = self.matches[indexPath.row]
    //      let betVC = BetController(match: match)
    //      self.present(betVC, animated: true, completion: nil)
    //    }
    
    print("didSelectItemAt")
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 40)
  }

  // Distance Between Item Cells
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 4
  }
  
  // Cell Margin
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
  }
  
  
}


//MARK: UICollectionViewDelegateFlowLayout
extension BetsController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 60 )
  }
}

