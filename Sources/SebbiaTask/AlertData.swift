//
//  AlertData.swift
//  SebbiaTask
//
//  Created by Александр Иванцов on 24.06.2025.
//

import Foundation

struct AlertData {
    let title: String
    let message: String
    let actionTitle: String
    let actionHandler: (() -> Void)?
    
    init(
        title: String,
        message: String,
        actionTitle: String,
        actionHandler: (() -> Void)?
    ) {
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.actionHandler = actionHandler
    }
}
