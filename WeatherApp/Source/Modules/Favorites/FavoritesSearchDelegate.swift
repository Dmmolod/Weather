//
//  FavoritesSearchDelegate.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 25.01.2023.
//

import UIKit

final class FavoritesSearchDelegate: NSObject, UISearchTextFieldDelegate {
    var textShouldBeginEditing: ((UITextField) -> Bool)?
    var shouldReturn: ((UITextField) -> Bool)?
    var shouldClear: ((UITextField) -> Bool)?
    var shouldChangeText: ((UITextField, NSRange, String) -> Bool)?
}

extension FavoritesSearchDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textShouldBeginEditing?(textField) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturn?(textField) ?? true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        shouldClear?(textField) ?? true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        shouldChangeText?(textField, range, string) ?? true
    }
}
