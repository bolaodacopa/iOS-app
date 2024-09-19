//
//  RankingController.swift
//  Bolao
//
//  Created by Vagner Machado on 23/09/22.
//

import UIKit
import SVProgressHUD

private let reuseIdentifier = "PlayerCell"

class RankingController: UICollectionViewController {
  
  // MARK: - Properties
  
  var user: User?
  private let refreshControl = UIRefreshControl()
  
  private lazy var players = [Player]() {
    didSet {
      DispatchQueue.main.async { [self] in
        collectionView.reloadData()
        self.refreshControl.endRefreshing()
      }
    }
  }
  
  // MARK: - Lifecicle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if User.isLogged() {
      fetchRannking()
    }
    configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SVProgressHUD.dismiss()
  }
  
  // MARK: - Selectors
  
  // MARK: - API
  @objc func fetchRannking() {
    BetService.shared.fetchRanking() { players in
      self.players = players
    }
  }
  
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .white
    parent?.parent?.navigationItem.title = "Ranking"
    
    collectionView.register(SectionFooter.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SectionFooter")

    collectionView.register(PlayerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.alwaysBounceVertical = true
    
    refreshControl.addTarget(self, action: #selector(fetchRannking), for: .valueChanged)
    refreshControl.tintColor = .grassGreen
    collectionView.alwaysBounceVertical = true
    collectionView.refreshControl = refreshControl
    
  }
  
}


//MARK: UICollectionViewDelegate/DataSource
extension RankingController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return players.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlayerCell
    
    let player = players[indexPath.row]
    cell.player = player
    
    if (player.username == user?.username) {
      cell.user = user
    }
    
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
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionFooter {
      let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionFooter", for: indexPath) as! SectionFooter
      return sectionFooter
    } else {
      return UICollectionReusableView()
    }
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
extension RankingController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 60 )
  }
}

