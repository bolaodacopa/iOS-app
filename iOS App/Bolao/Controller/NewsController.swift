//
//  NewsController.swift
//  Bolao
//
//  Created by Vagner Machado on 30/09/22.
//

import UIKit
import WebKit
import SVProgressHUD


class NewsController: UIViewController, WKUIDelegate {
  
  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    SVProgressHUD.dismiss()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    let webView = WKWebView()
    webView.uiDelegate = self
    self.view = webView
    
    //Load web site into my webview
    let cbfUrlString = "https://www.cbf.com.br/feed-geral"
    let fifaUrlString = "https://www.fifa.com/fifaplus/pt/news"
    let geUrlString = "https://ge.globo.com/futebol/copa-do-mundo/"

    if let url = URL(string: fifaUrlString) {
      webView.load(URLRequest(url: url))
      webView.allowsBackForwardNavigationGestures = true
    }
  }

}
