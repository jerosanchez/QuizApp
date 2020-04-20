import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController
    func resultViewController(for result: QuizResult<Question<String>, String>) -> UIViewController
}

class NavigationControllerRouter: Router {
    
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func routeTo(question: Question<String>, answerCallback: @escaping (AnswerCallback)) {
        show(factory.questionViewController(for: question, answerCallback: answerCallback))
    }
    
    func routeTo(result: QuizResult<Question<String>, String>) {
        show(factory.resultViewController(for: result))
    }
    
    // MARK: - Helpers
    
    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}
