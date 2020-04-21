import UIKit
import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase {
    
    let options = ["A1", "A2"]
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: makeSingleAnswerQuestion(question: "Q1")).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: makeSingleAnswerQuestion()).options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: makeSingleAnswerQuestion())
        controller.loadViewIfNeeded()
        
        XCTAssertFalse(controller.tableView.allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: makeMultipleAnswerQuestion(question: "Q1")).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: makeMultipleAnswerQuestion()).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        let controller = makeQuestionController(question: makeMultipleAnswerQuestion())
        controller.loadViewIfNeeded()
        
        XCTAssertTrue(controller.tableView.allowsMultipleSelection)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(question: Question<String>) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(options: [question: options])
    }
    
    private func makeQuestionController(question: Question<String>) -> QuestionViewController {
        return makeSUT(question: question).questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
    }
    
    private func makeSingleAnswerQuestion(question: String = "") -> Question<String> {
        return Question.singleAnswer(question)
    }
    
    private func makeMultipleAnswerQuestion(question: String = "") -> Question<String> {
        return Question.multipleAnswer(question)
    }
}
