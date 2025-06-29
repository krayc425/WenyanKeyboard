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

    var isFinishedSuccessfully: Bool {
        if case .finished(let result) = self {
            switch result {
                case .success(let string):
                    return !string.isEmpty
                case .failure:
                    return false
            }
        } else {
            return false
        }
    }

}
