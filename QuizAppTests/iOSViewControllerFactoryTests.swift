import UIKit
import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase {
    
    func test_questionViewController_createsControllerWithQuestion() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = makeSUT(options: [question: options])
        
        let controller = sut.questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
        
        XCTAssertEqual(controller.question, "Q1")
    }
    
    func test_questionViewController_createsControllerWithOptions() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = makeSUT(options: [question: options])

        let controller = sut.questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController

        XCTAssertEqual(controller.options, options)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(options: [Question<String>: [String]] = [:]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(options: options)
    }
}
