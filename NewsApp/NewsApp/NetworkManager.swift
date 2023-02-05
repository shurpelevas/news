//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Alexandra Shurpeleva on 5.02.23.
//

import Foundation

class NetworkManager {
    let urlString = "https://newsapi.org/v2/everything?q=tesla&from=2023-01-05&sortBy=publishedAt&apiKey=5525ce8f98e54a2da1312d26fafdcc16"
    
    func fetchData(onComplete: @escaping (Result<News, Error>) -> Void) {
        if let url = URL(string: self.urlString) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let results = try decoder.decode(News.self, from: safeData)
                            onComplete(.success(results))
                        } catch {
                            onComplete(.failure(error))
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
}
