//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Oleksandr Sopilniak on 13.04.2023.
//

import XCTest
import EssentialFeed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
}

protocol HTTPSessionTask {
    func resume()
}

class URLSessionHTTPClient {
    private let session: HTTPSession
    
    internal init(session: HTTPSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _ , error in
            if let error {
                completion(.failure(error))
            }
        }.resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    func test_getFromURL_resumeDataTaskWithURLs() {
        let url = URL(string: "adads")!
        let session = HTTPSessionSpy()
        let task = HTTPSeesionTaskTaskSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        session.stub(url: url, task: task)
        
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }

    func test_getFormURL_failsOnRequestError() {
        let url = URL(string: "adads")!
        let session = HTTPSessionSpy()
        let error = NSError(domain: "Any error", code: 1)
        let sut = URLSessionHTTPClient(session: session)
        
        session.stub(url: url, error: error)
        let exp = expectation(description: "Waint for an error")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Got result instead of expected error")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers
   
    private class HTTPSessionSpy: HTTPSession {
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: HTTPSessionTask
            let erorr: Error?
        }
        
        func stub(url: URL, task: HTTPSessionTask = FakeHTTPSeesionTaskTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, erorr: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask {
            guard let stub = stubs[url]  else {
                fatalError("Could not find stub for \(url)")
                
            }
            
            completionHandler(nil, nil, stub.erorr)
            return stub.task
        }
    }
    
    private class FakeHTTPSeesionTaskTask: HTTPSessionTask {
        func resume() {
        }
    }
    private class HTTPSeesionTaskTaskSpy: HTTPSessionTask  {
        var resumeCallCount = 0
        
        func resume() {
            resumeCallCount += 1
        }
    }
}
