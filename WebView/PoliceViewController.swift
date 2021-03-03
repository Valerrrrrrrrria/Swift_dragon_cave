//
//  PoliceViewController.swift
//  1WIN
//
//  Created by Валерия Новикова on 02.03.2021.
//  Copyright © 2021 Валерия Новикова. All rights reserved.
//

import UIKit
import WebKit

class PoliceViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var policyWebView: WKWebView!
    
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        policyWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        policyWebView.uiDelegate = self
        view = policyWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://www.google.com")
        let myRequest = URLRequest(url: myURL!)
        policyWebView.load(myRequest)
    }
}
