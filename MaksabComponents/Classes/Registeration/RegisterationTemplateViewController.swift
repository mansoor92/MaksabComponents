//
//  RegisterationTemplateViewController.swift
//  Pods
//
//  Created by Incubasys on 19/07/2017.
//
//

import UIKit
import StylingBoilerPlate

public enum RegisterationViewType: Int {
    case PhoneNumber = 0
    case VerificationCode = 1
    case NameAndEmail = 2
    case Password = 3
    case PasswordAndConfirmPassword = 4
    case InviteCode = 5
    
    public func next() -> RegisterationViewType? {
        if self == .InviteCode{
            return nil
        }
        return RegisterationViewType(rawValue: self.rawValue+1)
    }
}

public protocol RegisterationTemplateViewControllerDataSource{
    func viewType() -> RegisterationViewType
}

@objc public protocol RegisterationTemplateViewControllerDelegate{
    func actionNext(sender: UIButton)
    @objc optional func actionPrimary(sender: UIButton)
    @objc optional func actionGoogleLogin(sender: UIButton)
    @objc optional func actionFacbookLogin(sender: UIButton)
    @objc optional func actionTwitterLogin(sender: UIButton)
    @objc optional func actionTooltipBottom(sender: UIButton)
    @objc optional func actionTooltipTop(sender: UIButton)
}

open class RegisterationTemplateViewController: UIViewController {
    
//    override open func loadView() {
//        let name = "RegisterationTemplateViewController"
//        let bundle = Bundle(for: type(of: self))
//        guard let view = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
//            fatalError("Nib not found.")
//        }
//        self.view = view
//    }
//    
    public var dataSource: RegisterationTemplateViewControllerDataSource!
    public var delegate: RegisterationTemplateViewControllerDelegate?
    
    @IBOutlet weak var firstFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackViewReqHeight: NSLayoutConstraint!
    @IBOutlet weak var socialLoginsView: UIView!
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var logoView: UIView!
    
    @IBOutlet weak public var logo: UIImageView!
    
    @IBOutlet weak var subtitleHeight: NSLayoutConstraint!
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var actionButtonHeight: NSLayoutConstraint!
    @IBOutlet weak public var labelTitle: HeadlineLabel!
    @IBOutlet weak public var labelSubtitle: CaptionLabel!
    @IBOutlet weak var btnTooltip: UIButton!
    @IBOutlet weak public var fieldFirst: BottomBorderTextField!
    @IBOutlet weak public var fieldSecond: BottomBorderTextField!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnAction: UIButton!
    
    @IBOutlet weak var btnFacbook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnBottomTooltip: UIButton!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let type = dataSource?.viewType() else {
            fatalError("Missing registeration view controller datasource method viewType")
        }
       
        config(type: type)
        
        addTargets()
        
    }
    
    func config(type: RegisterationViewType)  {
        if type != .NameAndEmail && type != .PasswordAndConfirmPassword{
            removeFirstField()
        }
        if type != .PhoneNumber{
            removeSocialLoginsView()
        }else{
            self.socialLoginsView.isHidden = false
            removeTitleView()
            removeActionButton()
        }
        if type != .InviteCode{
            removeSubtitle()
        }
        if type == .VerificationCode{
            btnTooltip.isHidden = false
        }
        self.logoView.isHidden = false
        self.fieldsView.isHidden = false

    }
    
    func addTargets()  {
        btnAction.addTarget(self, action: #selector(actPrimary(sender:)), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(actNext(sender:)), for: .touchUpInside)
        btnGoogle.addTarget(self, action: #selector(actGoogleLogin(sender:)), for: .touchUpInside)
        btnFacbook.addTarget(self, action: #selector(actFacebookLogin(sender:)), for: .touchUpInside)
        btnTwitter.addTarget(self, action: #selector(actTwitterLogin(sender:)), for: .touchUpInside)
        btnTooltip.addTarget(self, action: #selector(actTooltipTop(sender:)), for: .touchUpInside)
        btnBottomTooltip.addTarget(self, action: #selector(actBottomTooltip(sender:)), for: .touchUpInside)
    }
    
    func removeFirstField()  {
        firstFieldHeight.constant = 0
        stackViewHeight.constant = 76-30
        stackViewReqHeight.constant = 64-30
        fieldFirst.isHidden = true
    }
    
    func removeTitleView()  {
        titleViewHeight.constant = 0
    }
    
    func removeSubtitle()  {
        subtitleHeight.constant = 0
    }
    
    func removeActionButton()  {
        actionButtonHeight.constant = 0
    }
    
    func removeSocialLoginsView()  {
        self.socialLoginsView.removeFromSuperview()
//        let bottom = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: self.fieldsView, attribute: .bottom, multiplier: 1, constant: 44)
        let centerY = NSLayoutConstraint(item: fieldsView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addConstraint(centerY)
//        self.view.addConstraint(bottom)
    }
    
    
    public func configPrimaryButton(btnTitle:String,image:UIImage?){
        self.btnAction.setImage(image, for: .normal)
        self.btnAction.setTitle(btnTitle, for: .normal)
    }
    
    //MARK:- Actions
    func actNext(sender: UIButton)  {
        delegate?.actionNext(sender: sender)
    }
    
    func actPrimary(sender: UIButton)  {
        delegate?.actionPrimary?(sender: sender)
    }
    
    func actGoogleLogin(sender: UIButton)  {
        delegate?.actionGoogleLogin?(sender: sender)
    }
    
    func actFacebookLogin(sender: UIButton)  {
        delegate?.actionFacbookLogin?(sender: sender)
    }
    
    func actTwitterLogin(sender: UIButton)  {
        delegate?.actionTwitterLogin?(sender: sender)
    }
    
    func actBottomTooltip(sender: UIButton)  {
        delegate?.actionTooltipBottom?(sender: sender)
    }
    
    func actTooltipTop(sender: UIButton)  {
        delegate?.actionTooltipTop?(sender: sender)
    }
//    open static  func createController(_for:RegisterationViewType) -> RegisterationTemplateViewController{
//        
//        var vc: RegisterationTemplateViewController!
//        
//        let bundle = Bundle(for: self.classForCoder())
//        let name = "RegisterationTemplateViewController"
//        vc = RegisterationTemplateViewController(nibName: name, bundle: bundle)
//        
//        return vc
//    }
    
}
