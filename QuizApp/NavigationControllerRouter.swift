import UIKit
import QuizEngine

class NavigationControllerRouter: Router {
    
    private let navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func routeTo(question: String, answerCallback: @escaping (AnswerCallback)) {
        navigationController.pushViewController(UIViewController(), animated: false)
    }
    
    func routeTo(result: QuizResult<String, String>) { }
}
