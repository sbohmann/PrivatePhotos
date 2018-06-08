
import Foundation

class CleanupSources {
    let fs = FileManager.default
    var filesModified = 0
    
    func run() {
        if correctLocation() {
            walkCurrentLocation()
        } else {
            print("Launched in wrong location: [" + fs.currentDirectoryPath + "]")
        }
    }
    
    func walkCurrentLocation() {
        walkDirectory(currentDirectory())
        reportResult()
    }
    
    func currentDirectory() -> URL {
        return URL(fileURLWithPath: fs.currentDirectoryPath)
    }
    
    func correctLocation() -> Bool {
        return fs.fileExists(atPath: "cleanup_sources/main.swift")
    }
    
    func walkDirectory(_ path: URL) {
        if let subPaths = try? fs.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: []) {
            subPaths.forEach({ subPath in handleSubPath(subPath) })
        }
    }
    
    func handleSubPath(_ path: URL) {
        if (path.lastPathComponent.hasPrefix(".")) {
            return
        }
        if path.pathExtension == "swift" {
            handleSwiftFile(path)
        }
        walkDirectory(path)
    }
    
    func handleSwiftFile(_ path: URL) {
        do {
            try adjustFile(path)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func adjustFile(_ path: URL) throws {
        let text = try readFile(path)
        let adjustedText = adjustText(text)
        if (adjustedText != text) {
            print("writing file " + path.path)
            try writeFile(path, adjustedText)
        }
    }
    
    func readFile(_ path: URL) throws -> String {
        return try String(contentsOf: path, encoding: .utf8)
    }
    
    func adjustText(_ text: String) -> String {
        var split = text.split(separator: "\n", omittingEmptySubsequences: false)
        var linesToOmit = 0
        for line in split {
            if line.hasPrefix("//") {
                linesToOmit += 1
            } else {
                break
            }
        }
        split.removeSubrange(0 ..< linesToOmit)
        return split.joined(separator: "\n")
    }
    
    func writeFile(_ path: URL, _ text: String) throws {
        try text.write(to: path, atomically: true, encoding: .utf8)
    }
    
    func reportResult() {
        if filesModified == 0 {
            print(localize("no files modified"))
        } else {
            print("\(filesModified) files were modified")
        }
    }
}

CleanupSources().run()
