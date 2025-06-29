//
//  WenyanGenerator.swift
//  Wenyan
//
//  Created by Kuixi Song on 6/9/25.
//

import Foundation
import FoundationModels

final class WenyanGenerator {

    static let shared = WenyanGenerator()
    private let instructions = """
        你是一位中文系教授，输出尽量简洁，保持原文的意思，不要添加额外的信息。
        """
    private lazy var session = LanguageModelSession(instructions: instructions)

    private init() {
#if DEBUG
        dump(SystemLanguageModel.default.supportedLanguages)
#endif
    }

    func prewarm() {
        session.prewarm()
    }

    func generate(text: String) -> AsyncThrowingStream<String, Error> {
        return AsyncThrowingStream<String, Error> { continuation in
            Task {
                let prompt = "将文本转换成文言文：\(text)"
                let responseStream = session.streamResponse(
                    to: prompt,
                    options: GenerationOptions(sampling: .greedy)
                )
                do {
                    for try await chunk in responseStream {
                        continuation.yield(chunk)
                    }
                    continuation.finish()
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

}
