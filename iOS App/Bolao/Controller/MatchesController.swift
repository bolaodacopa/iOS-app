//
//  MatchesController.swift
//  Bolao
//
//  Created by Vagner Machado on 10/10/22.
//

import UIKit
import SDWebImage
import SVProgressHUD

private let reuseIdentifier = "MatchCell"

class MatchesController: UICollectionViewController {
  
  // MARK: - Properties
  
  private var matches = [Match]() {
    didSet {
      DispatchQueue.main.async { [self] in
        configureUI()
        collectionView.reloadData()
      }
    }
  }
  
  private lazy var filterButton: UIBarButtonItem = {
    let img = UIImage(systemName: "list.bullet")
    let rightBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(filterButtonTapped))
    return rightBarButtonItem
  }()
  
  
  // MARK: - Lifecicle
  override func viewDidLoad() {
    super.viewDidLoad()
    if User.isLogged() {
      fetchMatchesAndBets()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SVProgressHUD.dismiss()
  }
  
  // MARK: - API
  
  func fetchMatchesAndBets() {
    MatchesService.shared.fetchMatchesAndBets(by: nil) { matches in
      self.matches = matches
    }
  }
  
  // MARK: - Selectors
  
  @objc func filterButtonTapped() {
    
    
    var actions: [(String, UIAlertAction.Style)] = []
    actions.append(("Original", UIAlertAction.Style.default))
    actions.append(("Data", UIAlertAction.Style.default))
    actions.append(("Grupo", UIAlertAction.Style.default))
    actions.append(("Rodada", UIAlertAction.Style.default))
    actions.append(("Cancelar", UIAlertAction.Style.cancel))
    
    //self = ViewController
    Alerts.showActionsheet(viewController: self, title: "Ordenar por", message: "", actions: actions) { [self] (index) in
      
      switch index {
      case 0:
        fetchMatchesAndBets()
        break
        
      case 1:
        let sortArray = matches.sorted(by: {$0.formatteddate < $1.formatteddate})
        matches = sortArray
        break
        
      case 2:
        let sortArray = matches.sorted(by: {$0.matchgroup < $1.matchgroup})
        matches = sortArray
        break
        
      case 3:
        let sortArray = matches.sorted(by: {$0.round < $1.round})
        matches = sortArray
        break
        
        
      default:
        break
      }
      actions.removeAll()
    }
  }
  
  
  // MARK: - Helpers
  
  func configureUI() {
    view.backgroundColor = .white
    navigationItem.title = "Palpites"
    navigationItem.rightBarButtonItem = filterButton
    
    collectionView.register(MatchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
}


//MARK: UICollectionViewDelegate/DataSource
extension MatchesController {
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return matches.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MatchCell
    
    let match = matches[indexPath.row]
    cell.match = match
    
    return cell
  }
  
}


//MARK: UICollectionViewDelegateFlowLayout
extension MatchesController : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width:  view.frame.width, height: 100 )
  }
}



extension MatchesController: MatchCellDelegate {
  func handleMatchTapped() {
    print("handleMatchTapped")
  }
  
}
