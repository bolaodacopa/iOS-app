//
//  Alerts.swift
//  Bolao
//
//  Created by Vagner Machado on 03/10/22.
//

import UIKit

class Alerts {
  static func showActionsheet(viewController: UIViewController, title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: @escaping (_ index: Int) -> Void) {
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    for (index, (title, style)) in actions.enumerated() {
      let alertAction = UIAlertAction(title: title, style: style) { (_) in
        completion(index)
      }
      alertViewController.addAction(alertAction)
    }
    // iPad Support
    alertViewController.popoverPresentationController?.sourceView = viewController.view
    viewController.present(alertViewController, animated: true, completion: nil)
  }
}
