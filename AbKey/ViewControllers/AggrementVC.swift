//
//  AggrementVC.swift
//  AbKey
//
//  Created by Divyanah on 26/03/24.
//

import UIKit
import WebKit

class AggrementVC: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the web view and add it to the view hierarchy
        webView = WKWebView(frame: self.view.bounds)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        // Set up constraints for the web view
        setupWebViewConstraints()

        // Load the HTML file
        loadLocalHTMLFile()
    }

    func setupWebViewConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

//    func loadLocalHTMLFile() {
//        if let htmlPath = Bundle.main.path(forResource: "Agreement", ofType: "html"),
//           let htmlContent = try? String(contentsOfFile: htmlPath, encoding: .utf8) {
//            let modifiedHtmlContent = htmlContent.replacingOccurrences(of: "<head>", with: Constants.HtmlMetaData)
//            webView.loadHTMLString(modifiedHtmlContent, baseURL: Bundle.main.bundleURL)
//        }
//    }
    
    func loadLocalHTMLFile() {
        let fileName = UIDevice.current.userInterfaceIdiom == .pad ? "AgreementIpad" : "Agreement"
        
        if let htmlPath = Bundle.main.path(forResource: fileName, ofType: "html"),
           let htmlContent = try? String(contentsOfFile: htmlPath, encoding: .utf8) {
            let modifiedHtmlContent = htmlContent.replacingOccurrences(of: "<head>", with: Constants.HtmlMetaData)
            webView.loadHTMLString(modifiedHtmlContent, baseURL: Bundle.main.bundleURL)
        }
    }

    // Respond to orientation changes by updating the view layout
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            // This space is reserved for future adjustments if needed.
        }) { _ in
            self.webView.frame = self.view.bounds // Update the web view's frame to match the new orientation's bounds
        }
    }
}
