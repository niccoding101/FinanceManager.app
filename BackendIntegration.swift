import UIKit

class BankIntegrationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var transactions: [Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTransactions()
    }
    
    func fetchTransactions() {
        // Placeholder for network request to fetch transactions
        // Assume we have a function fetchBankTransactions that returns [Transaction]
        
        // Example:
        // self.transactions = fetchBankTransactions()
        // self.tableView.reloadData()
    }
}

extension BankIntegrationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableViewCell, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        let transaction = transactions[indexPath.row]
        cell.textLabel?.text = "\(transaction.category ?? "") - \(transaction.amount)"
        return cell
    }
}
