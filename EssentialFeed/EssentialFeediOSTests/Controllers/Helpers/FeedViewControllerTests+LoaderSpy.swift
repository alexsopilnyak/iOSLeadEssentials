//
//  FeedViewControllerTests+LoaderSpy.swift
//  EssentialFeediOSTests
//
//  Created by Oleksandr Sopilniak on 20.09.2023.
//

import Foundation
import EssentialFeed
import EssentialFeediOS

extension FeedViewControllerTests {
    final class LoaderSpy: FeedLoader, FeedImageDataLoader {
        
        // MARK: - FeedLoader
        
        var loadFeedCallCount: Int {
            loadFeedRequests.count
        }
        
        private var loadFeedRequests: [(FeedLoader.Result) -> Void] = []
        
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadFeedRequests.append(completion)
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            loadFeedRequests[index](.success(feed))
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            loadFeedRequests[index](.failure(error))
        }
        
        // MARK: - FeedImageDataLoader
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }
        
        private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        private(set) var cancelledImageURLs = [URL]()
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
        
        private struct TaskSpy: FeedImageDataLoaderTask {
            let cancellCallback: () -> Void
            
            func cancel() {
                cancellCallback()
            }
        }
    }
}
