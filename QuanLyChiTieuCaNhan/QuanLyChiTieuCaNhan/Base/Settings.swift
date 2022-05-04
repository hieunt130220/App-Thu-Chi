import UIKit

final class Settings {
    static let shared = Settings()
    
    private var defaults = UserDefaults.standard
    
    private func read<T>(property: String = #function) -> T? {
        defaults.object(forKey: property) as? T

    }
    
    private func write<T>(value: T, to property: String = #function) {
        defaults.setValue(value, forKey: property)
        defaults.synchronize()
    }
}
extension Settings {
    var appVersion: String? {
        get { read() }
        set { write(value: newValue) }
    }
    var isFirstStartApp: Bool {
        get { read() ?? false }
        set { write(value: newValue) }
    }
    var isLogin: Bool {
        get { read() ?? false }
        set { write(value: newValue) }
    }
    var userId: String {
        get { read() ?? "" }
        set { write(value: newValue) }
    }
}
