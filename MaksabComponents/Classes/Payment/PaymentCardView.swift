//
//  AddPaymentMethodView.swift
//  Pods
//
//  Created by Incubasys on 15/08/2017.
//
//

import UIKit
import StylingBoilerPlate

public struct PaymentCardInfo{
    public var title: String
    public var cardNo: String
    public var expiryDate: String
    public var cvv: String
    public var cardHolderName: String
    public var expiryYear: Int = 0
    public var expiryMonth: Int = 0
    
    public init(title: String, cardNo: String, expiryDate: String, cvv: String, cardHolderName: String) {
        self.title = title
        self.cardNo = cardNo
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.cardHolderName = cardHolderName
    }
    
    public func encodeToJSON() -> [String:Any] {
        var dictionary = [String:Any]()
        dictionary["name"] = cardHolderName
        dictionary["number"] = cardNo
        dictionary["exp_month"] = expiryMonth
        dictionary["exp_year"] = expiryYear
        dictionary["cvc"] = cvv
        return dictionary
    }
}

public class PaymentCardView: UIView, CustomView, NibLoadableView, UITextFieldDelegate {

    @IBOutlet weak var staticLabelCardNo: UILabel!
    @IBOutlet weak var staticLabelExpiryDate: UILabel!
    @IBOutlet weak var staticLabelCvv: UILabel!
    @IBOutlet weak var staticLabelCardHolderName: UILabel!
    
   
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var fieldTitle: UITextField!
    @IBOutlet weak var fieldCardNo: UITextField!
    @IBOutlet weak var fieldExpiryDate: UITextField!
    @IBOutlet weak var fieldCvv: UITextField!
    @IBOutlet weak var fieldCardHolderName: UITextField!
  
    let bundle = Bundle(for: PaymentCardView.classForCoder())
    var view: UIView!
    public static let height: CGFloat = 277
//        188+16
    
    static public func createInstance(x: CGFloat, y: CGFloat = 0, width: CGFloat) -> PaymentCardView{
        let inst = PaymentCardView(frame: CGRect(x: x, y: y, width: width, height: PaymentCardView.height))
        return inst
    }
    
    override required public init(frame: CGRect) {
        super.init(frame: frame)
        let bundle = Bundle(for: type(of: self))
        view = self.commonInit(bundle: bundle)
        configView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let bundle = Bundle(for: type(of: self))
        view = self.commonInit(bundle: bundle)
        configView()
    }
    

    func configView()  {
        backgroundColor = UIColor.appColor(color: .Dark)
        let color = UIColor(netHex: 0x777777)
        
        staticLabelCardNo.text = "CARD NUMBER"
        staticLabelCardNo.textColor = color
        staticLabelExpiryDate.text = "EXPIRATION DATE"
        staticLabelExpiryDate.textColor = color
        staticLabelCvv.text = "CVV"
        staticLabelCvv.textColor = color
        staticLabelCardHolderName.text = "CARDHOLDER NAME"
        staticLabelCardHolderName.textColor = color
        
        fieldTitle.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSFontAttributeName: UIFont.appFont(font: .RubikMedium, pontSize: 17)])
        fieldTitle.font = UIFont.appFont(font: .RubikMedium, pontSize: 17)
        fieldCardNo.placeholder = "0000 0000 0000 0000"
        fieldExpiryDate.placeholder = "MM/YY"
        fieldCvv.placeholder = "1234"
        fieldCardHolderName.placeholder = "ABC"
        
        fieldCardNo.delegate = self
        fieldExpiryDate.delegate = self
        fieldCvv.delegate = self
        fieldCardHolderName.delegate = self
    }
    
    public func getCardInfo(completion:@escaping((_ err:ResponseError?,_ cardInfo: PaymentCardInfo?)->Void)){
        
        let err = ResponseError()
        err.errorTitle = "Invalid Input"
        err.reason = ""
        
        //        if deliveryItems.count == 1 && deliveryItems[0].itemName.isEmpty && deliveryItems[0].quantity < 0{
        //            err.reason = "Please enter valid name and quantity."
        //
        //        }
        if fieldTitle.text!.isEmpty{
            err.reason = "Title is required"
        }else if fieldCardNo.text!.characters.count != 19{
            err.reason = "Card no must have 16 digits"
        }else if fieldExpiryDate.text!.characters.count != 5{
            err.reason = "Invalid expiry date"
        }else if fieldCvv.text!.characters.count < 3 {
            err.reason = "Invalid CVV"
        }else if fieldCardHolderName.text!.isEmpty{
            err.reason = "Card Holder name is required"
        }
        
        var cardInfo = PaymentCardInfo(title: fieldTitle.text!, cardNo: fieldCardNo.text!, expiryDate: fieldExpiryDate.text!, cvv: fieldCvv.text!, cardHolderName: fieldCardHolderName.text!)
        
        let expDate = fieldExpiryDate.text!
        let yearStr = expDate.substring(from: expDate.index(expDate.startIndex, offsetBy: 3))
        let monthStr = expDate.substring(to: expDate.index(expDate.startIndex, offsetBy: 2))
        if let year = Int("20\(yearStr)"){
            cardInfo.expiryYear = year
        }else{
            err.reason = "Invalid expiry Date"
        }
        if let month = Int(monthStr),month <= 12, month >= 1 {
            cardInfo.expiryMonth = month
        }else{
            err.reason = "Invalid expiry Date"
        }
        
        if err.reason.isEmpty{
            cardInfo.cardNo = cardInfo.cardNo.replacingOccurrences(of: " ", with: "")
            completion(nil, cardInfo)
        }else{
            completion(err, nil)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == fieldCardNo{
            return handleCardInput(textField: textField, shouldChangeCharactersInRange: range, replacementString: string)
        }else if textField == fieldCvv{
            return handleCvvInput(textField: textField, shouldChangeCharactersInRange: range, replacementString: string)
        }else if textField == fieldExpiryDate{
            return handleDateInput(textField: textField, shouldChangeCharactersInRange: range, replacementString: string)
        }
        return true
    }
    
    func handleCardInput(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
        let replaced = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        setCardImage(string: replaced)
        if (textField.text!.characters.count == 4) || (textField.text!.characters.count == 9 ) || (textField.text!.characters.count == 14) {
            //Handle backspace being pressed
            if !(string == "") {
                // append the text
                textField.text = textField.text! + " "
            }
        }
        return !(textField.text!.characters.count > 18 && (string.characters.count ) > range.length)
    }
    
    func setCardImage(string: String)  {
        let bh = BundleHelper(resourceName: Constants.resourceName)
        
//        if string.count == 1 , let digit = Int(string), digit == 4{
//
//        }else{
//            cardImg.image = bh.getImageFromMaksabComponent(name: "creditcard", _class: PaymentCardView.self)
//        }
        
        guard string.characters.count <= 2 , let digit = Int(string) else {
            return
        }
        
        if digit == 4 || (digit >= 40 && digit <= 49){
            //first digit 4 visa
            cardImg.image = bh.getImageFromMaksabComponent(name: "visacard", _class: PaymentCardView.self)
        }else if digit >= 51 && digit <= 55{
            //first two digits 5x  x can be 1-5 matercard
            cardImg.image = bh.getImageFromMaksabComponent(name: "mastercard", _class: PaymentCardView.self)
        }else if digit == 34 || digit == 37{
            //first two digits 34  or 37 american express
            cardImg.image = bh.getImageFromMaksabComponent(name: "americanexpersscard", _class: PaymentCardView.self)
        }else{
            cardImg.image = nil
        }
    }
    
    func handleDateInput(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // check the chars length dd -->2 at the same time calculate the dd-MM --> 5
        //        || (textField.text!.characters.count == 5)
        if (textField.text!.characters.count == 2)  {
            //Handle backspace being pressed
            if !(string == "") {
                // append the text
                textField.text = textField.text! + "/"
            }
        }
        // check the condition not exceed 9 chars
        return !(textField.text!.characters.count > 4 && (string.characters.count ) > range.length)
    }
    
    func handleCvvInput(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.characters.count + string.characters.count - range.length
//        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
//        if newString.characters.count == 5 {
//            textField.rightView = UIImageView(image: #imageLiteral(resourceName: "smallGreenTick"))
//        }else{
//            textField.rightView = UIImageView(image: nil)
//        }
        return newLength <= 4
    }
    

}
