//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Дмитрий Шиляев on 29.09.2025.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    func makeResultsMessage(correctAnswers: Int, totalQuestions: Int, gamesCount: Int, bestGame: GameResult, totalAccuracy: Double) -> String {
        let dateString = bestGame.date.dateTimeString
            return """
            Ваш результат: \(correctAnswers)/\(totalQuestions)
            Количество сыгранных квизов: \(gamesCount)
            Рекорд: \(bestGame.correct)/\(bestGame.total) (\(dateString))
            Средняя точность: \(String(format: "%.2f", totalAccuracy))%
            """
        }
    
    func show(in viewController: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"
        alert.addAction(UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        })
        viewController.present(alert, animated: true, completion: nil)
    }
}
    
