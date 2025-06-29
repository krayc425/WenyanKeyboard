//
//  KeyboardMainView.swift
//  WenyanKeyboard
//
//  Created by Kuixi Song on 6/28/25.
//

import SwiftUI

struct KeyboardMainView: View {

    let textInputProxy: UITextDocumentProxy

    @State private var originalText: String = ""
    @State private var convertedText: String = ""
    @State private var status: GenerationStatus = .notStarted(emptyText: true)

    var body: some View {
        VStack(alignment: .center, spacing: 8.0) {
            Button {
                let originalText = (textInputProxy.documentContextBeforeInput ?? "") + (textInputProxy.documentContextAfterInput ?? "")
                guard !originalText.isEmpty else {
                    return
                }
                self.originalText = originalText
                status = .inProgress(partial: "")
                Task {
                    do {
                        for try await chunk in WenyanGenerator.shared.generate(text: originalText) {
                            convertedText = chunk
                            status = .inProgress(partial: chunk)
                        }
                        status = .finished(result: .success(convertedText))
                    } catch {
                        status = .finished(result: .failure(error))
                    }
                }
            } label: {
                Text("转换")
            }
            .buttonStyle(.glass)
            if !convertedText.isEmpty {
                Text(convertedText)
            }
            if !convertedText.isEmpty {
                Button {
                    replaceText(replacement: convertedText)
                    originalText = ""
                    convertedText = ""
                } label: {
                    Text("替换")
                }
                .buttonStyle(.glass)
            }
        }
        .onAppear {
            status = .notStarted(emptyText: true)
            originalText = ""
            convertedText = ""
        }
        .frame(maxWidth: .infinity, idealHeight: 300.0)
        .background(.clear)
    }

    private func replaceText(replacement: String) {
        let beforeText = textInputProxy.documentContextBeforeInput ?? ""
        let afterText = textInputProxy.documentContextAfterInput ?? ""
        for _ in 0..<beforeText.count {
            textInputProxy.deleteBackward()
        }
        for _ in 0..<afterText.count {
            textInputProxy.adjustTextPosition(byCharacterOffset: 1)
        }
        for _ in 0..<afterText.count {
            textInputProxy.deleteBackward()
        }
        textInputProxy.insertText(replacement)
    }

}
