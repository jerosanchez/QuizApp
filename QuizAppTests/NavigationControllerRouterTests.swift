import UIKit
import XCTest
@testable import QuizApp

class NavigationControllerRouterTests: XCTestCase {
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    lazy var sut = NavigationControllerRouter(navigationController, factory: factory)
    
    func test_routeToQuestions_showsQuestionController() {
        let firstViewController = UIViewController()
        factory.stub(question: "Q1", with: firstViewController)
        let secondViewController = UIViewController()
        factory.stub(question: "Q2", with: secondViewController)
        
        sut.routeTo(question: "Q1", answerCallback: { _ in })
        sut.routeTo(question: "Q2", answerCallback: { _ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentsQuestionControllerWithCorrectAnswerCallback() {
        var answerCallbackWasFired = false
        
        sut.routeTo(question: "Q1", answerCallback: { _ in answerCallbackWasFired = true })
        factory.answerCallbacks["Q1"]!("A1")

        XCTAssertTrue(answerCallbackWasFired)
    }
    
    // MARK: - Helpers
    
    class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = [String: UIViewController]()
        var answerCallbacks = [String: (String) -> Void]()
        
        func stub(question: String, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func questionViewController(for question: String, answerCallback: @escaping (String) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
    }
}
