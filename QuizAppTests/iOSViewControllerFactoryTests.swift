import UIKit
import XCTest
@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase {
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    let options = ["A1", "A2"]
    
    func test_questionViewController_firstAnswer_createsControllerWithTitle() {
        let questionPresenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        
        let sut = makeSUT(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        let questionViewController = sut.questionViewController(for: singleAnswerQuestion, answerCallback: { _ in }) as! QuestionViewController
        
        XCTAssertEqual(questionViewController.title, questionPresenter.title)
    }
    
    func test_questionViewController_secondAnswer_createsControllerWithTitle() {
        let questionPresenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        
        let sut = makeSUT(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        let questionViewController = sut.questionViewController(for: multipleAnswerQuestion, answerCallback: { _ in }) as! QuestionViewController
        
        XCTAssertEqual(questionViewController.title, questionPresenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        XCTAssertFalse(makeQuestionController(question: singleAnswerQuestion).allowsMultipleSelection)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithSingleSelection() {
        XCTAssertTrue(makeQuestionController(question: multipleAnswerQuestion).allowsMultipleSelection)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(questions: [Question<String>] = [], question: Question<String>) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions: questions, options: [question: options])
    }
    
    private func makeQuestionController(question: Question<String>) -> QuestionViewController {
        return makeSUT(question: question).questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
    }
}
