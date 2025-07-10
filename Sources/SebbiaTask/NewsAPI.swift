//
//  NewsAPI.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Moya
import Foundation

enum NewsAPI {
    case getCategories
    case getNews(id: Int)
    case getNewsDetails(id: Int)
}

extension NewsAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://testtask.sebbia.com/v1/news") else {
            fatalError("Invalid base URL")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .getCategories:
            return "/categories"
        case .getNews(let id):
            return "/categories/\(id)/news"
        case .getNewsDetails(_):
            return "/details"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getCategories, .getNews(_):
               return .requestPlain
        case .getNewsDetails(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
}
