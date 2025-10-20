//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Дмитрий Шиляев on 20.10.2025.
//

import UIKit
private var statisticService: StatisticServiceProtocol = StatisticService()

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex >= questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func getCurrentQuestionIndex() -> Int {
        currentQuestionIndex
    }
    func convert(model: QuizQuestion, currentIndex: Int, totalQuestions: Int) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentIndex + 1)/\(totalQuestions)"
        )
    }
}
