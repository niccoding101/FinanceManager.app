import UIKit
import CoreData

class BudgetManagerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var budgets: [Budget] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBudgets()
    }
    
    func fetchBudgets() {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        do {
            budgets = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching budgets: \(error)")
        }
    }
    
    @IBAction func addBudget(_ sender: Any) {
        let alert = UIAlertController(title: "Add Budget", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Category" }
        alert.addTextField { $0.placeholder = "Amount"; $0.keyboardType = .decimalPad }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let category = alert.textFields?[0].text,
                  let amountText = alert.textFields?[1].text, let amount = Double(amountText) else { return }
            
            let budget = Budget(context: context)
            budget.category = category
            budget.amount = amount
            
            do {
                try context.save()
                self.fetchBudgets()
            } catch {
                print("Error saving budget: \(error)")
            }
        }))
        present(alert, animated: true)
    }
}

extension BudgetManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgets.count
    }
    
    func tableView(_ tableView: UITableViewCell, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetCell", for: indexPath)
        let budget = budgets[indexPath.row]
        cell.textLabel?.text = "\(budget.category ?? "") - \(budget.amount)"
        return cell
    }
}
