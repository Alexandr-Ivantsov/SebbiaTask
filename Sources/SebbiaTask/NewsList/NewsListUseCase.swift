//
//  NewsListUseCase.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 08.07.2025.
//

import Foundation
import CacheManagerWithoutKeychain
import RxSwift

protocol NewsListUseCase: AnyObject {
    func getNewsList() -> Single<NewsList>
}

final class NewsListUseCaseImpl: NewsListUseCase {
    
    // MARK: - Private properties
    
    private let repository: NewsListRepository
    private let cacheUseCase: CacheUseCase
    private let id: Int
    private var newsListKey: String {
        "newsListKey_For_ID:\(id)"
    }
    
    // MARK: - Life cycle
    
    init(repository: NewsListRepository, cacheUseCase: CacheUseCase, id: Int) {
        self.repository = repository
        self.cacheUseCase = cacheUseCase
        self.id = id
    }
    
    // MARK: - Public methods
    
    func getNewsList() -> Single<NewsList> {
        if let cachedData: NewsList? = try? cacheUseCase.load(from: newsListKey),
           let data = cachedData {
            return Single.just(data)
        }
        
        return repository.getNewsList(id: id)
            .flatMap{ [weak self] newsList -> Single<NewsList> in
                guard let self else { return Single.just(newsList) }
                
                do {
                    try self.cacheUseCase.save(data: newsList, for: newsListKey)
                } catch {
                    print(#file, "Failed to save data to cache")
                }
                return Single.just(newsList)
            }
    }
    
}
