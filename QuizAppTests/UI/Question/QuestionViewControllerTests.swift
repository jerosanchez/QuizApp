import Foundation
import XCTest
@testable import QuizApp

class QuestionViewControllerTests: XCTestCase {

    func test_viewDidLoad_rendersQuestionHeaderTest() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_rendersOptions() {
        XCTAssertEqual(makeSUT(options: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_rendersOptionsText() {
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.title(at: 1), "A2")
    }
    
    func test_viewDidLoad_withSingleSelection_configuresTableView() {
        XCTAssertFalse(makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false).tableView.allowsMultipleSelection)
    }
    
    func test_viewDidLoad_withMultipleSelection_configuresTableView() {
        XCTAssertTrue(makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true).tableView.allowsMultipleSelection)
    }
    
    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var receivedAnswers = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) { receivedAnswers = $0 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswers, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswers, ["A2"])
    }
    
    func test_optionDeselected_withSingleSelection_doesNotNotifiesDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSUT(options: ["A1"], allowsMultipleSelection: false) { _ in callbackCount += 1 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionsSelected_withMultipleSelectionEnabled_notifiesDelegateSelection() {
        var receivedAnswers = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) { receivedAnswers = $0 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswers, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswers, ["A1", "A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegate() {
        var receivedAnswers = [String]()
        let sut = makeSUT(options: ["A1"], allowsMultipleSelection: true) { receivedAnswers = $0 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswers, ["A1"])

        sut.tableView.deselect(row: 0)        
        XCTAssertEqual(receivedAnswers, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(question: String = "", options: [String] = [], allowsMultipleSelection: Bool = false, selectionCallback: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, allowsMultipleSelection: allowsMultipleSelection, selectionCallback: selectionCallback)
        sut.loadViewIfNeeded()
        
        return sut
    }
}
