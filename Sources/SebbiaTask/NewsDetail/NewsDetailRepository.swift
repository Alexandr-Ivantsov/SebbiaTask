//
//  NewsDetailRepository.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 10.07.2025.
//

import Foundation
import Moya
import RxSwift
import RxMoya

protocol NewsDetailRepository: AnyObject {
    func getNewsDetail(id: Int) -> Single<NewsDetail>
}

final class NewsDetailRepositoryImpl: NewsDetailRepository {
    
    // MARK: - Private properties
    
    private let provider = MoyaProvider<NewsAPI>()
    
    // MARK: - Public methods
    
    func getNewsDetail(id: Int) -> Single<NewsDetail> {
        return provider.rx.request(NewsAPI.getNewsDetails(id: id))
            .filterSuccessfulStatusCodes()
            .map(NewsDetail.self)
    }
    
}
