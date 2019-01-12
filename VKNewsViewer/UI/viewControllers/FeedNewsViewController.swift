//
//  ViewController.swift
//  VKNewsViewer
//
//  Copyright © 2018 NIKO. All rights reserved.
//

import UIKit

let cellId = "cellId"

class FeedNewsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    var posts = [Post]()
    
    var queryStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.shared.getNews(backPost: { (posts) in
            self.setData(posts: posts, isNext: false)
        })
        
        setupNavigationBar()
        
        collectionView!.backgroundColor = UIColor("ecedf2")
        
        collectionView!.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView!.alwaysBounceVertical = true
        
    }
    
    func setupNavigationBar() {
        
        if let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor("527fb8").withAlphaComponent(0.95)

        }
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Поиск"
        searchBar.tintColor = UIColor("fbfbfb")
        (searchBar.value(forKey: "searchField") as! UITextField).textColor = UIColor("fbfbfb")
        (searchBar.value(forKey: "searchField") as! UITextField).backgroundColor = UIColor("001030").withAlphaComponent(0.5)
        navigationItem.titleView = searchBar
        navigationController?.hidesBarsOnSwipe = true
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
        postCell.post = posts[indexPath.item]
        return postCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let post = posts[indexPath.item]
        
        var contentHeight: CGFloat = 110
        let contentWidth = view.frame.width - 40 - view.safeAreaInsets.left - view.safeAreaInsets.right
        if let descriptionText = post.text {
            contentHeight += PostCell.calculateTextHeight(text: descriptionText, width: contentWidth) + 20
        }
        
        if post.photos.count > 0 {
            for ind in 0..<post.photos.count {
                contentHeight += CGFloat(post.photos[ind].height) * contentWidth / CGFloat(post.photos[ind].width)
            }
            contentHeight += CGFloat(post.photos.count - 1) * 10
        }

        return CGSize(width: view.frame.width, height: contentHeight)//450
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        checkGetNewPosts()

    }
    private var lastRequest = Date()
    private var requestTimeInterval = 5.0
    
    func checkGetNewPosts() {
        
        if let cell = collectionView?.visibleCells.last {
            if let path = collectionView!.indexPath(for: cell) {
                if path.item > posts.count - 5 {
                    
                    if lastRequest.timeIntervalSince1970 + requestTimeInterval > Date().timeIntervalSince1970 {
                        return
                    }
                    
                    lastRequest = Date()
                    requestTimeInterval = 5
                    
                    if queryStr == "" {
                        API.shared.getNews(backPost: { (posts) in
                            
                            self.requestTimeInterval = 0.0
                            self.setData(posts: posts, isNext: true)
                            
                        }, isGetNext: true)
                    } else {
                        API.shared.searchNews(query: queryStr,backPost: { (posts) in
                            
                            self.requestTimeInterval = 0.0
                            self.setData(posts: posts, isNext: true)
                            
                        }, isGetNext: true)
                    }

                    
                }
            }
        }
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        queryStr = searchBar.text!.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        API.shared.searchNews(query: queryStr, backPost: { (posts) in
            self.setData(posts: posts, isNext: false)
        })
        
    }
    
    func setData(posts: [Post], isNext: Bool) {
        if isNext {
            let firstIndex = self.posts.count
            self.posts.append(contentsOf: posts)
            DispatchQueue.main.async {
                self.collectionView!.performBatchUpdates({
                    var paths = [IndexPath]()
                    for ind in firstIndex..<self.posts.count {
                        paths.append(IndexPath(item: ind, section: 0))
                    }
                    self.collectionView!.insertItems(at: paths)
                    
                })
            }
        } else {
            self.posts = posts
            DispatchQueue.main.async {
                self.collectionView!.setContentOffset(CGPoint(x: 0, y: -100), animated: false)
                self.collectionView!.reloadData()
            }
        }
        
        
        
        
    }
    
}
