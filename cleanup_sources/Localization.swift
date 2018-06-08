
import Foundation

class MainBundle {
    let bundle: Bundle
    
    init() {
//        guard let path = Bundle.main.path(forResource: "en", ofType: "lproj") else {
//            fatalError("Could not find bundle path")
//        }
        let path = "DerivedData/PrivatePhotos/Build/Products/Debug/cleanup_sources localization.bundle"
        if !FileManager.default.fileExists(atPath: path) {
            fatalError("File not found: " + path)
        }
        guard let bundle = Bundle(path: path) else {
            fatalError("Could not load bundle from path " + path)
        }
        self.bundle = bundle
    }
}

let mainBundle = MainBundle()

public func localize(_ key: String) -> String {
    return NSLocalizedString(key, bundle: mainBundle.bundle, comment: "")
}
