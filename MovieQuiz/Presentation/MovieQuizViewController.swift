import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate  {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    private var correctAnswers = 0
    
    private var currentQuestionIndex = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter = AlertPresenter()
    private var statisticService: StatisticServiceProtocol = StatisticService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory()
            questionFactory.delegate = self
            self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
        
        resetImageViewBorder()
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        // Необходимо для сброса текущей статистики
        //statisticService.resetStatistics()
    }
    
    private func resetImageViewBorder() {
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        if currentQuestionIndex == questionsAmount - 1 {
                    
           statisticService.store(correct: correctAnswers, total: questionsAmount)
                    
           let bestGame = statisticService.bestGame
           _ = bestGame.date.dateTimeString
                    
            
          let message = alertPresenter.makeResultsMessage(
            correctAnswers: correctAnswers,
            totalQuestions: questionsAmount,
            gamesCount: statisticService.gamesCount,
            bestGame: bestGame,
            totalAccuracy: statisticService.totalAccuracy
            )
                    
        
          let resultViewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: message,
            buttonText: "Сыграть ещё раз"
            )
                    
                    
          show(quiz: resultViewModel)
          } else {
                    
            resetImageViewBorder()
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
       }
    }
    
     private func show(quiz result: QuizResultsViewModel) {
         
         let bestGame = statisticService.bestGame
         _ = bestGame.date.dateTimeString
         
         let message = alertPresenter.makeResultsMessage(
             correctAnswers: correctAnswers,
             totalQuestions: questionsAmount,
             gamesCount: statisticService.gamesCount,
             bestGame: bestGame,
             totalAccuracy: statisticService.totalAccuracy
                )
         
        let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText) { [weak self] in guard let self = self else { return }
            self.alertPresenter.restartGame()
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.resetImageViewBorder()
            self.questionFactory?.requestNextQuestion()
            }
            alertPresenter.show(in: self, model: model)
        }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
           
                        self?.yesButton.isEnabled = true
                        self?.noButton.isEnabled = true
        }
    }
    
        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            yesButton.isEnabled = false
            noButton.isEnabled = false
            
            let givenAnswer = true
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
        
        @IBAction private func noButtonClicked(_ sender: UIButton) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            yesButton.isEnabled = false
            noButton.isEnabled = false
            let givenAnswer = false
            
            showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    }

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
