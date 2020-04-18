import UIKit

struct PresentableAnswer {
    let question: String
    let answer: String
    let isCorrect: Bool
}

class CorrectAnswerCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
}

class WrongAnswerCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var summary = ""
    private var answers = [PresentableAnswer]()
    
    private let correctAnswerCellId = "CorrectAnswerCell"
    private let wrongAnswerCellId = "WrongAnswerCell"
    
    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = summary
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CorrectAnswerCell", bundle: .main), forCellReuseIdentifier: correctAnswerCellId)
        tableView.register(UINib(nibName: "WrongAnswerCell", bundle: .main), forCellReuseIdentifier: wrongAnswerCellId)
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        return answer.isCorrect ? correctAnswerCell(with: answer) : wrongAnswerCell(with: answer)
    }
    
    func correctAnswerCell(with answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: correctAnswerCellId) as! CorrectAnswerCell
        cell.questionLabel.text = answer.question
        cell.answerLabel.text = answer.answer
        return cell
    }
    
    func wrongAnswerCell(with answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: wrongAnswerCellId) as! WrongAnswerCell
        cell.questionLabel.text = answer.question
        cell.correctAnswerLabel.text = answer.answer
        return cell
    }
}
