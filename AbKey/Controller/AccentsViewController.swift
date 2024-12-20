//
//  AccentsViewController.swift
//  AbKey
//
//  Created by Divyanah on 11/03/24.
//

import UIKit
protocol AccentsViewControllerDelegate: AnyObject {
    func didSelectCell(selectedCount: Int)
    func hideEditDeleteStackView()
}

class AccentsViewController: UIViewController {
    
    @IBOutlet weak var accentTableView: UITableView!
    
    var customKeys: [(id: Int, key: String, value: String, keyboardType: String)] = []
    var selectedCellIds: Set<Int> = []
    
    weak var delegate: AccentsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch and reload data
        fetchDataAndReloadTable()
        accentTableView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Deselect all selected cells
        if let selectedIndexPaths = accentTableView.indexPathsForSelectedRows {
            for indexPath in selectedIndexPaths {
                accentTableView.deselectRow(at: indexPath, animated: false)
            }
        }
        // Clear the selectedCellIds when the view appears
        selectedCellIds.removeAll()
        
        // Notify the delegate to update selection count and hide edit/delete stack
        delegate?.didSelectCell(selectedCount: 0)
        
        // Notify the parent view controller to hide the stack view
        delegate?.hideEditDeleteStackView()
    }
    
    func fetchDataAndReloadTable() {
        // Fetch the data from the database with keyboardType "alphabetic"
        customKeys = SQLiteDBHelper.shared.read(forKeyboardType: Constants.AccentKeyboardTypeIdentifier)
        accentTableView.reloadData()
    }
    
    func deleteSelectedCells() {
        // Delete selected cell data from the database and local data model
        for id in selectedCellIds {
            SQLiteDBHelper.shared.delete(id: id)
            if let index = customKeys.firstIndex(where: { $0.id == id }) {
                customKeys.remove(at: index)
            }
        }
        
        if let tableView = accentTableView {
            tableView.reloadData()
        } else {
            print("numberTableView is nil")
        }
        
        // Clear the selected IDs
        selectedCellIds.removeAll()
        
        // Notify delegate to update UI as needed
        delegate?.didSelectCell(selectedCount: 0)
    }
}

// MARK: - UITableViewDataSource
extension AccentsViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.AccentsCellIdentifier, for: indexPath) as? AccentsVCCell else {
            return UITableViewCell()
        }
        
        // Configure the cell with data from the customKeys array
        let keyValuePair = customKeys[indexPath.row]
        cell.lblKey.text = keyValuePair.key
        cell.lblValue.text = keyValuePair.value
        
        if(Constants.IpadScreen) {
            cell.lblKey.font = UIFont.systemFont(ofSize: 24)
            cell.lblValue.font = UIFont.systemFont(ofSize: 24)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellId = customKeys[indexPath.row].id
        selectedCellIds.insert(cellId)
        delegate?.didSelectCell(selectedCount: selectedCellIds.count)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellId = customKeys[indexPath.row].id
        selectedCellIds.remove(cellId)
        delegate?.didSelectCell(selectedCount: selectedCellIds.count)
    }
}
