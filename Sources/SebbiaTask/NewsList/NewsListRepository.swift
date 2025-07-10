//
//  NewsListRepository.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 08.07.2025.
//

import Foundation
import Moya
import RxSwift
import RxMoya

protocol NewsListRepository: AnyObject {
    func getNewsList(id: Int) -> Single<NewsList>
}

final class NewsListRepositoryImpl: NewsListRepository {
    
    // MARK: - Private properties
    
    private let provider = MoyaProvider<NewsAPI>()
    
    // MARK: - Public methods
    
    func getNewsList(id: Int) -> Single<NewsList> {
        return provider.rx.request(NewsAPI.getNews(id: id))
            .filterSuccessfulStatusCodes()
            .map(NewsList.self)
    }
    
}
