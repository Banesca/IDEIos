
//
//  MotoristaBRTableViewCell.swift
//  AsRemis
//
//  Created by Luis Fernando Bustos Ramírez on 11/25/17.
//  Copyright © 2017 Apreciasoft. All rights reserved.
//

import UIKit


protocol MotoristaBRTableViewCellDelegate {
    func continueActionEmail(_ email : String,
                            password : String,
                            name : String,
                            lastname : String,
                            phone : String,
                            profileImg: UIImage,
                            rg : String,
                            cpf : String,
                            expiration : String,
                            cnhImg: UIImage)
    func photoSelected(_ name:String, byCamera: Bool)
    func dateSelectedInCell(_ dateS:String)
    func textChanged(_ currentTxt:String, withTxt:String)
}


class MotoristaBRTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var confirmPasswordLbl: UILabel!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var lastnameLbl: UILabel!
    @IBOutlet weak var lastnameTxt: UITextField!
    
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var phoneTxt: UITextField!
    
    @IBOutlet weak var imageLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profilePhotoBtn: UIButton!
    @IBOutlet weak var profileCameraBtn: UIButton!
    
    @IBOutlet weak var rgLbl: UILabel!
    @IBOutlet weak var rgTxt: UITextField!
    
    @IBOutlet weak var cpfLbl: UILabel!
    @IBOutlet weak var cpfTxt: UITextField!
    
    @IBOutlet weak var expirationLbl: UILabel!
    @IBOutlet weak var expirationTxt: UIButton!
    
    @IBOutlet weak var cnhLbl: UILabel!
    @IBOutlet weak var cnhImg: UIImageView!
    @IBOutlet weak var cnhPhotoBtn: UIButton!
    @IBOutlet weak var cnhCameraBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    
    var letContinue = false
    var delegate: MotoristaBRTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        numberLbl.layer.cornerRadius = numberLbl.frame.width/2
        numberLbl.clipsToBounds = true
        
        profileImg.layer.cornerRadius = profileImg.frame.width/2
        profileImg.layer.borderColor = UIColor.BlueIDE.cgColor
        profileImg.layer.borderWidth = 2
        profileImg.clipsToBounds = true
        
        cnhImg.layer.cornerRadius = profileImg.frame.width/2
        cnhImg.layer.borderColor = UIColor.BlueIDE.cgColor
        cnhImg.layer.borderWidth = 2
        cnhImg.clipsToBounds = true
        
        emailTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nameTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastnameTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        rgTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cpfTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Initialization code
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == emailTxt{
            delegate?.textChanged("dEmail", withTxt: emailTxt.text!)
        }
        if textField == passwordTxt{
            delegate?.textChanged("dPass", withTxt: passwordTxt.text!)
        }
        if textField == nameTxt{
            delegate?.textChanged("dName", withTxt: nameTxt.text!)
        }
        if textField == lastnameTxt{
            delegate?.textChanged("dLastname", withTxt: lastnameTxt.text!)
        }
        if textField == phoneTxt{
            delegate?.textChanged("dPhone", withTxt: phoneTxt.text!)
        }
        if textField == rgTxt{
            delegate?.textChanged("dRG", withTxt: rgTxt.text!)
        }
        if textField == cpfTxt{
            delegate?.textChanged("dCPF", withTxt: cpfTxt.text!)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func imageSelectedAction(_ sender: UIButton) {
        if sender == profilePhotoBtn{
            delegate?.photoSelected("dProfileImg", byCamera: false)
        }
        if sender == profileCameraBtn{
            delegate?.photoSelected("dProfileImg", byCamera: true)
        }
        if sender == cnhPhotoBtn{
            delegate?.photoSelected("dCNHImg", byCamera: false)
        }
        if sender == cnhCameraBtn{
            delegate?.photoSelected("dCNHImg", byCamera: true)
        }
    }
    
    @IBAction func dateSelectedAction(_ sender: UIButton) {
        delegate?.dateSelectedInCell("dExpiration")
    }
    
    @IBAction func continueAction(_ sender: Any) {
        letContinue = true
        if let emptyImage = UIImage(named: "nopic") {
            if emptyImage.isEqual(profileImg.image){
                letContinue = false
                showError("Selecione uma imagem válida")
                return
            }
            if emptyImage.isEqual(cnhImg.image){
                letContinue = false
                showError("Selecione uma imagem válida")
                return
            }
        }
        
        delegate?.continueActionEmail(emailTxt.text!,
                                      password: passwordTxt.text!,
                                      name: nameTxt.text!,
                                      lastname: lastnameTxt.text!,
                                      phone: phoneTxt.text!,
                                      profileImg: profileImg.image!,
                                      rg: rgTxt.text!,
                                      cpf: cpfTxt.text!,
                                      expiration: (expirationTxt.titleLabel?.text)!,
                                      cnhImg: cnhImg.image!)
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
