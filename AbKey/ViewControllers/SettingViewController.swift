//
//  SettingViewController.swift
//  AbKey
//
//  Created by Divyanah on 08/03/24.
//

import UIKit
import LZViewPager

class SettingViewController: UIViewController,LZViewPagerDelegate,LZViewPagerDataSource,AlphabetViewControllerDelegate,NumbersViewControllerDelegate,AccentsViewControllerDelegate{
    
    
    @IBOutlet weak var viewPager: LZViewPager!
    
    @IBOutlet weak var abKeyStackView: UIStackView!
    @IBOutlet weak var editDeleteStackView: UIStackView!
    
    @IBOutlet weak var lblSelectedRowCount: UILabel!
    @IBOutlet weak var lblAbKey: UILabel!
    
    private var subControllers:[UIViewController] = []
    
    var premiumValueFromRTPlusManager: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editDeleteStackView.isHidden = true
        viewPagerProperties()
        
        if premiumValueFromRTPlusManager >= 1{
            lblAbKey.text = "abKey Pro(Premium)"
        }else{
            lblAbKey.text = "abKey Pro(Lite)"
        }
    }
    
    func viewPagerProperties(){
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
        let alphabetVC = UIStoryboard(name: "Main", bundle:
        nil).instantiateViewController(withIdentifier: "AlphabetViewController") as! AlphabetViewController
        alphabetVC.delegate = self
        
        let numberVC = UIStoryboard(name: "Main", bundle:
        nil).instantiateViewController(withIdentifier: "NumbersViewController") as! NumbersViewController
        numberVC.delegate = self
        
        let accentsVC = UIStoryboard(name: "Main", bundle:
        nil).instantiateViewController(withIdentifier: "AccentsViewController") as! AccentsViewController
        accentsVC.delegate = self
        
        alphabetVC.title = "Alphabets"
        numberVC.title = "Numbers"
        accentsVC.title = "Accents"
        
        subControllers = [alphabetVC, numberVC, accentsVC]
        viewPager.reload()
    }
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .black
        
        return button
    }
    
    func colorForIndicator(at index: Int) -> UIColor {
        return .tintColor
    }
    
    @IBAction func btnEditAction(_ sender: Any) {
//        if let alphabetVC = subControllers.first(where: { $0 is AlphabetViewController }) as? AlphabetViewController,
//                 let selectedIndexPaths = alphabetVC.alphabetTableView.indexPathsForSelectedRows,
//                 selectedIndexPaths.count == 1 {
//                  
//                  // Get the selected key and value for AlphabetViewController
//                  editSelectedCell(alphabetVC: alphabetVC, selectedIndexPaths: selectedIndexPaths)
//              }
//              // Check if NumbersViewController has exactly one selected cell
//              else if let numbersVC = subControllers.first(where: { $0 is NumbersViewController }) as? NumbersViewController,
//                      let selectedIndexPaths = numbersVC.numberTableView.indexPathsForSelectedRows,
//                      selectedIndexPaths.count == 1 {
//                  
//                  // Get the selected key and value for NumbersViewController
//                  editSelectedCell(numbersVC: numbersVC, selectedIndexPaths: selectedIndexPaths)
//              }
//              // Check if AccentViewController has exactly one selected cell
//              else if let accentVC = subControllers.first(where: { $0 is AccentsViewController }) as? AccentsViewController,
//                      let selectedIndexPaths = accentVC.accentTableView.indexPathsForSelectedRows,
//                      selectedIndexPaths.count == 1 {
//                  
//                  // Get the selected key and value for AccentViewController
//                  editSelectedCell(accentVC: accentVC, selectedIndexPaths: selectedIndexPaths)
//              } else {
//                  // Show an alert if no cell is selected or multiple cells are selected in Alphabet, Number, and Accent view controllers
//                  let alert = UIAlertController(title: "Error", message: "Please select a single cell to edit from either Alphabets, Numbers, or Accents.", preferredStyle: .alert)
//                  alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                  present(alert, animated: true, completion: nil)
//              }
        
        if let alphabetVC = subControllers.first(where: { $0 is AlphabetViewController }) as? AlphabetViewController,
               let alphabetTableView = alphabetVC.alphabetTableView,
               let selectedIndexPaths = alphabetTableView.indexPathsForSelectedRows,
               selectedIndexPaths.count == 1 {
                
                // Get the selected key and value for AlphabetViewController
                editSelectedCell(alphabetVC: alphabetVC, selectedIndexPaths: selectedIndexPaths)
                
            } else if let numbersVC = subControllers.first(where: { $0 is NumbersViewController }) as? NumbersViewController,
                      let numberTableView = numbersVC.numberTableView,
                      let selectedIndexPaths = numberTableView.indexPathsForSelectedRows,
                      selectedIndexPaths.count == 1 {
                
                // Get the selected key and value for NumbersViewController
                editSelectedCell(numbersVC: numbersVC, selectedIndexPaths: selectedIndexPaths)
                
            } else if let accentVC = subControllers.first(where: { $0 is AccentsViewController }) as? AccentsViewController,
                      let accentTableView = accentVC.accentTableView,
                      let selectedIndexPaths = accentTableView.indexPathsForSelectedRows,
                      selectedIndexPaths.count == 1 {
                
                // Get the selected key and value for AccentViewController
                editSelectedCell(accentVC: accentVC, selectedIndexPaths: selectedIndexPaths)
                
            } else {
                // Show an alert if no cell is selected or multiple cells are selected in Alphabet, Number, and Accent view controllers
                let alert = UIAlertController(title: "Error", message: "Please select a single cell to edit from either Alphabets, Numbers, or Accents.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
    }
    
    func editSelectedCell(alphabetVC: AlphabetViewController? = nil, numbersVC: NumbersViewController? = nil, accentVC: AccentsViewController? = nil, selectedIndexPaths: [IndexPath]) {
        let selectedIndexPath = selectedIndexPaths[0]
        var selectedKey: String
        var selectedValue: String
        
        if let alphabetVC = alphabetVC {
            selectedKey = alphabetVC.customKeys[selectedIndexPath.row].key
            selectedValue = alphabetVC.customKeys[selectedIndexPath.row].value
        } else if let numbersVC = numbersVC {
            selectedKey = numbersVC.customKeys[selectedIndexPath.row].key
            selectedValue = numbersVC.customKeys[selectedIndexPath.row].value
        } else if let accentVC = accentVC {
            selectedKey = accentVC.customKeys[selectedIndexPath.row].key
            selectedValue = accentVC.customKeys[selectedIndexPath.row].value
        } else {
            return
        }

        
        // Create a popup view
        let popupView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        popupView.backgroundColor = .gray
        popupView.layer.cornerRadius = 10

        // Title label
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 10, width: 260, height: 40))
        titleLabel.textAlignment = .center
        titleLabel.text = "TPlus Input Key: \(selectedKey)"
        popupView.addSubview(titleLabel)

        // Text view
        let textViewFrame = CGRect(x: 20, y: 70, width: 260, height: 50)
        let popupTextView = UITextView(frame: textViewFrame)
        popupTextView.layer.borderWidth = 1
        popupTextView.layer.borderColor = UIColor.lightGray.cgColor
        popupTextView.layer.cornerRadius = 5
        popupTextView.backgroundColor = .white
        popupTextView.font = UIFont.systemFont(ofSize: 15)
        popupTextView.text = selectedValue
        popupView.addSubview(popupTextView)

        // Save button
        let saveButton = UIButton(type: .system)
        saveButton.frame = CGRect(x: 20, y: 130, width: 120, height: 40)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        popupView.addSubview(saveButton)

        // Cancel button
        let cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 160, y: 130, width: 120, height: 40)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        popupView.addSubview(cancelButton)

        // Add popup view to the center of the screen
        popupView.center = view.center
        view.addSubview(popupView)
        // Proceed with the rest of the edit popup logic using selectedKey and selectedValue
        // This includes creating and configuring the popupView, titleLabel, popupTextView, saveButton, and cancelButton
        // The logic remains the same as in your original btnEditAction implementation
    }
    
    @objc func saveButtonTapped(_ sender: UIButton){
        guard let popupTextView = sender.superview?.subviews.first(where: { $0 is UITextView }) as? UITextView else {
            // Handle error condition here
            return
        }
        
        let newValue = popupTextView.text
        
        if let alphabetVC = subControllers.first(where: { $0 is AlphabetViewController }) as? AlphabetViewController {
            if let selectedIndexPaths = alphabetVC.alphabetTableView.indexPathsForSelectedRows, selectedIndexPaths.count == 1 {
                let selectedIndexPath = selectedIndexPaths[0]
                let selectedID = alphabetVC.customKeys[selectedIndexPath.row].id
                
                SQLiteDBHelper.shared.updateValueUsingID(forID: selectedID, newValue: newValue!)
                
                // Reload data to reflect the changes instantly
                alphabetVC.fetchDataAndReloadTable()
                editDeleteStackView.isHidden = true
                abKeyStackView.isHidden = false
                sender.superview?.removeFromSuperview()
                return
            }
        }
        
        if let numberVC = subControllers.first(where: { $0 is NumbersViewController }) as? NumbersViewController {
            if let selectedIndexPaths = numberVC.numberTableView.indexPathsForSelectedRows, selectedIndexPaths.count == 1 {
                let selectedIndexPath = selectedIndexPaths[0]
                let selectedID = numberVC.customKeys[selectedIndexPath.row].id
                
                // Update the value in the database
                SQLiteDBHelper.shared.updateValueUsingID(forID: selectedID, newValue: newValue!)
                
                // Reload data to reflect the changes instantly
                numberVC.fetchDataAndReloadTable()
                
                editDeleteStackView.isHidden = true
                abKeyStackView.isHidden = false
                sender.superview?.removeFromSuperview()
                return
            }
        }
        
        if let accentVC = subControllers.first(where: { $0 is AccentsViewController }) as? AccentsViewController {
            if let selectedIndexPaths = accentVC.accentTableView.indexPathsForSelectedRows, selectedIndexPaths.count == 1 {
                let selectedIndexPath = selectedIndexPaths[0]
                let selectedID = accentVC.customKeys[selectedIndexPath.row].id
                
                // Update the value in the database
                SQLiteDBHelper.shared.updateValueUsingID(forID: selectedID, newValue: newValue!)
                
                // Reload data to reflect the changes instantly
                accentVC.fetchDataAndReloadTable()
                
                editDeleteStackView.isHidden = true
                abKeyStackView.isHidden = false
                sender.superview?.removeFromSuperview()
                
                return
            }
        }
       
        
        // Handle error condition when no controller is found or no row is selected
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        // Handle cancel button action
        sender.superview?.removeFromSuperview()
    }
    
    @IBAction func btnDeleteAction(_ sender: Any) {
        print("delete clicked")
        // Create the alert controller
            let alert = UIAlertController(title: "Confirm Delete", message: "Do you want to delete selected items?", preferredStyle: .alert)

            // Add a "Cancel" action to let the user cancel the delete operation
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                print("Delete operation cancelled")
            }))

            // Add a "Delete" action to perform the deletion
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] action in
                // Perform the deletion here
                print("Item deleted")
                guard let alphabetVC = subControllers.first(where: { $0 is AlphabetViewController }) as? AlphabetViewController else {
                           return
                       }
                       alphabetVC.deleteSelectedCells()
            
            guard let numberVC = subControllers.first(where: { $0 is NumbersViewController }) as? NumbersViewController else {
                       return
                   }
            numberVC.deleteSelectedCells()
            
            guard let accentVC = subControllers.first(where: { $0 is AccentsViewController }) as? AccentsViewController else {
                       return
                   }
            accentVC.deleteSelectedCells()
            }))

            // Present the alert to the user
            if let presenter = sender as? UIViewController {
                presenter.present(alert, animated: true)
            } else if let button = sender as? UIView, let viewController = button.closestViewController() {
                viewController.present(alert, animated: true)
            } else {
                print("Could not find a view controller to present the alert")
            }

    }
    
    @IBAction func btnBackAction(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    
    func didSelectCell(selectedCount: Int) {
            lblSelectedRowCount.text = "\(selectedCount)"
            editDeleteStackView.isHidden = selectedCount == 0
        }
    
    func hideEditDeleteStackView() {
        editDeleteStackView.isHidden = true
    }
}

extension UIView {
    func closestViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while !(responder is UIViewController) && responder != nil {
            responder = responder?.next
        }
        return responder as? UIViewController
    }
}
