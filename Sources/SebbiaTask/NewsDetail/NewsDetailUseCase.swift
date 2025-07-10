//
//  NewsDetailUseCase.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 10.07.2025.
//

import Foundation
import CacheManagerWithoutKeychain
import RxSwift

protocol NewsDetailUseCase: AnyObject {
    func getNewsDetail() -> Single<NewsDetail>
}

final class NewsDetailUseCaseImpl: NewsDetailUseCase {
    
    // MARK: - Private properties
    
    private let repository: NewsDetailRepository
    private let cacheUseCase: CacheUseCase
    private let id: Int
    private var newsDetailKey: String { "newsDetail_\(id)" }
    
    // MARK: - Life cycle
    
    init(repository: NewsDetailRepository, cacheUseCase: CacheUseCase, id: Int) {
        self.repository = repository
        self.cacheUseCase = cacheUseCase
        self.id = id
    }
    
    // MARK: - Public methods
    
    func getNewsDetail() -> Single<NewsDetail> {
        if let cachedData: NewsDetail? = try? cacheUseCase.load(from: newsDetailKey), let data = cachedData {
            return Single.just(data)
        }
        
        return repository.getNewsDetail(id: id)
            .flatMap{ [weak self] newsDetail -> Single<NewsDetail> in
                guard let self else { return Single.just(newsDetail) }
                
                do {
                    try self.cacheUseCase.save(data: newsDetail, for: self.newsDetailKey)
                } catch {
                    print(#file, "Falied to save data to cache")
                }
                
                return Single.just(newsDetail)
            }
    }
    
}
