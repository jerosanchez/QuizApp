import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(for question: String, answerCallback: @escaping (String) -> Void) -> UIViewController
}

class NavigationControllerRouter: Router {
    
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func routeTo(question: String, answerCallback: @escaping (AnswerCallback)) {
        navigationController.pushViewController(factory.questionViewController(for: question, answerCallback: answerCallback), animated: true)
    }
    
    func routeTo(result: QuizResult<String, String>) { }
}
