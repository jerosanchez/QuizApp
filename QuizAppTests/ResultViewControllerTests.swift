import Foundation
import XCTest
@testable import QuizApp

class ResultViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_rendersHeaderLabel() {
        XCTAssertEqual(makeSUT(summary: "a summary").headerLabel.text, "a summary")
    }
    
    func test_viewDidLoad_rendersAnswers() {
        XCTAssertEqual(makeSUT(answers: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(answers: [makeAnswer()]).tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_viewDidLoad_withCorrectAnswer_configuresCell() {
        let sut = makeSUT(answers: [makeAnswer(question: "Q1", answer: "A1", isCorrect: true)])

        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell

        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.answerLabel.text, "A1")
    }
    
    func test_viewDidLoad_withWrongAnswer_rendersWrongAnswerCell() {
        let sut = makeSUT(answers: [makeAnswer(isCorrect: false)])

        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell

        XCTAssertNotNil(cell)
    }
    
    func test_viewDidLoad_withWrongAnswer_configuresCell() {
        let sut = makeSUT(answers: [makeAnswer(question: "Q1", answer: "A1", isCorrect: false)])

        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell

        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(summary: String = "", answers: [PresentableAnswer] = []) -> ResultViewController {
        let sut = ResultViewController(summary: summary, answers: answers)
        sut.loadViewIfNeeded()
        return sut
    }
    
    private func makeAnswer(question: String = "", answer: String = "", isCorrect: Bool = Bool.random()) -> PresentableAnswer {
        return PresentableAnswer(question: question, answer: answer, isCorrect: isCorrect)
    }
}
