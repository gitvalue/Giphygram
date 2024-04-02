import UIKit

/// Remote GIF data loader
final class GifLoader: ImageLoading {
    
    // MARK: - Model
    
    private final class CacheValue: NSObject {
        let data: Data
        let image: UIImage
        
        init(data: Data, image: UIImage) {
            self.data = data
            self.image = image
        }
    }
    
    // MARK: - Properties
    
    private let loadingQueue: OperationQueue = {
        let result = OperationQueue()
        result.underlyingQueue = .global(qos: .default)
        result.maxConcurrentOperationCount = 10
        
        return result
    }()
    
    @Atomic private var imagesBeingFetched: Set<URL> = []
    private let cache: NSCache<NSURL, CacheValue>
    
    // MARK: - Initialisers
    
    init(countLimit: Int) {
        cache = NSCache<NSURL, CacheValue>()
        cache.countLimit = countLimit
    }
    
    // MARK: - Public
    
    func fetchImage(_ url: URL, _ completion: @escaping (Result<(UIImage, Data), Error>) -> ()) {
        if let value = cache.object(forKey: url as NSURL) {
            completion(.success((value.image, value.data)))
            return
        }
        
        guard !imagesBeingFetched.contains(url) else { return }
        
        imagesBeingFetched.insert(url)

        let operation = AsynchronousOperation()
        operation.task = { [weak operation, weak self] in
            self?.loadImage(url, completion) {
                operation?.finish()
            }
        }
        
        loadingQueue.addOperation(operation)
    }
    
    func imageData(forUrl url: URL) -> Data? {
        return cache.object(forKey: url as NSURL)?.data
    }
    
    func image(forUrl url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)?.image
    }
    
    // MARK: - Private
    
    private func loadImage(
        _ url: URL,
        _ completion: @escaping (Result<(UIImage, Data), Error>) -> (),
        _ finalize: @escaping () -> ()
    ) {
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, error in
            guard let self else { return }
            
            self.imagesBeingFetched.remove(url)
            
            if let data, let image = self.previewImage(fromData: data) {
                self.cache.setObject(CacheValue(data: data, image: image), forKey: url as NSURL)
                completion(.success((image, data)))
            } else if let error {
                completion(.failure(error))
            }
            
            finalize()
        }
        
        task.resume()
    }
    
    private func previewImage(fromData data: Data) -> UIImage? {
        if let source = CGImageSourceCreateWithData(data as CFData, nil),
            let cgimage = CGImageSourceCreateImageAtIndex(source, 0, nil) {
            return UIImage(cgImage: cgimage)
        } else {
            return nil
        }
    }
}
