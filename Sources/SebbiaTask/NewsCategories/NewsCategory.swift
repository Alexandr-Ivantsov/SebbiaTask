//
//  NewsCategory.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation

struct NewsCategory: Codable {
    
    let list: [NewsCategoryList]?
    
}

struct NewsCategoryList: Codable, Hashable {
    
    let id: Int?
    let name: String?
    
    func hash(into hasher: inout Hasher) {
        guard let id else { return }
        
        hasher.combine(id)
    }
    
    static func == (lhs: NewsCategoryList, rhs: NewsCategoryList) -> Bool {
        lhs.id == rhs.id
    }
    
}

enum NewsCategoriesDisplayItem: Hashable {
    case loading(id: Int)
    case news(category: NewsCategoryList)
}
