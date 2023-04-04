import UIKit

protocol FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void)
}

struct Reachability {
    static let isNetworkAvailable: Bool = true
}

class FeedVC: UIViewController {
    var loader: FeedLoader!
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.loadFeed { _ in
            
        }
    }
}

// MARK: - Composition

class RemoteWithLocalFallbackFeedLoader: FeedLoader {
    let remote: FeedLoader
    let local: FeedLoader
    
    init(remote: RemoteFeedLoader, local: LocalFeedLoader) {
        self.remote = remote
        self.local = local
    }
    
    func loadFeed(completion: @escaping ([String]) -> Void) {
        let load = Reachability.isNetworkAvailable ? remote.loadFeed : local.loadFeed
        
        load(completion)
    }
}

// MARK: - Protocol impl

class RemoteFeedLoader: FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void) {
        // do smth
    }
}

class LocalFeedLoader: FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void) {
        // do smth
    }
}
