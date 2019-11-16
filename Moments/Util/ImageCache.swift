import UIKit

protocol ImageCacheProtocol: NSObjectProtocol {
    subscript(key: String) -> UIImage? { get set }
}

final class ImageCache: NSObject, ImageCacheProtocol {
    
    private let storage = NSCache<NSString, UIImage>()
    private var url: URL

    static var `default`: ImageCache {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return ImageCache(url: cachesURL)
    }

    init(url: URL) {
        self.url = url
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
            if let value: UIImage = newValue {
                storage.setObject(value, forKey: key as NSString)
                if let data = value.jpegData(compressionQuality: 0.5) {
                    saveToCaches(withPathName: key, data: data)
                }
            } else {
                storage.removeObject(forKey: key as NSString)
            }
        }
    }
    
    @discardableResult
    private func saveToCaches(withPathName name: String, data: Data) -> Bool {
        let fileURL = url.appendingPathComponent(name)
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let tempURL = try temporaryURL(for: fileURL).appendingPathComponent(UUID().uuidString)
                try data.write(to: tempURL, options: .atomicWrite)
                _ = try FileManager.default.replaceItemAt(fileURL, withItemAt: tempURL)
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
        UIImage(contentsOfFile: url.appendingPathComponent(name).path)
    }
    
    private func temporaryURL(for url: URL) throws -> URL {
        try FileManager.default.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: url, create: true)
    }
}
