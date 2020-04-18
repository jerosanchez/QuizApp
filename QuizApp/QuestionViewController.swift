import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    private var question = ""
    private var options = [String]()
    private var selectionCallback: ([String]) -> Void = { _ in }
    
    convenience init(question: String, options: [String], selectionCallback: @escaping ([String]) -> Void) {
        self.init()
        self.question = question
        self.options = options
        self.selectionCallback = selectionCallback
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = question
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension QuestionViewController: UITableViewDataSource {
    private var cellId: String { return "Cell" }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCell(in: tableView)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
    
    // Helpers
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: cellId)
    }
}

extension QuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionCallback(selectedOptions(in: tableView))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selectionCallback(selectedOptions(in: tableView))
        }
    }
    
    // Helpers
    
    private func selectedOptions(in tableView: UITableView) -> [String] {
        guard let indexPaths = tableView.indexPathsForSelectedRows else { return [] }
        return indexPaths.map({ options[$0.row] })
    }
}
