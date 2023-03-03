import UIKit

protocol ImageLoadable {
    func fetchImageWith(id: String, completion: @escaping (Result<UIImage, Error>) -> ())
}

final class WeatherIconService {
            
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    private let imageLoader: ImageLoadable
    
    init(imageLoader: ImageLoadable = OpenWeatherImageLoader()) {
        self.imageLoader = imageLoader
    }
    
     func getIcon(for id: String, completion: @escaping (UIImage?, String) -> Void) {
         
         if let icon = getIconFromData(id) {
             completion(icon, id)
             return
         }
         loadIcon(with: id) { icon in
             completion(icon, id)
         }
    }
    
    private func save(_ image: UIImage, with id: String) {
        
        guard let imageURL = documentDirectory?.appendingPathComponent(id),
              !FileManager.default.fileExists(atPath: imageURL.path),
              let imageData = image.pngData() else { return }
        
        try? imageData.write(to: imageURL)
    }
    
    private func getIconFromData(_ id: String) -> UIImage? {
        guard let iconURL = documentDirectory?.appendingPathComponent(id),
              let iconData = try? Data(contentsOf: iconURL),
              let icon = UIImage(data: iconData) else { return nil }
        
        return icon
    }
    
    private func loadIcon(with id: String, completion: @escaping (UIImage) -> Void) {
        
        imageLoader.fetchImageWith(id: id) { result in
            switch result {
            case let .success(icon):
                self.save(icon, with: id)
                completion(icon)
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
}
