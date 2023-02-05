//
//  News.swift
//  NewsApp
//
//  Created by Alexandra Shurpeleva on 5.02.23.
//

import Foundation

struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]?
}

struct Article: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAT: String?
    let content: String?
}
