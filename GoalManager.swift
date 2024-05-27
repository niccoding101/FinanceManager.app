import UIKit
import CoreData

class GoalManagerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var goals: [Goal] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGoals()
    }
    
    func fetchGoals() {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        do {
            goals = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching goals: \(error)")
        }
    }
    
    @IBAction func addGoal(_ sender: Any) {
        let alert = UIAlertController(title: "Add Goal", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Goal Name" }
        alert.addTextField { $0.placeholder = "Amount"; $0.keyboardType = .decimalPad }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let name = alert.textFields?[0].text,
                  let amountText = alert.textFields?[1].text, let amount = Double(amountText) else { return }
            
            let goal = Goal(context: context)
            goal.name = name
            goal.amount = amount
            
            do {
                try context.save()
                self.fetchGoals()
            } catch {
                print("Error saving goal: \(error)")
            }
        }))
        present(alert, animated: true)
    }
}

extension GoalManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableViewCell, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
        let goal = goals[indexPath.row]
        cell.textLabel?.text = "\(goal.name ?? "") - \(goal.amount)"
        return cell
    }
}
