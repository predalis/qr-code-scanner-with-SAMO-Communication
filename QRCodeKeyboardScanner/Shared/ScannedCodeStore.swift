import Foundation

struct ScannedCodeStore {
    static let appGroupIdentifier = "group.com.predalis.qrkeyboardscanner"

    private enum Keys {
        static let lastScannedCode = "lastScannedCode"
        static let pendingInsertCode = "pendingInsertCode"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults? = UserDefaults(suiteName: ScannedCodeStore.appGroupIdentifier)) {
        self.defaults = defaults ?? .standard
    }

    var lastScannedCode: String? {
        defaults.string(forKey: Keys.lastScannedCode)
    }

    func setScannedCode(_ code: String) {
        defaults.set(code, forKey: Keys.lastScannedCode)
    }

    func markPendingInsert(_ code: String) {
        defaults.set(code, forKey: Keys.pendingInsertCode)
    }

    func consumePendingInsert() -> String? {
        guard let value = defaults.string(forKey: Keys.pendingInsertCode), !value.isEmpty else {
            return nil
        }
        defaults.removeObject(forKey: Keys.pendingInsertCode)
        return value
    }
}
