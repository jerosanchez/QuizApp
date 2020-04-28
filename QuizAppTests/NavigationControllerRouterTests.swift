import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTests: XCTestCase {
    
    let singleAnswerQ1 = Question.singleAnswer("Q1")
    let signleAnswerQ2 = Question.singleAnswer("Q2")
    let multipleAnswerQ1 = Question.multipleAnswer("Q1")
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    lazy var sut = NavigationControllerRouter(navigationController, factory: factory)
    
    func test_routeToQuestions_showsQuestionController() {
        let firstViewController = UIViewController()
        factory.stub(question: singleAnswerQ1, with: firstViewController)
        let secondViewController = UIViewController()
        factory.stub(question: signleAnswerQ2, with: secondViewController)
        
        sut.routeTo(question: singleAnswerQ1, answerCallback: { _ in })
        sut.routeTo(question: signleAnswerQ2, answerCallback: { _ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_withSingleAnswer_callbackIsFiredImmediately() {
        var callbackWasFired = false
        sut.routeTo(question: singleAnswerQ1) { _ in callbackWasFired = true }
        
        factory.answerCallbacks[singleAnswerQ1]!(["anything"])
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToQuestion_withSingleAnswer_doesNotConfigureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleAnswerQ1, with: viewController)
        
        sut.routeTo(question: singleAnswerQ1) { _ in }
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_withMultipleAnswer_callbackIsNotFiredImmediateley() {
        var callbackWasFired = false
        sut.routeTo(question: multipleAnswerQ1) { _ in callbackWasFired = true }
        
        factory.answerCallbacks[multipleAnswerQ1]!(["A1", "A2"])
        
        XCTAssertFalse(callbackWasFired)
    }
    
    func test_routeToQuestion_withMultipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQ1, with: viewController)
        
        sut.routeTo(question: multipleAnswerQ1) { _ in }
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_IsEnabledOnlyWhenAnOptionIsSelected() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQ1, with: viewController)
        
        sut.routeTo(question: multipleAnswerQ1) { _ in }
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallbacks[multipleAnswerQ1]!(["A1", "A2"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)

        factory.answerCallbacks[multipleAnswerQ1]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_firesCallbackWhenTapped() {
        var callbackWasFired = false
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQ1, with: viewController)
        sut.routeTo(question: multipleAnswerQ1) { _ in callbackWasFired = true }
        factory.answerCallbacks[multipleAnswerQ1]!(["A1", "A2"])
        
        viewController.navigationItem.rightBarButtonItem!.simulateTap()
        
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToResult_showsResultController() {
        let firstViewController = UIViewController()
        let firstResult = QuizResult(answers: [singleAnswerQ1: ["A1"]], score: 10)
        factory.stub(result: firstResult, with: firstViewController)
        let secondViewController = UIViewController()
        let secondResult = QuizResult(answers: [signleAnswerQ2: ["A2"]], score: 20)
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
        private var stubbedResults = [QuizResult<Question<String>, [String]>: UIViewController]()
        var answerCallbacks = [Question<String>: ([String]) -> Void]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(result: QuizResult<Question<String>, [String]>, with viewController: UIViewController) {
            stubbedResults[result] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultViewController(for result: QuizResult<Question<String>, [String]>) -> UIViewController {
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

private extension UIBarButtonItem {
    func simulateTap() {
        _ = target?.perform(action, with: nil)
    }
}
