import UIKit

enum Group: CaseIterable {
  case A
  case B
  case C
  case D
  case E
  case F
  case G
  case H
  
  var name: String {
    switch self {
    case .A:
      return "A"
    case .B:
      return "B"
    case .C:
      return "C"
    case .D:
      return "D"
    case .E:
      return "E"
    case .F:
      return "F"
    case .G:
      return "G"
    case .H:
      return "H"
    }
  }
  
  var index: Int {
    switch self {
    case .A:
      return 0
    case .B:
      return 1
    case .C:
      return 2
    case .D:
      return 3
    case .E:
      return 4
    case .F:
      return 5
    case .G:
      return 6
    case .H:
      return 7
    }
  }
}


class GroupPageViewController: UIViewController {
  
  private var pageController: UIPageViewController?
  private var groups: [Group] = Group.allCases
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
    
    let initialVC = BetsCollectionController(with: groups[0])
    self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
    self.pageController?.didMove(toParent: self)
  }
  
}

extension GroupPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

    guard let currentVC = viewController as? BetsCollectionController else { return nil }
    guard var index = currentVC.group?.index else { return nil }

    if index == 0 {
      return nil
    }
    
    index -= 1
    let vc = BetsCollectionController(with: groups[index])
    return vc
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    guard let currentVC = viewController as? BetsCollectionController else { return nil }
    guard var index = currentVC.group?.index else { return nil }

    if index >= self.groups.count - 1 {
      return nil
    }
    
    index += 1
    let vc = BetsCollectionController(with: groups[index])
    return vc
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return self.groups.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return self.currentIndex
  }
  
}
