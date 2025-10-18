//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Дмитрий Шиляев on 02.10.2025.
//

import UIKit

final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    
    private var _gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    private var _bestGameCorrect: Int {
        get { storage.integer(forKey: Keys.bestGameCorrect.rawValue) }
        set { storage.set(newValue, forKey: Keys.bestGameCorrect.rawValue) }
    }
    
    private var _bestGameTotal: Int {
        get { storage.integer(forKey: Keys.bestGameTotal.rawValue) }
        set { storage.set(newValue, forKey: Keys.bestGameTotal.rawValue) }
    }
    
    private var _bestGameDate: Date {
        get { storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date() }
        set { storage.set(newValue, forKey: Keys.bestGameDate.rawValue) }
    }
    
    private var _totalCorrectAnswers: Int {
        get { storage.integer(forKey: Keys.totalCorrectAnswers.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue) }
    }
    
    private var _totalQuestionsAsked: Int {
        get { storage.integer(forKey: Keys.totalQuestionsAsked.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue) }
    }
    
    var gamesCount: Int {
        get { _gamesCount }
        set { _gamesCount = newValue }
    }
    
    var bestGame: GameResult {
        get {
            GameResult(
                correct: _bestGameCorrect,
                total: _bestGameTotal,
                date: _bestGameDate
            )
        }
        set {
            _bestGameCorrect = newValue.correct
            _bestGameTotal = newValue.total
            _bestGameDate = newValue.date
        }
    }
    
    var totalAccuracy: Double {
        guard _totalQuestionsAsked > 0 else { return 0.0 }
        return Double(_totalCorrectAnswers) / Double(_totalQuestionsAsked) * 100
    }
    
    func store(correct: Int, total: Int) {
    
        _totalCorrectAnswers += correct
        _totalQuestionsAsked += total
        gamesCount += 1
        
        let currentGame = GameResult(correct: correct, total: total, date: Date())

        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
    
    // Метод для сброса всей статистики
    func resetStatistics() {
        storage.removeObject(forKey: Keys.gamesCount.rawValue)
        storage.removeObject(forKey: Keys.bestGameCorrect.rawValue)
        storage.removeObject(forKey: Keys.bestGameTotal.rawValue)
        storage.removeObject(forKey: Keys.bestGameDate.rawValue)
        storage.removeObject(forKey: Keys.totalCorrectAnswers.rawValue)
        storage.removeObject(forKey: Keys.totalQuestionsAsked.rawValue)
    }
}
