import UIKit
import CoreData

class ExpenseTrackerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var expenses: [Expense] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExpenses()
    }
    
    func fetchExpenses() {
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            expenses = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching expenses: \(error)")
        }
    }
    
    @IBAction func addExpense(_ sender: Any) {
        let alert = UIAlertController(title: "Add Expense", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Category" }
        alert.addTextField { $0.placeholder = "Amount"; $0.keyboardType = .decimalPad }
        alert.addTextField { $0.placeholder = "Date" }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            guard let category = alert.textFields?[0].text,
                  let amountText = alert.textFields?[1].text, let amount = Double(amountText),
                  let dateText = alert.textFields?[2].text, let date = self.dateFormatter.date(from: dateText) else { return }
            
            let expense = Expense(context: context)
            expense.category = category
            expense.amount = amount
            expense.date = date
            
            do {
                try context.save()
                self.fetchExpenses()
            } catch {
                print("Error saving expense: \(error)")
            }
        }))
        present(alert, animated: true)
    }
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension ExpenseTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        let expense = expenses[indexPath.row]
        cell.textLabel?.text = "\(expense.category ?? "") - \(expense.amount)"
        cell.detailTextLabel?.text = dateFormatter.string(from: expense.date ?? Date())
        return cell
    }
}
