//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Sopilniak on 27.08.2023.
//

import UIKit
import EssentialFeed

public final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    
    public convenience init (loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self ]_ in
            self?.refreshControl?.endRefreshing()
        }
    }
}

