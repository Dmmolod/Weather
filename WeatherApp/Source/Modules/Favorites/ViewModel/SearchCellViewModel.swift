import Foundation

struct SearchCellViewModel {
    let cityName: String
    let country: String
    
    init(_ cityInfo: CityInfo) {
        
        let countryName = cityInfo.countryRu
        
        self.cityName = cityInfo.cityRu
        self.country = countryName.count > 15
        ? countryName.abbreviation
        : countryName
    }
}

extension String {
    var abbreviation: String {
        String(
            self
                .components(separatedBy: " ")
                .compactMap { $0.first }
        ).uppercased()
    }
}
