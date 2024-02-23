//
//  APIManager.swift
//  Fall_Game
//
//  Created by Oleg Zakladnyi on 23.02.2024.
//


import Foundation

class APIManager {
    static let shared = APIManager()
    
    func fetchData(completion: @escaping (Result<GameOver, Error>) -> Void) {
        let urlString = "https://2llctw8ia5.execute-api.us-west-1.amazonaws.com/prod"
        
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                    return
                }
                
                if let data = data {
                    do {
                        let gameOver = try JSONDecoder().decode(GameOver.self, from: data)
                        completion(.success(gameOver))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
}
