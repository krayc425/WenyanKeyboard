//
//  GenerationStatus.swift
//  Wenyan
//
//  Created by Kuixi Song on 6/28/25.
//

import Foundation

enum GenerationStatus {

    case notStarted(emptyText: Bool)
    case inProgress(partial: String)
    case finished(result: Result<String, Error>)

    var isEmptyText: Bool {
        if case .notStarted(let emptyText) = self {
            return emptyText
        } else {
            return false
        }
    }

}
