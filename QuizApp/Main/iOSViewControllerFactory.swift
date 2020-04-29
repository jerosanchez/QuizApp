import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    
    private let questions: [Question<String>]
    private let options: [Question<String>: [String]]
    private let correctAnswers: [Question<String>: [String]]
    
    init(questions: [Question<String>], options: [Question<String>: [String]], correctAnswers: [Question<String>: [String]]) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = self.options[question] else {
            fatalError("Couldn't find options for question: \(question)")
        }
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    func resultViewController(for result: QuizResult<Question<String>, [String]>) -> UIViewController {
        let presenter = ResultPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        let controller = ResultViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
        controller.title = presenter.title
        return controller
    }
    
    // MARK: - Helpers
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            return questioViewController(for: question, value: value, options: options, allowsMultipleSelection: false, selectionCallback: answerCallback)
            
        case .multipleAnswer(let value):
            return questioViewController(for: question, value: value, options: options, allowsMultipleSelection: true, selectionCallback: answerCallback)
        }
    }
    
    private func questioViewController(for question: Question<String>, value: String, options: [String], allowsMultipleSelection: Bool, selectionCallback: @escaping ([String])
        -> Void) -> QuestionViewController {
        let controller = QuestionViewController(question: value, options: options, allowsMultipleSelection: allowsMultipleSelection, selectionCallback: selectionCallback)
        let questionPresenter = QuestionPresenter(questions: questions, question: question)
        controller.title = questionPresenter.title
        return controller
    }
}
