import XCTest
import QuizEngine
@testable import QuizApp

class ResultsPresenterTests: XCTestCase {
    
    let singleAnswerQuestion1 = Question.singleAnswer("Q1")
    let singleAnswerQuestion2 = Question.multipleAnswer("Q2")
    let multipleAnswerQuestion1 = Question.multipleAnswer("Q1")
    let multipleAnswerQuestion2 = Question.multipleAnswer("Q2")
    
    func test_title_returnsFormattedTitle() {
        let sut = makeSUT(result: QuizResult(answers: [:], score: 0), questions: [])
        
        XCTAssertEqual(sut.title, "Result")
    }
    
    func test_summary_WithTwoQuestionsAndScoreOne_returnsSummary() {
        let answers = [singleAnswerQuestion1: ["A1"], singleAnswerQuestion2: ["A2", "A3"]]
        let result = QuizResult(answers: answers, score: 1)
        
        let sut = makeSUT(result: result, questions: [singleAnswerQuestion1, singleAnswerQuestion2])
        
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func test_presentableAnswers_withoutQuestions_isEmpty() {
        let answers = [Question<String>: [String]]()
        let result = QuizResult(answers: answers, score: 0)
        
        XCTAssertEqual(makeSUT(result: result).presentableAnswers.count, 0)
    }
    
    func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
        let answers = [singleAnswerQuestion1: ["A1"]]
        let correctAnswers = [singleAnswerQuestion1: ["A2"]]
        let result = QuizResult(answers: answers, score: 0)
        
        let sut = makeSUT(result: result, questions: [singleAnswerQuestion1], correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
        let answers = [multipleAnswerQuestion1: ["A1", "A4"]]
        let correctAnswers = [multipleAnswerQuestion1: ["A2", "A3"]]
        let result = QuizResult(answers: answers, score: 0)
        
        let sut = makeSUT(result: result, questions: [multipleAnswerQuestion1], correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }
    
    func test_presentableAnswers_withTwoQuestions_mapsOrderedAnswers() {
        let answers = [singleAnswerQuestion2: ["A2"], multipleAnswerQuestion1: ["A1", "A3"]]
        let correctAnswers = [singleAnswerQuestion2: ["A2"], multipleAnswerQuestion1: ["A1", "A3"]]
        let orderedQuestions = [multipleAnswerQuestion1, singleAnswerQuestion2]
        let result = QuizResult(answers: answers, score: 1)

        let sut = makeSUT(result: result, questions: orderedQuestions, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 2)

        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A3")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)

        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.answer, "A2")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(result: QuizResult<Question<String>, [String]> = QuizResult(answers: [:], score: 0), questions: [Question<String>] = [], correctAnswers: [Question<String>: [String]] = [:]) -> ResultPresenter {
        
        return ResultPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
    }
}
