import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var withTempSymbol: String {
        return self + "°"
    }
    
    var capitalizeFirstLetter: String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
