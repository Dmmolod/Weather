//
//  FavoritesListUpdateChecker.swift
//  tms-14-WeatherApp
//
//  Created by Дмитрий Молодецкий on 01.03.2023.
//

import Foundation

final class FavoritesListUpdateChecker {
    
    var needUpdateCallBack: (() -> ())?
    
    private var lastUpdateDate = Date()
    private var updateForecastTimer: Timer?
    
    func start() {
        startUpdateTimer()
    }
    
    func stop() {
        killUpdateTimer()
    }
    
    private func startUpdateTimer() {
        let currentDate = Date()
        var timerFireDate: Date { return Date().addingTimeInterval(Double(60 - currentDate.second)) }
        
        if lastUpdateDate < currentDate && lastUpdateDate.minute < currentDate.minute {
            needUpdateCallBack?()
            lastUpdateDate = currentDate
        }
        
        updateForecastTimer = Timer(
            fire: timerFireDate,
            interval: 60,
            repeats: true,
            block: { [weak self] timer in
                self?.needUpdateCallBack?()
            }
        )
        
        guard let updateForecastTimer = updateForecastTimer else { return }
        RunLoop.main.add(updateForecastTimer, forMode: .default)
    }
    
    private func killUpdateTimer() {
        updateForecastTimer?.invalidate()
        updateForecastTimer = nil
    }
}
