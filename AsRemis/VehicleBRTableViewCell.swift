//
//  VehicleBRTableViewCell.swift
//  AsRemis
//
//  Created by Luis Fernando Bustos Ramírez on 11/26/17.
//  Copyright © 2017 Apreciasoft. All rights reserved.
//

import UIKit

protocol VehicleBRTableViewCellDelegate {
    func continueActionType(_ type : String,
                            brand : String,
                            model : String,
                            cor : String,
                            placa : String,
                            assure : String,
                            policy : String,
                            expiration : String,
                            plicyImg: UIImage,
                            doc : String,
                            docImg: UIImage,
                            resume : String,
                            confirm: Bool,
                            acceptEmail: Bool)
    func actionSelected(_ index:Int)
    func photoSelected(_ name:String, byCamera: Bool)
    func dateSelectedInCell(_ dateS:String)
    func textChanged(_ currentTxt:String, withTxt:String)
}

class VehicleBRTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var typeSelectorBtn: UIButton!
    @IBOutlet weak var brandSelectorBtn: UIButton!
    @IBOutlet weak var modelSelectorBtn: UIButton!
    
    @IBOutlet weak var corTxt: UITextField!
    @IBOutlet weak var placaTxt: UITextField!
    @IBOutlet weak var assureTxt: UITextField!
    @IBOutlet weak var policyTxt: UITextField!
    @IBOutlet weak var expirationBtn: UIButton!
    
    @IBOutlet weak var plicyImgLbl: UILabel!
    @IBOutlet weak var plicyImg: UIImageView!
    @IBOutlet weak var plicyPhotoBtn: UIButton!
    @IBOutlet weak var plicyCameraBtn: UIButton!
    
    @IBOutlet weak var docLbl: UILabel!
    @IBOutlet weak var docBtn: UIButton!
    
    @IBOutlet weak var docImgLbl: UILabel!
    @IBOutlet weak var docImg: UIImageView!
    @IBOutlet weak var docPhotoBtn: UIButton!
    @IBOutlet weak var docCameraBtn: UIButton!
    
    @IBOutlet weak var detailsTxt: UITextView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var acceptMailBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    var confirmValue = false
    var emailConfim = false
    
    var letContinue = false
    
    var delegate: VehicleBRTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        corTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        placaTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        assureTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        policyTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        numberLbl.layer.cornerRadius = numberLbl.frame.width/2
        numberLbl.clipsToBounds = true
        
        plicyImg.layer.cornerRadius = plicyImg.frame.width/2
        plicyImg.layer.borderColor = UIColor.BlueIDE.cgColor
        plicyImg.layer.borderWidth = 2
        plicyImg.clipsToBounds = true
        
        docImg.layer.cornerRadius = docImg.frame.width/2
        docImg.layer.borderColor = UIColor.BlueIDE.cgColor
        docImg.layer.borderWidth = 2
        docImg.clipsToBounds = true
        
        confirmBtn.layer.borderColor = UIColor.lightGray.cgColor
        confirmBtn.layer.borderWidth = 1
        confirmBtn.clipsToBounds = true
        if confirmValue{
            confirmBtn.backgroundColor = UIColor.cyan
            confirmBtn.setImage(UIImage.init(named: "ic_check_white_48pt"), for: .normal)
        }else{
            confirmBtn.backgroundColor = .white
            confirmBtn.setImage(nil, for: .normal)
        }
        
        acceptMailBtn.layer.borderColor = UIColor.lightGray.cgColor
        acceptMailBtn.layer.borderWidth = 1
        acceptMailBtn.clipsToBounds = true
        if emailConfim{
            acceptMailBtn.backgroundColor = UIColor.cyan
            acceptMailBtn.setImage(UIImage.init(named: "ic_check_white_48pt"), for: .normal)
        }else{
            acceptMailBtn.backgroundColor = .white
            acceptMailBtn.setImage(nil, for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == corTxt{
            delegate?.textChanged("vCor", withTxt: corTxt.text!)
        }
        if textField == placaTxt{
            delegate?.textChanged("vPlaca", withTxt: placaTxt.text!)
        }
        if textField == assureTxt{
            delegate?.textChanged("vAssure", withTxt: assureTxt.text!)
        }
        if textField == policyTxt{
            delegate?.textChanged("vPolicy", withTxt: policyTxt.text!)
        }
    }
    
    @IBAction func dateSelectedAction(_ sender: UIButton) {
        if sender == expirationBtn {
            delegate?.dateSelectedInCell("vExpiration")
        } else {
            delegate?.dateSelectedInCell("vDoc")
        }
    }
    
    @IBAction func imageSelectedAction(_ sender: UIButton) {
        if sender == plicyPhotoBtn{
            delegate?.photoSelected("vPolicyImg", byCamera: false)
        }
        if sender == plicyCameraBtn{
            delegate?.photoSelected("vPolicyImg", byCamera: true)
        }
        if sender == docPhotoBtn{
            delegate?.photoSelected("vDocImg", byCamera: false)
        }
        if sender == docCameraBtn{
            delegate?.photoSelected("vDocImg", byCamera: true)
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if confirmValue{
            confirmBtn.backgroundColor = .white
            confirmBtn.setImage(nil, for: .normal)
            confirmValue = false
        }else{
            confirmBtn.backgroundColor = UIColor.cyan
            confirmBtn.setImage(UIImage.init(named: "ic_check_white_48pt"), for: .normal)
            confirmValue = true
        }
    }
    
    @IBAction func acceptMailAction(_ sender: Any) {
        if emailConfim{
            acceptMailBtn.backgroundColor = .white
            acceptMailBtn.setImage(nil, for: .normal)
            emailConfim = false
        }else{
            acceptMailBtn.backgroundColor = UIColor.cyan
            acceptMailBtn.setImage(UIImage.init(named: "ic_check_white_48pt"), for: .normal)
            emailConfim = true
        }
    }
    
    @IBAction func optionSelectedAction(_ sender: UIButton) {
        if sender == typeSelectorBtn{
            delegate?.actionSelected(1)
        }
        if sender == brandSelectorBtn{
            delegate?.actionSelected(2)
        }
        if sender == modelSelectorBtn{
            delegate?.actionSelected(3)
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        letContinue = true
        if let emptyImage = UIImage(named: "nopic") {
            if emptyImage.isEqual(docImg.image){
                letContinue = false
                showError("Selecione uma imagem válida")
                return
                
            }
            if emptyImage.isEqual(plicyImg.image){
                letContinue = false
                showError("Selecione uma imagem válida")
                return
            }
        }
        delegate?.continueActionType((typeSelectorBtn.titleLabel?.text)!,
                                     brand: (brandSelectorBtn.titleLabel?.text)!,
                                     model: (modelSelectorBtn.titleLabel?.text)!,
                                     cor: corTxt.text!,
                                     placa: placaTxt.text!,
                                     assure: assureTxt.text!,
                                     policy: policyTxt.text!,
                                     expiration: (expirationBtn.titleLabel?.text)!,
                                     plicyImg: plicyImg.image!,
                                     doc: (docBtn.titleLabel?.text)!,
                                     docImg: docImg.image!,
                                     resume: detailsTxt.text!,
                                     confirm: confirmValue,
                                     acceptEmail: emailConfim)
    }
    
    func showError(_ message:String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Aceitar", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        
        let window = UIWindow.init(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController.init()
        window.windowLevel = UIWindowLevelAlert+1
        window.makeKeyAndVisible()
        window.rootViewController?.present(alertController, animated: true, completion: nil)
        
        
    }
}
