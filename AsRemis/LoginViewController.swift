//
//  LoginViewController.swift
//  AsRemis
//
//  Created by Luis F. Bustos Ramirez on 27/09/17.
//  Copyright © 2017 Apreciasoft. All rights reserved.
//

import UIKit
import CoreData
import NVActivityIndicatorView

class LoginViewController: UIViewController, NVActivityIndicatorViewable{

    @IBOutlet weak var asRemisImg: UIImageView!
    @IBOutlet weak var mailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "IDE!"
        asRemisImg.layer.cornerRadius = asRemisImg.frame.width/2
        asRemisImg.clipsToBounds = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor.BlueIDEHeader
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.hideKeyboardWhenTappedAround()
        passwordTxtField.delegate = self
        mailTxtField.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let user = UserEntity.init(userName: mailTxtField.text!, userPass: passwordTxtField.text!, idTypeAuth: 2)
        let http = Http.init()
        startAnimating(CGSize.init(width: 50, height: 50), message: "Espere um momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: .GrayAlpha, textColor: .white)
        startAnimating(CGSize.init(width: 50, height: 50), message: "Espere um momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: .GrayAlpha, textColor: .white)
        http.checkVersion(SingletonsObject.sharedInstance.appCurrentVersion as String, completion: { (isValidVersion) -> Void in
            self.stopAnimating()
            if isValidVersion{
                http.loginUser(user, completion: { (userJson) -> Void in
                    if userJson != nil && userJson?.user?.emailUser != ""{
                        self.handleResponse(userJson!)
                    }else{
                        let alertController = UIAlertController(title: "Usuário não encontrado", message: "O nome de usuário ou a senha estão incorretos, tente novamente", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "Aceitar", style: UIAlertActionStyle.default) {
                            (result : UIAlertAction) -> Void in
                            print("OK")
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }else{
                let alertController = UIAlertController(title: "Nova atualização disponível", message: "Atualize seu aplicativo para continuar usando", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Aceitar", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
    }
    
    func handleResponse(_ user: UserFullEntity){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        SingletonsObject.sharedInstance.userSelected = user
        var driverId = NSNumber.init(value: 0)
        if user.user?.idDriver != nil{
            driverId = (user.user?.idDriver)!
        }
        let token = TokenEntity.init(tokenFB: "", idUser: (user.user?.idUser)!, idDriver: driverId, latVersionApp: SingletonsObject.sharedInstance.appCurrentVersion as String)
        
        let http = Http.init()
        startAnimating(CGSize.init(width: 50, height: 50), message: "Espere um momento", messageFont: UIFont.boldSystemFont(ofSize: 12), type: .ballRotate, color: .white, padding: 0.0, displayTimeThreshold: 10, minimumDisplayTime: 2, backgroundColor: .GrayAlpha, textColor: .white)
        http.getToken(token, completion: { (isValidToken) -> Void in
            self.stopAnimating()
            if isValidToken{
                //SocketServices().prepareSocket(GlobalMembers().masterIp, userId: (user.user?.idUser)!, urlBase: GlobalMembers().urlDeveloper)
            }else{
                
            }
        })
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entityName = "UserEntityManaged"
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if let result = try? managedContext.fetch(fetchRequest) {
            for object in result {
                managedContext.delete(object)
            }
        }
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(user.user?.emailUser, forKeyPath: "mail")
        person.setValue(user.user?.userPass, forKeyPath: "password")
        person.setValue(user.user?.firstNameUser, forKeyPath: "username")
        person.setValue(user.user?.idDriver, forKeyPath: "isDriver")
        
        do {
            try managedContext.save()
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MainMenuNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = viewController;
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == mailTxtField { // Switch focus to other text field
            passwordTxtField.becomeFirstResponder()
        }
        if textField == passwordTxtField{
            loginBtn.sendActions(for: .touchUpInside)
        }
        return true
    }
}
