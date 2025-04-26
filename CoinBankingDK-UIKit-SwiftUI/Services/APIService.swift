//
//  APIService.swift
//  CoinBankingDK-UIKit
//
//  Created by Daniel Kimani on 26/04/2025.
//

// Services/APIService.swift
import Foundation
import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case requestFailed(Error)
}

class APIService {
    static let shared = APIService()
    
    // In a real app, you would store this securely or use environment variables
    private let apiKey = AppConfig.Current?.Environment?.apiKey ?? ""
    private let baseURL = AppConfig.Current?.Environment?.baseApiUrl ?? ""
    
    private init() {}
    
    // Combine version of fetchCoins
    func fetchCoinsPublisher(offset: Int = 0, limit: Int = 20) -> AnyPublisher<CoinResponse, APIError> {
        let endpoint = "/coins"
        let queryParams = "?offset=\(offset)&limit=\(limit)"
        
        guard let url = URL(string: baseURL + endpoint + queryParams) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-access-token")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> APIError in
                return .requestFailed(error)
            }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                //
                if let rawString = String(data: data, encoding: .utf8) {
                    print("RESPONSE STRING : \(prettyPrintedJSONString(from: rawString))\n")
                }
                
                return data
            }
            .decode(type: CoinResponse.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                }
                return .invalidData
            }
            .eraseToAnyPublisher()
    }
    
    // Combine version of fetchCoinDetails
    func fetchCoinDetailsPublisher(uuid: String) -> AnyPublisher<CoinResponse, APIError> {
        let endpoint = "/coin/\(uuid)"
        
        guard let url = URL(string: baseURL + endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-access-token")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> APIError in
                return .requestFailed(error)
            }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: CoinResponse.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                }
                return .invalidData
            }
            .eraseToAnyPublisher()
    }
    
    // Keep the original completion handler methods for backward compatibility
    func fetchCoins(offset: Int = 0, limit: Int = 20, completion: @escaping (Result<CoinResponse, APIError>) -> Void) {
        let endpoint = "/coins"
        let queryParams = "?offset=\(offset)&limit=\(limit)"
        
        guard let url = URL(string: baseURL + endpoint + queryParams) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-access-token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                if let rawString = String(data: data, encoding: .utf8) {
                    print("RESPONSE STRING : \(prettyPrintedJSONString(from: rawString))\n")
                }
                
                let decoder = JSONDecoder()
                let coinResponse = try decoder.decode(CoinResponse.self, from: data)
                print(coinResponse.status ?? "")
                
                completion(.success(coinResponse))
            } catch {
                print(error)
                
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func fetchCoinDetails(uuid: String, completion: @escaping (Result<CoinResponse, APIError>) -> Void) {
        let endpoint = "/coin/\(uuid)"
        
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-access-token")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let coinResponse = try decoder.decode(CoinResponse.self, from: data)
                completion(.success(coinResponse))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
