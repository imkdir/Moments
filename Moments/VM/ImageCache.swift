import UIKit

private let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!

final class ImageCache: NSObject {
    
    private let storage = NSCache<NSString, UIImage>()
    private let manager = FileManager.default
    
    private var dir: FileManager.SearchPathDirectory
    
    init(dir: FileManager.SearchPathDirectory) {
        self.dir = dir
        super.init()
    }
    
    subscript(key: String) -> UIImage? {
        get {
            if let value = storage.object(forKey: key as NSString) {
                return value
            }
            return readFromCaches(withPathName: key)
        }
        set {
            if storage.object(forKey: key as NSString) != nil {
                return
            }
            storage.removeObject(forKey: key as NSString)
            if let value: UIImage = newValue {
                storage.setObject(value, forKey: key as NSString)
                if let data = value.jpegData(compressionQuality: 0) {
                    saveToCaches(withPathName: key, data: data)
                }
            }
        }
    }
    
    @discardableResult
    private func saveToCaches(withPathName name: String, data: Data) -> Bool {
        let fileURL = cachesURL.appendingPathComponent(name)
        do {
            if manager.fileExists(atPath: fileURL.path) {
                let tempURL = try temporaryURL(for: fileURL).appendingPathComponent(UUID().uuidString)
                try data.write(to: tempURL, options: .atomicWrite)
                _ = try manager.replaceItemAt(fileURL, withItemAt: tempURL)
                return true
            } else {
                try data.write(to: fileURL, options: .atomicWrite)
                return true
            }
        } catch {
            return false
        }
    }
    
    private func readFromCaches(withPathName name: String) -> UIImage? {
        return UIImage(contentsOfFile: cachesURL.appendingPathComponent(name).path)
    }
    
    private func temporaryURL(for url: URL) throws -> URL {
        return try manager.url(for: dir, in: .userDomainMask, appropriateFor: url, create: true)
    }
}
