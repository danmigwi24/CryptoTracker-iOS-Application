//
//  APIService.swift
//  CoinBankingDK-UIKit
//
//  Created by Daniel Kimani on 26/04/2025.
//

// Services/APIService.swift
import Foundation





public func prettyPrintedJSONString(from jsonString: String) -> String {
       // Convert the JSON string into a Data object
       guard let data = jsonString.data(using: .utf8) else {
           return jsonString
       }

       // Convert the Data object into a JSON object
       guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
             let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
           return jsonString
       }

       // Convert the pretty-printed Data object back into a String
    return String(data: prettyPrintedData, encoding: .utf8) ?? jsonString
   }



enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case requestFailed(Error)
}

class APIService {
    static let shared = APIService()
    //
    // In a real app, you would store this securely or use environment variables
    private let apiKey = AppConfig.Current?.Environment?.apiKey ?? "" // Replace with your actual API key
    private let baseURL =  AppConfig.Current?.Environment?.baseApiUrl ?? ""//"https://api.coinranking.com/v2"//AVOID HANDCODED URLs
    
    private init() {}
    
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
                    //print("Received data:", rawString)
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
