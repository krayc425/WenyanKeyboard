//
//  KeyboardViewController.swift
//  WenyanKeyboard
//
//  Created by Kuixi Song on 6/28/25.
//

import SwiftUI
import UIKit

class KeyboardViewController: UIInputViewController {

    private lazy var hostingController = UIHostingController<KeyboardMainView>(
        rootView: KeyboardMainView(textInputProxy: textDocumentProxy))

    override func viewDidLoad() {
        super.viewDidLoad()

        WenyanGenerator.shared.prewarm()

        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}
