//
//  HistoryTableViewController.swift
//  nrprime
//
//  Created by Marius Ilie on 29/03/17.
//  Copyright © 2017 Marius Ilie. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    var log: [[String: Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.log == nil {
            self.log = UserDefaults.standard.object(forKey: BrainLog.UserDefaultsKey) as? [[String: Any]]
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.log?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let numberValue = log?[(log?.count)! - indexPath.row - 1]["value"] {
            cell.textLabel?.text = "\(numberValue)"
        }
        
        if let status = log?[(log?.count)! - indexPath.row - 1]["status"] as? Bool {
            switch status {
            case true:
                cell.detailTextLabel?.text = BrainLog.StatusMessages.isPrime
            case false:
                cell.detailTextLabel?.text = BrainLog.StatusMessages.isNotPrime
            }
        } else {
            cell.detailTextLabel?.text = BrainLog.StatusMessages.isNotNumber
        }

        return cell
    }
}
