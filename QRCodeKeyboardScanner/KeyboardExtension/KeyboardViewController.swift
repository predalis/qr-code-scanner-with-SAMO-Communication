import SwiftUI
import UIKit

final class KeyboardViewController: UIInputViewController {
    private let store = ScannedCodeStore()
    private var hostingController: UIHostingController<KeyboardRootView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        renderKeyboard()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshKeyboard()
        tryAutoInsertPendingCode()
    }

    private func renderKeyboard() {
        let root = keyboardRootView()

        let host = UIHostingController(rootView: root)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(host)
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        host.didMove(toParent: self)
        hostingController = host
    }

    private func refreshKeyboard() {
        hostingController?.rootView = keyboardRootView()
    }

    private func keyboardRootView() -> KeyboardRootView {
        KeyboardRootView(
            currentCode: store.lastScannedCode,
            onScanTap: { [weak self] in
                guard let self,
                      let url = URL(string: "qrsamo://scan") else {
                    return
                }
                self.extensionContext?.open(url, completionHandler: nil)
            },
            onInsertTap: { [weak self] in
                self?.insertLatestCode()
            }
        )
    }

    private func insertLatestCode() {
        guard let code = store.lastScannedCode, !code.isEmpty else {
            return
        }
        textDocumentProxy.insertText(code)
    }

    private func tryAutoInsertPendingCode() {
        guard let pending = store.consumePendingInsert() else {
            return
        }
        textDocumentProxy.insertText(pending)
    }
}

private struct KeyboardRootView: View {
    let currentCode: String?
    let onScanTap: () -> Void
    let onInsertTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button("QR/Barcode lesen", action: onScanTap)
                .buttonStyle(.borderedProminent)

            if let currentCode, !currentCode.isEmpty {
                Text("Zuletzt gescannt: \(currentCode)")
                    .font(.footnote)
                    .lineLimit(2)
                Button("Zuletzt gescannten Text einfügen", action: onInsertTap)
                    .buttonStyle(.bordered)
            } else {
                Text("Noch kein Code gescannt")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(8)
    }
}
