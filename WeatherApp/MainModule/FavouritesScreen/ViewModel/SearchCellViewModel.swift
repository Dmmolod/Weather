import Foundation

class SearchCellViewModel {
    let cityName = Bindable<String>("")
    let country = Bindable<String>("")
    
    init(_ cityInfo: CityInfo) {
        self.cityName.value = cityInfo.cityRu
        setupCountryName(cityInfo.countryRu)
    }
    
    private func setupCountryName(_ country: String) {
        var abbreviation: String {
            return String(country.components(separatedBy: " ").compactMap({ $0.first })).uppercased()
        }
        self.country.value = country.count > 15 ? abbreviation : country
    }
}
