//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Шиляев on 02.10.2025.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
    // Вызов функции сброса текущей статистики
    func resetStatistics()
}


