import Foundation
import QuizEngine

struct ResultPresenter {
    
    let result: QuizResult<Question<String>, [String]>
    let questions: [Question<String>]
    let correctAnswers: [Question<String>: [String]]
    
    var title: String {
        return "Result"
    }
    
    var summary: String {
        return "You got \(result.score)/\(result.answers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return questions.map { question in
            guard let userAnswer = self.result.answers[question],
                let correctAnswer = self.correctAnswers[question] else {
                fatalError("Couldn't find answers for question: \(question)")
            }
            return presentableAnswer(question, correctAnswer, userAnswer)
        }
    }
    
    // MARK: - Helpers
    
    private func presentableAnswer(_ question: Question<String>, _ correctAnswer: [String], _ userAnswer: [String]) -> PresentableAnswer {
        switch question {
        case .singleAnswer(let value), .multipleAnswer(let value):
            return PresentableAnswer(
                question: value,
                answer: formattedAnswer(correctAnswer),
                wrongAnswer: formattedWrongAnswer(correctAnswer, userAnswer))
        }
    }
    
    private func formattedAnswer(_ answer: [String]) -> String {
        return answer.joined(separator: ", ")
    }
    
    private func formattedWrongAnswer(_ correctAnswer: [String], _ userAnswer: [String]) -> String? {
        return (correctAnswer == userAnswer) ? nil : formattedAnswer(userAnswer)
    }
}
