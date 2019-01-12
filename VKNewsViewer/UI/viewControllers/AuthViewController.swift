//
//  AuthViewController.swift
//  VKNewsViewer
//
//  Copyright © 2018 NIKO. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController, UIWebViewDelegate {

    let webView: UIWebView = {
        let webView = UIWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isHidden = true
        webView.loadRequest(URLRequest(url: API.shared.authURL))
        return webView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(webView)
        view.backgroundColor = UIColor("ecedf2")

        webView.delegate = self
        
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        //Page is loaded do what you want
        if let str = webView.request?.mainDocumentURL?.absoluteString {
            let components = str.components(separatedBy: "access_token=")
            if components.count > 1 {
                if let token = components.last?.components(separatedBy: "&").first {
                    //"d5390e82bb3208451cd0fcbce39a027f4f161d969b2f7802e5fef4006753bfafa686fe60e11bd66d2fcbc&expires_in=86400&user_id=221533156"
                    API.shared.token = token
                    let components = str.components(separatedBy: "expires_in=")
                    if let expires = components.last?.components(separatedBy: "&").first{
                        API.shared.expires = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + Double(expires)!)

                    }

                    
                    showMainView()
                }
            } else {
                showAuth()
            }
        }
    }
    
    func showAuth() {
        
        guard webView.isHidden else {
            return
        }
        
        webView.isHidden = false
        navigationItem.title = "Авторизация"
    }
    
    func showMainView() {
        
        let feedNewsController = FeedNewsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.setViewControllers([feedNewsController], animated: true)
    }
    
}
