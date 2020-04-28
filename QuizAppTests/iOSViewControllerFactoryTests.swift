import UIKit
import XCTest
import QuizEngine

@testable import QuizApp

class iOSViewControllerFactoryTests: XCTestCase {
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    let options = ["A1", "A2"]
    
    // MARK: - Question VC
    
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
    
    // MARK: - Result VC
    
    func test_resultViewController_createsControllerWithSummary() {
        let (controller, presenter) = makeResults()

        XCTAssertEqual(controller.summary, presenter.summary)
    }
    
    func test_resultViewController_createsControllerWithPresentableAnswers() {
        let (controller, presenter) = makeResults()

        XCTAssertEqual(controller.answers.count, presenter.presentableAnswers.count)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(questions: [Question<String>]? = nil, question: Question<String>? = nil, correctAnswers: [Question<String>: [String]]? = nil) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions: questions ?? [singleAnswerQuestion, multipleAnswerQuestion], options: [question ?? Question.singleAnswer("Q1"): options], correctAnswers: correctAnswers ?? [:])
    }
    
    private func makeQuestionController(question: Question<String>) -> QuestionViewController {
        return makeSUT(question: question).questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
    }
    
    private func makeResults() -> (controller: ResultViewController, presenter: ResultPresenter) {
        let questions = [singleAnswerQuestion, multipleAnswerQuestion]
        let correctAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let userAnswers = [singleAnswerQuestion: ["A1"], multipleAnswerQuestion: ["A1", "A2"]]
        let result = QuizResult(answers: userAnswers, score: 2)
        let sut = makeSUT(questions: questions, correctAnswers: correctAnswers)
        let presenter = ResultPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        
        let controller = sut.resultViewController(for: result) as! ResultViewController
        
        return (controller, presenter)
    }
}
