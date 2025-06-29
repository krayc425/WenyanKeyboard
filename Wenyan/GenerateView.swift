//
//  GenerateView.swift
//  Wenyan
//
//  Created by Kuixi Song on 6/9/25.
//

import FoundationModels
import SwiftUI

struct GenerateView: View {

    @State private var fromText: String = ""
    @State private var toText: String = ""
    @State private var status: GenerationStatus = .notStarted(emptyText: true)
    private let generator = WenyanGenerator.shared
    @FocusState private var inputFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("输入文字", text: $fromText, axis: .vertical)
                        .focused($inputFocused)
                    if !fromText.isEmpty {
                        Button("清空", role: .destructive) {
                            status = .notStarted(emptyText: true)
                            fromText = ""
                        }
                    }
                }
                .onChange(of: fromText) { oldValue, newValue in
                    status = .notStarted(emptyText: newValue.isEmpty)
                }
                Section {
                    Group {
                        switch status {
                            case .notStarted:
                                Button("转换") {
                                    Task {
                                        inputFocused = false
                                        toText = ""
                                        status = .inProgress(partial: "")
                                        do {
                                            for try await chunk in generator.generate(text: fromText) {
                                                toText = chunk
                                                status = .inProgress(partial: chunk)
                                            }
                                            status = .finished(result: .success(toText))
                                        } catch {
                                            status = .finished(result: .failure(error))
                                        }
                                    }
                                }
                                .disabled(status.isEmptyText)
                                .bold()
                            case .inProgress(let partial):
                                Text(partial)
                            case .finished(let result):
                                switch result {
                                    case .success(let output):
                                        if output.isEmpty {
                                            Text("无结果")
                                        } else {
                                            Text(output)
                                        }
                                    case .failure(let error):
                                        Text(error.localizedDescription)
                                            .foregroundStyle(.red)
                                }
                        }
                    }
                }
            }
            .navigationTitle("文言键盘")
        }
    }
}
