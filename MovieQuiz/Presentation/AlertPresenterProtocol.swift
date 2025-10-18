//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Шиляев on 30.09.2025.
//

import UIKit

protocol AlertPresenterProtocol {
    func show(in viewController: UIViewController, model: AlertModel)
    func makeResultsMessage(correctAnswers: Int, totalQuestions: Int, gamesCount: Int, bestGame: GameResult, totalAccuracy: Double) -> String
}
