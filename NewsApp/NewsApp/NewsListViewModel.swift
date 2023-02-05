//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Alexandra Shurpeleva on 5.02.23.
//

import UIKit

class NewsListViewModel {
    private let networkNamager = NetworkManager()
    var newsList: [News] = []
    var screenState: Dynamic<ScreenState> = Dynamic(.loading)
    
    func getNewsList() {
        self.screenState.value = .loading
        self.networkNamager.fetchData { [weak self] feed in
            guard let self = self else { return }
            switch feed {
            case .success(let news):
                self.newsList = [news]
                self.screenState.value = .loaded(news.articles)
            case .failure(let error):
                self.screenState.value = .failed(error)
            }
        }
    }
}

enum ScreenState {
    case loading
    case loaded([Article]?)
    case failed(Error)
}
