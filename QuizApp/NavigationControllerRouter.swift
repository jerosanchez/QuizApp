import UIKit
import QuizEngine

class NavigationControllerRouter: Router {
    
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func routeTo(question: Question<String>, answerCallback: @escaping (AnswerCallback)) {
        switch question {
        case .singleAnswer:
            show(factory.questionViewController(for: question, answerCallback: answerCallback))
        case .multipleAnswer:
            let button = UIBarButtonItem()
            let buttonController = SubmitButtonController(button, answerCallback)
            let viewController = factory.questionViewController(for: question, answerCallback: { selection in
                buttonController.update(selection)
                })
            viewController.navigationItem.rightBarButtonItem = button
            show(viewController)
        }
    }
    
    func routeTo(result: QuizResult<Question<String>, [String]>) {
        show(factory.resultViewController(for: result))
    }
    
    // MARK: - Helpers
    
    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

private class SubmitButtonController {
    let button: UIBarButtonItem
    let callback: ([String]) -> Void
    private var model = [String]()
    
    init(_ button: UIBarButtonItem, _ callback: @escaping ([String]) -> Void) {
        self.button = button
        self.callback = callback
        self.setup()
    }
    
    func update(_ model: [String]) {
        self.model = model
        updateButtonState()
    }
    
    private func setup() {
        button.isEnabled = false
        button.action = #selector(fireCallback)
        button.target = self
    }
    
    @objc private func fireCallback() {
        callback(model)
    }
    
    private func updateButtonState() {
        button.isEnabled = model.count > 0
    }
}
