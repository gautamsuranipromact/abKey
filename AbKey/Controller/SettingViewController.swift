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
            lblAbKey.text = Constants.PremiumUserHeading
        }else{
            lblAbKey.text = Constants.LiteUserHeading
        }
    }
    
    func viewPagerProperties(){
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self
        
        let alphabetVC = UIStoryboard(name: Constants.MainAppStoryboardIdentifier, bundle:
                                        nil).instantiateViewController(withIdentifier: Constants.AlphabetVCIdentifier) as! AlphabetViewController
        alphabetVC.delegate = self
        
        let numberVC = UIStoryboard(name: Constants.MainAppStoryboardIdentifier, bundle:
                                        nil).instantiateViewController(withIdentifier: Constants.NumberVCIdentifier) as! NumbersViewController
        numberVC.delegate = self
        
        let accentsVC = UIStoryboard(name: Constants.MainAppStoryboardIdentifier, bundle:
                                        nil).instantiateViewController(withIdentifier: Constants.AccentVCIdentifier) as! AccentsViewController
        accentsVC.delegate = self
        
        alphabetVC.title = Constants.AlphabetVCTitle
        numberVC.title = Constants.NumberVCTitle
        accentsVC.title = Constants.AccentVCTitle
        
        subControllers = [alphabetVC, numberVC, accentsVC]
        viewPager.reload()
    }
    
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    // Deselect any selected rows in all controllers before switching to the new one
    func controller(at index: Int) -> UIViewController {
        if let alphabetVC = subControllers.first(where: { $0 is AlphabetViewController }) as? AlphabetViewController {
            alphabetVC.alphabetTableView?.indexPathsForSelectedRows?.forEach { indexPath in
                alphabetVC.alphabetTableView?.deselectRow(at: indexPath, animated: false)
            }
        }

        if let numberVC = subControllers.first(where: { $0 is NumbersViewController }) as? NumbersViewController {
            numberVC.numberTableView?.indexPathsForSelectedRows?.forEach { indexPath in
                numberVC.numberTableView?.deselectRow(at: indexPath, animated: false)
            }
        }

        if let accentVC = subControllers.first(where: { $0 is AccentsViewController }) as? AccentsViewController {
            accentVC.accentTableView?.indexPathsForSelectedRows?.forEach { indexPath in
                accentVC.accentTableView?.deselectRow(at: indexPath, animated: false)
            }
        }

        // Return the appropriate view controller for the selected tab.
        return subControllers[index]
    }

    // Design for pager button tabs
    func button(at index: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.IpadScreen ? 24 : 16)
        button.backgroundColor = .black
        
        return button
    }
    
    // Current tab indicator
    func colorForIndicator(at index: Int) -> UIColor {
        return .tintColor
    }
    
    // Height of current tab indicator
    func heightForIndicator() -> CGFloat {
        return Constants.IpadScreen ? 4.0 : 2.0
    }
    
    // Edit a particular entry
    @IBAction func btnEditAction(_ sender: Any) {
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
            let alert = UIAlertController(title: "Error", message: Constants.MultipleRowEditErrorMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    // Delete a particular entry
    @IBAction func btnDeleteAction(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm Delete", message: Constants.ConfirmDeleteMsg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a "Delete" action to perform the deletion
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] action in
            // Deselect rows in all controllers before deletion
            if let alphabetVC = subControllers.first(where: { $0 is AlphabetViewController }) as? AlphabetViewController {
                alphabetVC.alphabetTableView?.indexPathsForSelectedRows?.forEach { indexPath in
                    alphabetVC.alphabetTableView?.deselectRow(at: indexPath, animated: false)
                }
            }
            
            if let numberVC = subControllers.first(where: { $0 is NumbersViewController }) as? NumbersViewController {
                numberVC.numberTableView?.indexPathsForSelectedRows?.forEach { indexPath in
                    numberVC.numberTableView?.deselectRow(at: indexPath, animated: false)
                }
            }
            
            if let accentVC = subControllers.first(where: { $0 is AccentsViewController }) as? AccentsViewController {
                accentVC.accentTableView?.indexPathsForSelectedRows?.forEach { indexPath in
                    accentVC.accentTableView?.deselectRow(at: indexPath, animated: false)
                }
            }
            
            // Now delete selected items from the current visible tab
            if let currentVC = subControllers[viewPager.currentIndex!] as? AlphabetViewController {
                currentVC.deleteSelectedCells()
            } else if let currentVC = subControllers[viewPager.currentIndex!] as? NumbersViewController {
                currentVC.deleteSelectedCells()
            } else if let currentVC = subControllers[viewPager.currentIndex!] as? AccentsViewController {
                currentVC.deleteSelectedCells()
            }
        }))
        
        // Present the alert to the user
        if let presenter = sender as? UIViewController {
            presenter.present(alert, animated: true)
        } else if let button = sender as? UIView, let viewController = button.closestViewController() {
            viewController.present(alert, animated: true)
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
}

//MARK: Utility Functions
extension SettingViewController {
    // Edit a particular entry
    func editSelectedCell(alphabetVC: AlphabetViewController? = nil, numbersVC: NumbersViewController? = nil, accentVC: AccentsViewController? = nil, selectedIndexPaths: [IndexPath]) {
        let selectedIndexPath = selectedIndexPaths[selectedIndexPaths.count - 1]
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
        
        // Scale UI based on iPad screens
        let scaleFactor: CGFloat = Constants.IpadScreen ? 1.5 : 1.0  // Scale everything up by 1.5x on iPad, leave as 1.0 on iPhone
        
        // Create the popup view (no design changes, just scaling)
        let popupView = UIView(frame: CGRect(x: 0, y: 0, width: 300 * scaleFactor, height: 200 * scaleFactor))
        popupView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        popupView.layer.cornerRadius = 15 * scaleFactor
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.3
        popupView.layer.shadowOffset = CGSize(width: 0, height: 5 * scaleFactor)
        popupView.layer.shadowRadius = 10 * scaleFactor
        
        // Title label (scaling size and position)
        let titleLabel = UILabel(frame: CGRect(x: 20 * scaleFactor, y: 10 * scaleFactor, width: 260 * scaleFactor, height: 40 * scaleFactor))
        titleLabel.textAlignment = .center
        titleLabel.text = "TPlus Input Key: \(selectedKey)"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18 * scaleFactor)
        titleLabel.textColor = UIColor.darkGray
        popupView.addSubview(titleLabel)
        
        // Text view (scaling size and position)
        let popupTextView = UITextView(frame: CGRect(x: 20 * scaleFactor, y: 70 * scaleFactor, width: 260 * scaleFactor, height: 50 * scaleFactor))
        popupTextView.layer.borderWidth = 1 * scaleFactor
        popupTextView.layer.borderColor = UIColor.lightGray.cgColor
        popupTextView.layer.cornerRadius = 8 * scaleFactor
        popupTextView.backgroundColor = UIColor(white: 1, alpha: 1)
        popupTextView.font = UIFont.systemFont(ofSize: 15 * scaleFactor)
        popupTextView.text = selectedValue
        popupView.addSubview(popupTextView)
        
        // Cancel button (scaling size and position, and font size)
        let cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 20 * scaleFactor, y: 130 * scaleFactor, width: 120 * scaleFactor, height: 40 * scaleFactor)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17 * scaleFactor)  // Scaled font size
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor(red: 220/255, green: 100/255, blue: 100/255, alpha: 1.0)
        cancelButton.layer.cornerRadius = 10 * scaleFactor
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        popupView.addSubview(cancelButton)
        
        // Save button (scaling size and position, and font size)
        let saveButton = UIButton(type: .system)
        saveButton.frame = CGRect(x: 160 * scaleFactor, y: 130 * scaleFactor, width: 120 * scaleFactor, height: 40 * scaleFactor)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17 * scaleFactor)  // Scaled font size
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(red: 85/255, green: 143/255, blue: 185/255, alpha: 1.0)
        saveButton.layer.cornerRadius = 10 * scaleFactor
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        popupView.addSubview(saveButton)
        
        // Add the popup view to the center of the screen
        popupView.center = view.center
        view.addSubview(popupView)
    }
    
    // Save the edited row to the database
    @objc func saveButtonTapped(_ sender: UIButton){
        guard let popupTextView = sender.superview?.subviews.first(where: { $0 is UITextView }) as? UITextView else {
            return
        }
        
        let newValue = popupTextView.text
        
        if let alphabetVC = subControllers.first(where: { $0 is AlphabetViewController }) as? AlphabetViewController {
            if let selectedIndexPaths = alphabetVC.alphabetTableView.indexPathsForSelectedRows, selectedIndexPaths.count == 1 {
                let selectedIndexPath = selectedIndexPaths[0]
                let selectedID = alphabetVC.customKeys[selectedIndexPath.row].id
                
                SQLiteDBHelper.shared.updateValueUsingID(forID: selectedID, newValue: newValue!)
                
                editDeleteStackView.isHidden = true
                abKeyStackView.isHidden = false
                sender.superview?.removeFromSuperview()
                self.viewDidLoad()
            }
        }
        
        if let numberVC = subControllers.first(where: { $0 is NumbersViewController }) as? NumbersViewController {
            if let selectedIndexPaths = numberVC.numberTableView?.indexPathsForSelectedRows, selectedIndexPaths.count == 1 {
                let selectedIndexPath = selectedIndexPaths[0]
                let selectedID = numberVC.customKeys[selectedIndexPath.row].id
                
                // Update the value in the database
                SQLiteDBHelper.shared.updateValueUsingID(forID: selectedID, newValue: newValue!)
                
                editDeleteStackView.isHidden = true
                abKeyStackView.isHidden = false
                sender.superview?.removeFromSuperview()
                self.viewDidLoad()
            }
        }
        
        if let accentVC = subControllers.first(where: { $0 is AccentsViewController }) as? AccentsViewController {
            if let selectedIndexPaths = accentVC.accentTableView?.indexPathsForSelectedRows, selectedIndexPaths.count == 1 {
                let selectedIndexPath = selectedIndexPaths[0]
                let selectedID = accentVC.customKeys[selectedIndexPath.row].id
                
                // Update the value in the database
                SQLiteDBHelper.shared.updateValueUsingID(forID: selectedID, newValue: newValue!)
                
                editDeleteStackView.isHidden = true
                abKeyStackView.isHidden = false
                sender.superview?.removeFromSuperview()
                self.viewDidLoad()
            }
        }
    }
    
    // Cancel Editing
    @objc func cancelButtonTapped(_ sender: UIButton) {
        sender.superview?.removeFromSuperview()
    }
    
    func didSelectCell(selectedCount: Int) {
        lblSelectedRowCount.text = "\(selectedCount)"
        editDeleteStackView.isHidden = selectedCount == 0
    }
    
    func hideEditDeleteStackView() {
        editDeleteStackView.isHidden = true
    }
}

//MARK: Finds and returns the closest parent view controller of the view, if any
extension UIView {
    func closestViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while !(responder is UIViewController) && responder != nil {
            responder = responder?.next
        }
        return responder as? UIViewController
    }
}
