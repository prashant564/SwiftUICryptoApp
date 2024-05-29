//
//  NetworkManager.swift
//  crypto-tracker
//
//  Created by PrashantDixit on 11/02/24.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkError: LocalizedError {
        case badUrlResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badUrlResponse(url: let url):
                return "Bad response from URL: \(url)"
            case .unknown:
                return "Unknown error occured"
            }
        }
    }
    
    static func getFetch(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
           .tryMap({ try handleResponse(output: $0, url: url) })
                // retries api call again if failed for first time
//           .retry(3)
           .eraseToAnyPublisher()
    }
    
    static func handleResponse(output:  URLSession.DataTaskPublisher.Output, url: URL) throws ->  Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.badUrlResponse(url: url)
        }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
            
        }
    }
}
