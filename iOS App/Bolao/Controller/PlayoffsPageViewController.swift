//
//  PlayoffsPageViewController.swift
//  Bolao
//
//  Created by Vagner Machado on 02/12/22.
//

import UIKit

enum Playoffs: CaseIterable {
  case oitavas
  case quartas
  case semi
  case terceiro
  case finais

  var name: String {
    switch self {
    case .oitavas:
      return "OITAVASFINAL"
    case .quartas:
      return "QUARTASFINAL"
    case .semi:
      return "SEMIFINAL"
    case .terceiro:
      return "TERCEIRO"
    case .finais:
      return "FINAL"

    }
  }
  
  var index: Int {
    switch self {
    case .oitavas:
      return 0
    case .quartas:
      return 1
    case .semi:
      return 2
    case .terceiro:
      return 3
    case .finais:
      return 4
    }
  }
}


class PlayoffsPageViewController: UIViewController {
  
  private var pageController: UIPageViewController?
  private var playoffs: [Playoffs] = Playoffs.allCases
  private var currentIndex: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupPageController()
  }
  
  private func setupPageController() {
    self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    self.pageController?.dataSource = self
    self.pageController?.delegate = self
    self.pageController?.view.backgroundColor = .grassGreen
    self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
    self.addChild(self.pageController!)
    self.view.addSubview(self.pageController!.view)
    
    let initialVC = BetsCollectionController(with: playoffs[0])
    self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
    self.pageController?.didMove(toParent: self)
  }
  
}

extension PlayoffsPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

    guard let currentVC = viewController as? BetsCollectionController else { return nil }
    guard var index = currentVC.playoff?.index else { return nil }

    if index == 0 {
      return nil
    }
    
    index -= 1
    let vc = BetsCollectionController(with: playoffs[index])
    return vc
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    guard let currentVC = viewController as? BetsCollectionController else { return nil }
    guard var index = currentVC.playoff?.index else { return nil }

    if index >= self.playoffs.count - 1 {
      return nil
    }
    
    index += 1
    let vc = BetsCollectionController(with: playoffs[index])
    return vc
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return self.playoffs.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return self.currentIndex
  }
  
}
