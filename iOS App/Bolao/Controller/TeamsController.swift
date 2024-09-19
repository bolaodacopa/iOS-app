//
//  MatchesController.swift
//  Bolao
//
//  Created by Vagner Machado on 23/09/22.
//

import UIKit
import SDWebImage
import SVProgressHUD

private let reuseIdentifier = "TeamCell"

class TeamsController: UICollectionViewController {
  
  // MARK: - Properties
  
  var user: User? {
    didSet {
      configureUI()
    }
  }
  
  private var teams = [Team]() {
    didSet {
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  // MARK: - Lifecicle
  override func viewDidLoad() {
    super.viewDidLoad()
    if User.isLogged() {
      fetchTeams()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SVProgressHUD.dismiss()
  }
  
  // MARK: - API
  
  func fetchTeams() {
    MatchesService.shared.fetchTeams { teams in
      self.teams = teams
    }
  }
  
  // MARK: - Selectors
  
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .white
    navigationItem.title = "Times"
    
    collectionView.register(TeamCell.self, forCellWithReuseIdentifier: reuseIdentifier )
  }
  
}


//MARK: UICollectionViewDelegate/DataSource
extension TeamsController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return teams.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TeamCell
    
    cell.team = teams[indexPath.row]

    return cell
  }
  
}


//MARK: UICollectionViewDelegateFlowLayout
extension TeamsController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width:  view.frame.width, height: 100 )
  }
}

