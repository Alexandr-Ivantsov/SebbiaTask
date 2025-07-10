//
//  NewsDetail.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 07.07.2025.
//

import Foundation

struct NewsDetail: Codable {
    
    let news: News
    
}

struct News: Codable {
    
    let fullDescription: String?
    
}

enum NewsDetailDisplayItem {
    case loading(id: Int)
    case newsDetail(item: News)
}
