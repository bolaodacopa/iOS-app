//
//  NewsController.swift
//  Bolao
//
//  Created by Vagner Machado on 30/09/22.
//

import UIKit
import WebKit


class NewsController: UIViewController, WKUIDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let webView = WKWebView()
    webView.uiDelegate = self
    self.view = webView
    
    //1. Load web site into my web view
    if let url = URL(string: "https://www.fifa.com/fifaplus/pt/news") {
      webView.load(URLRequest(url: url))
      webView.allowsBackForwardNavigationGestures = true
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
