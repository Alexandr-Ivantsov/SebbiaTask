//
//  NewsList.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 07.07.2025.
//

import Foundation

struct NewsList: Codable {
    
    let list: [NewsListItem]?
    
}

struct NewsListItem: Codable, Hashable {
    
    let id: Int?
    let title: String?
    let date: String?
    let shortDescription: String?
    
    func hash(into hasher: inout Hasher) {
        guard let id else { return }
        
        hasher.combine(id)
    }
    
    static func == (lhs: NewsListItem, rhs: NewsListItem) -> Bool {
        return lhs.id == rhs.id
    }
    
}

enum NewsListDisplayItem: Hashable {
    case loading(id: Int)
    case newsList(item: NewsListItem)
}
