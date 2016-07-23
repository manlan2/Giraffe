//
//  Trending.swift
//  Giraffe-iOS
//
//  Created by Evgen Dubinin on 7/16/16.
//  Copyright © 2016 Yevhen Dubinin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import GiraffeKit

// MARK: - Model Protocol -

protocol TrendingModelType {
    func startPage() -> SignalProducer<Response?, GiraffeError>
    // TODO:
//    func nextPage() -> SignalProducer<Response?, GiraffeError>
}

// MARK: - Model Implementation -

final class Trending: TrendingModelType {
    let service: TrendingService
    
    init(service s: TrendingService) {
        self.service = s
    }
    
    func startPage() -> SignalProducer<Response?, GiraffeError> {
        let session = NSURLSession.sharedSession()
        let request = self.service.request()
        let retryAttempts = 3
        
        return session.rac_dataWithRequest(request)
            .retry(retryAttempts)
            .mapError{ _ in
                return GiraffeError.NetworkError
            }
            .flatMapError { networkError in
                print(networkError)
                return SignalProducer(error: networkError)
            }
            .map { data, URLResponse in
                // TODO: #1 make this reactive, so
                switch Response.decodedFrom(data: data, response: URLResponse) {
                case .Failure(let decodeError):
                    print("Parsing error occurred. Error was:\n\(decodeError)")
                    // TODO: #2 we can do the following:
//                    return SignalProducer(error: GiraffeError.ParserError)
                    return nil
                case .Success(let result):
                    return result
                }
        }
    }
}
