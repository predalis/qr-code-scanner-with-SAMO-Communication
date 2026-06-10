import SwiftUI

struct ContentView: View {
    @State private var scannedCode: String?
    @State private var pendingCode: String?
    @State private var showScanner = false

    private let store = ScannedCodeStore()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("QR/Barcode Keyboard Scanner")
                    .font(.title2)
                    .bold()

                Text("Nutze die Custom-Keyboard-Erweiterung in einem Eingabefeld. Tippe dort auf ‚QR/Barcode lesen‘, um diese App zu öffnen.")

                Button("QR/Barcode lesen") {
                    showScanner = true
                }
                .buttonStyle(.borderedProminent)

                if let scannedCode {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Erkannter Text:")
                            .font(.headline)
                        Text(scannedCode)
                            .font(.body.monospaced())
                    }
                }

                if let pendingCode {
                    Text("Bereit für Einfügen in Tastatur: \(pendingCode)")
                        .foregroundStyle(.green)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Scanner")
            .sheet(isPresented: $showScanner) {
                ScannerView { code in
                    scannedCode = code
                }
            }
            .onAppear {
                pendingCode = store.lastScannedCode
            }
            .onOpenURL { url in
                guard url.scheme == "qrsamo", url.host == "scan" else {
                    return
                }
                showScanner = true
            }
            .confirmationDialog(
                "Text für Tastatur übernehmen?",
                isPresented: Binding(get: { scannedCode != nil }, set: { if !$0 { scannedCode = nil } }),
                presenting: scannedCode
            ) { value in
                Button("Bestätigen") {
                    store.setScannedCode(value)
                    store.markPendingInsert(value)
                    pendingCode = value
                    scannedCode = nil
                }
                Button("Abbrechen", role: .cancel) {
                    scannedCode = nil
                }
            } message: { value in
                Text(value)
            }
        }
    }
}
