//
//  BetController.swift
//  Bolao
//
//  Created by Vagner Machado on 17/10/22.
//

import UIKit
import SDWebImage
import SVProgressHUD

private let reuseIdentifier = "MatchCell"

class BetsCollectionController: UICollectionViewController {
  
  
  // MARK: - Properties
  var group: Group?
  var playoff: Playoffs?
  private let refreshControl = UIRefreshControl()
  
  private lazy var matches = [Match]() {
    didSet {
      DispatchQueue.main.async { [self] in
        configureUI()
        collectionView.reloadData()
      }
    }
  }
  
  // MARK: - Lifecycle
  
  init(with group: Group) {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
    self.group = group
  }
  
  init(with playoff: Playoffs) {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
    self.playoff = playoff
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    if User.isLogged() {
//      fetchMatchesAndBets()
      fetchPlayoffsMatchesAndBets()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SVProgressHUD.dismiss()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    configureNavItems()
  }
  
  // MARK: - API
  
  @objc func fetchMatchesAndBets() {
    MatchesService.shared.fetchMatchesAndBets(by: group?.name) { matches in
      self.matches = matches
      DispatchQueue.main.async {
        self.refreshControl.endRefreshing()
      }
    }
  }
  
  @objc func fetchPlayoffsMatchesAndBets() {
    MatchesService.shared.fetchPlayoffsMatchesAndBets(by: playoff?.name) { matches in
      self.matches = matches
      DispatchQueue.main.async {
        self.refreshControl.endRefreshing()
      }
    }
  }
  
  // MARK: - Selectors
  

  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .white
    collectionView.register(MatchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    refreshControl.addTarget(self, action: #selector(fetchPlayoffsMatchesAndBets), for: .valueChanged)
    refreshControl.tintColor = .grassGreen
    collectionView.alwaysBounceVertical = true
    collectionView.refreshControl = refreshControl
  }
  
  func configureNavItems() {
//    parent?.parent?.navigationItem.title = "Grupo \(group!.name)"
    parent?.parent?.navigationItem.title = playoff!.name
    //parent?.parent?.navigationItem.rightBarButtonItem = filterButton
  }
  
}


//MARK: UICollectionViewDelegate/DataSource
extension BetsCollectionController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return matches.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MatchCell
    
    cell.delegate = self
    
    let match = matches[indexPath.row]
    cell.match = match
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    DispatchQueue.main.async {
      let match = self.matches[indexPath.row]
      
      if (match.finishedmatch == "SIM") {
        let betVC = BetsController(collectionViewLayout: UICollectionViewFlowLayout())
        betVC.match = match
        self.present(betVC, animated: true, completion: nil)
      } else {
        let betVC = BetController(match: match)
        betVC.onDoneBlock = { result in
          self.fetchPlayoffsMatchesAndBets()
        }
        self.present(betVC, animated: true, completion: nil)
      }
      
    }

    print("didSelectItemAt")
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
extension BetsCollectionController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 106 )
  }
}


//MARK: - MatchCellDelegate
extension BetsCollectionController: MatchCellDelegate {
  func handleMatchTapped() {

  }
  
}
