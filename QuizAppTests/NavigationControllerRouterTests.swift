import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTests: XCTestCase {
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    lazy var sut = NavigationControllerRouter(navigationController, factory: factory)
    
    func test_routeToQuestions_showsQuestionController() {
        let firstViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q1"), with: firstViewController)
        let secondViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q2"), with: secondViewController)
        
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in })
        sut.routeTo(question: Question.singleAnswer("Q2"), answerCallback: { _ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToResult_showsResultController() {
        let firstViewController = UIViewController()
        let firstResult = QuizResult(answers: [Question.singleAnswer("Q1"): "A1"], score: 10)
        factory.stub(result: firstResult, with: firstViewController)
        let secondViewController = UIViewController()
        let secondResult = QuizResult(answers: [Question.singleAnswer("Q2"): "A2"], score: 20)
        factory.stub(result: secondResult, with: secondViewController)
        
        sut.routeTo(result: firstResult)
        sut.routeTo(result: secondResult)

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    // MARK: - Helpers
    
    class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubbedQuestions = [Question<String>: UIViewController]()
        private var stubbedResults = [QuizResult<Question<String>, String>: UIViewController]()
        var answerCallbacks = [Question<String>: (String) -> Void]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(result: QuizResult<Question<String>, String>, with viewController: UIViewController) {
            stubbedResults[result] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultViewController(for result: QuizResult<Question<String>, String>) -> UIViewController {
            return stubbedResults[result] ?? UIViewController()
        }
    }
}

extension QuizResult: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
    
    public static func == (lhs: QuizResult<Question, Answer>, rhs: QuizResult<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
}
