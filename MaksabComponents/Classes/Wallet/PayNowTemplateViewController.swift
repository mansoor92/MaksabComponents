//
//  PayNowTemplateViewController.swift
//  MaksabComponents
//
//  Created by Mansoor Ali on 22/03/2018.
//

import UIKit
import StylingBoilerPlate

open class PayNowTemplateViewController: UIViewController, NibLoadableView {

    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var amountAvailable: UILabel!
    
    @IBOutlet weak public var amountToPay: UILabel!
    @IBOutlet weak public var fieldAmount: UITextField!
    
    @IBOutlet weak public var tableView: UITableView!
    
    @IBOutlet weak public var btnSubmitt: PrimaryButton!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        customize()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = Bundle.localizedStringFor(key: "Pay Now")
    }
    
    func customize()  {
        self.view.backgroundColor = UIColor.appColor(color: .Light)
        titleLabel.text = Bundle.localizedStringFor(key: "You owe Maqsab")
        amountToPay.text = Bundle.localizedStringFor(key: "Amount to pay")
        fieldAmount.placeholder = Bundle.localizedStringFor(key: "wallet-withdrawl-amount")
        btnSubmitt.setTitle(Bundle.localizedStringFor(key: "Pay Now"), for: .normal)

    }
    
    public func config(amount: Double){
        let amountText = String(format: "%.2f", amount)
        amountAvailable.attributedText = String.boldAttributedString(boldComponent: "\(amountText)",
            otherComponent: Bundle.localizedStringFor(key: "constant-currency-SAR-only"),
            boldFont: UIFont.appFont(font: .RubikBold, pontSize: 32),
            otherfont: UIFont.appFont(font: .RubikRegular, pontSize: 12),
            textColor: UIColor.appColor(color: .Primary),
            boldTextColor: UIColor.appColor(color: .Primary),
            boldFirst: false)
        
    }
    
    public func getAmount() -> Double? {
        if let a = Double(fieldAmount.text!),a > 0{
           return a
        }else{
            let msg = Bundle.localizedStringFor(key:"wallet-withdrawl-invalid-amount")
			let title = Bundle.localizedStringFor(key:"Invalid Input")
			Alert.showMessage(viewController: self, title: title, msg: msg, dismissBtnTitle: Bundle.localizedStringFor(key: "Dismiss"))
            return nil
        }
    }
    
    @IBAction func actSubmitt(_ sender: PrimaryButton) {
        payNow()
    }
    
    open func payNow(){}

}
