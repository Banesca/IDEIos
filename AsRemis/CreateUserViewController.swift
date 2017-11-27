//
//  CreateUserViewController.swift
//  AsRemis
//
//  Created by Luis Fernando Bustos Ramírez on 9/24/17.
//  Copyright © 2017 Apreciasoft. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController{
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var nextQuestionBtn: UIButton!
    @IBOutlet weak var lastQuestionBtn: UIButton!
    @IBOutlet weak var userDetailsTV: UITableView!
    
    var indexSelected = 0
    var isDriver = false
    var statusInfoArr = [Dictionary<String,String>]()
    var submenuInfoArr = [Dictionary<String,String>]()
    var driverInfo = NSMutableDictionary()
    
    var optionsMenu2 = [BrandEntity]()
    var optionsMenu3 = [ModelByBrand]()
    var optionsMenu1 = [FleetTypeEntity]()
    var optionsMenu4 = [EnterpriceEntity]()
    var optionsMenu5 = [CompanyAcountEntity]()
    var optionsMenu6 = [CenterAcountEntity]()
    
    var brandSelected = BrandEntity()
    var modelSelected = ModelByBrand()
    var fleetSelected = FleetTypeEntity()
    var enterprice = EnterpriceEntity()
    var company = CompanyAcountEntity()
    var center = CenterAcountEntity()
    var domainSelected = ""
    var timeSelected = ""
    var photoSelected = ""
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isDriver{
            navigationItem.title = "Novo usuário!"
        }else{
            navigationItem.title = "Novo motorista!"
        }
        self.prepareNewInfoUser()
        
        let progress = Float(indexSelected)/Float(statusInfoArr.count-1)
        progressView.setProgress(progress, animated: true)
        
        userDetailsTV.register(UINib(nibName: "CreateUserTableViewCell", bundle: nil), forCellReuseIdentifier: "CreateUserTableViewCell")
        userDetailsTV.register(UINib(nibName: "CreateUserSubmenuTableViewCell", bundle: nil), forCellReuseIdentifier: "CreateUserSubmenuTableViewCell")
        userDetailsTV.register(UINib(nibName: "MotoristaBRTableViewCell", bundle: nil), forCellReuseIdentifier: "MotoristaBRTableViewCell")
        userDetailsTV.register(UINib(nibName: "VehicleBRTableViewCell", bundle: nil), forCellReuseIdentifier: "VehicleBRTableViewCell")
        
        userDetailsTV.delegate = self
        userDetailsTV.dataSource = self
        
        imagePicker.delegate = self
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func lastQuestionAction(_ sender: Any) {
        if indexSelected > 0{
            indexSelected -= 1
            let progress = Float(indexSelected)/Float(statusInfoArr.count-1)
            progressView.setProgress(progress, animated: true)
            userDetailsTV.reloadData()
            userDetailsTV.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    @IBAction func nextQuestionAction(_ sender: Any) {
        if indexSelected < statusInfoArr.count - 1{
            indexSelected += 1
            let progress = Float(indexSelected)/Float(statusInfoArr.count-1)
            progressView.setProgress(progress, animated: true)
            userDetailsTV.reloadData()
            userDetailsTV.setContentOffset(CGPoint.zero, animated: true)
        }else{
            createUser()
        }
        
    }
    
    func prepareNewInfoUser(){
        statusInfoArr = [Dictionary<String,String>]()
        submenuInfoArr = [Dictionary<String,String>]()
        if(isDriver){
            statusInfoArr.append(["title":"Cadastro de motorista","information":""])
            statusInfoArr.append(["title":"Cadastro de veículos","information":""])
            statusInfoArr.append(["title":"Confirmar","information":""])
            
            submenuInfoArr.append(["title":"Categoría","information":"Seleccionar"])
            submenuInfoArr.append(["title":"Marca","information":"Seleccionar"])
            submenuInfoArr.append(["title":"Modelo","information":"Seleccionar"])
            
            driverInfo.setValue("", forKey: "dEmail")
            driverInfo.setValue("", forKey: "dPass")
            driverInfo.setValue("", forKey: "dName")
            driverInfo.setValue("", forKey: "dLastname")
            driverInfo.setValue("", forKey: "dPhone")
            driverInfo.setValue(UIImage.init(named: "nopic"), forKey: "dProfileImg")
            driverInfo.setValue("", forKey: "dRG")
            driverInfo.setValue("", forKey: "dCPF")
            driverInfo.setValue("AAAA/MM/DD", forKey: "dExpiration")
            driverInfo.setValue(UIImage.init(named: "nopic"), forKey: "dCNHImg")
            
            driverInfo.setValue("Selecione", forKey: "vType")
            driverInfo.setValue("Selecione", forKey: "vBrand")
            driverInfo.setValue("Selecione", forKey: "vModel")
            driverInfo.setValue("", forKey: "vCor")
            driverInfo.setValue("", forKey: "vPlaca")
            driverInfo.setValue("", forKey: "vAssure")
            driverInfo.setValue("", forKey: "vPolicy")
            driverInfo.setValue("AAAA/MM/DD", forKey: "vExpiration")
            driverInfo.setValue(UIImage.init(named: "nopic"), forKey: "vPolicyImg")
            driverInfo.setValue("AAAA/MM/DD", forKey: "vDoc")
            driverInfo.setValue(UIImage.init(named: "nopic"), forKey: "vDocImg")
            driverInfo.setValue("", forKey: "vResume")
            driverInfo.setValue("", forKey: "vConfirm")
            driverInfo.setValue("", forKey: "vAcceptEmail")
            
            getBOInfoForDriver()
            getFleetType()
        }else{
            statusInfoArr.append(["title":"Nombre","information":""])
            statusInfoArr.append(["title":"Apellido","information":""])
            statusInfoArr.append(["title":"Telefono","information":""])
            statusInfoArr.append(["title":"Email","information":""])
            statusInfoArr.append(["title":"Contraseña","information":""])
            statusInfoArr.append(["title":"CUETA/C.Costo","information":""])
            statusInfoArr.append(["title":"Confirmar","information":""])
            
            submenuInfoArr.append(["title":"Empresa","information":"Seleccionar"])
            submenuInfoArr.append(["title":"Cuenta","information":"Seleccionar"])
            submenuInfoArr.append(["title":"Centro Costo","information":"Seleccionar"])
        }
    }
    
    
    func createUser(){
        let http = Http.init()
        if isDriver{
            let driver = UserCreateEntity.init(clientWith: (driverInfo.value(forKey: "dName") as? String)!,
                                               lastName: (driverInfo.value(forKey: "dLastname") as? String)!,
                                               phone: (driverInfo.value(forKey: "dPhone") as? String)!,
                                               email: (driverInfo.value(forKey: "dEmail") as? String)!,
                                               password: (driverInfo.value(forKey: "dPass") as? String)!)
            driver._BR_cnh = "0"
            driver._BR_cpf = (driverInfo.value(forKey: "dCPF") as? String)!
            driver._BR_rg = (driverInfo.value(forKey: "dRG") as? String)!
            driver._BR_date_cnh = (driverInfo.value(forKey: "dExpiration") as? String)!
            driver._BR_date_rg = ""
            driver.isVehicleProvider = 1
            driver.pass = (driverInfo.value(forKey: "dPass") as? String)!
            driver.phone = (driverInfo.value(forKey: "dPhone") as? String)!
            
            let fleet = FleetIDEEntity()
            fleet._BR_COLOR = (driverInfo.value(forKey: "vCor") as? String)!
            fleet._BR_PORTAS = "0"
            fleet._BR_ano = "0"
            fleet._BR_company_seguro = (driverInfo.value(forKey: "vAssure") as? String)!
            fleet._BR_dateNrDoc = "0"
            fleet._BR_nrDoc = (driverInfo.value(forKey: "vDoc") as? String)!
            fleet._BR_txt = (driverInfo.value(forKey: "vResume") as? String)!
            fleet.dateExpiryInsurance = (driverInfo.value(forKey: "vExpiration") as? String)!
            fleet.domain = ""
            fleet.idVehicleModelAsigned = modelSelected.idVehicleModel
            fleet.idVehiclenTypeAsigned = fleetSelected.idVehiclenTypeAsigned
            fleet.idVeichleBrandAsigned = brandSelected.idVehicleBrand
            fleet.policyNumber = (driverInfo.value(forKey: "vPolicy") as? String)!
            
            http.addPlusDriverIDE(driver, fleet: fleet, completion: { (response) -> Void in
                if (response?.intValue ?? 0) > 0 {
                    let idDriver = "\(response!.intValue)"
                    http.uploadImag((self.driverInfo.value(forKey: "dProfileImg") as? UIImage)!,
                                    name: "\(idDriver)", completion: { (response) -> Void in
                                        if response!{
                                            print("upload complete Img")
                                        }else{
                                            print("error on upload complete")
                                        }
                    })
                    http.uploadImag((self.driverInfo.value(forKey: "dCNHImg") as? UIImage)!,
                                    name: "\(idDriver)CNH", completion: { (response) -> Void in
                                        if response!{
                                            print("upload complete CNH")
                                        }else{
                                            print("error on upload complete")
                                        }
                    })
                    http.uploadImag((self.driverInfo.value(forKey: "vPolicyImg") as? UIImage)!,
                                    name: "\(idDriver)ANX", completion: { (response) -> Void in
                                        if response!{
                                            print("upload complete ANX")
                                        }else{
                                            print("error on upload complete")
                                        }
                    })
                    http.uploadImag((self.driverInfo.value(forKey: "vDocImg") as? UIImage)!,
                                    name: "\(idDriver)DVH", completion: { (response) -> Void in
                                        if response!{
                                            print("upload complete DVH")
                                        }else{
                                            print("error on upload complete")
                                        }
                    })
                    self.createUserSuccessfull()
                }else{
                    self.errorInUserCreated()
                }
            })
            
            
        }
    }
    
}

//MARK: Alerts
extension CreateUserViewController{
    
    func showAlertMessage(){
        let alertController = UIAlertController(title: "Informação incompleta", message: "Preencha todos os campos", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Aceitar", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func errorInUserCreated(){
        let alertController = UIAlertController(title: "Erro ao criar o motorista", message: "Verifique os dados", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Aceitar", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createUserSuccessfull(){
        let alertController = UIAlertController(title: "Sucesso", message: "A conta foi criada com sucesso", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Aceitar", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = viewController;
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

//MARK: Methods for clientWS
extension CreateUserViewController{
    func validateMail(){
        let http = Http.init()
        let email = statusInfoArr[3]["information"]! as String
        if (email.count > 5) {
            http.validatorDomaint(email, completion: { (enterprices) -> Void in
                if enterprices != nil{
                    for enterprice in enterprices!{
                        self.optionsMenu4.append(enterprice)
                    }
                }
            })
        }
    }
    
    func getCompaniesFor(enterprice:EnterpriceEntity){
        self.enterprice = enterprice
        let http = Http.init()
        http.getAcountByidCompany(enterprice.idCompanyClient!, completion: { (companies) -> Void in
            if companies != nil{
                for company in companies!{
                    self.optionsMenu5.append(company)
                }
            }
        })
    }
    
    func getCostFor(company:CompanyAcountEntity){
        self.company = company
        let http = Http.init()
        http.costCenterByidAcount(company.idCompanyAcount!, completion: { (costs) -> Void in
            if costs != nil{
                for cost in costs!{
                    self.optionsMenu6.append(cost)
                }
            }
        })
    }
    
}

//MARK: Methods for driverWS
extension CreateUserViewController{
    func getBOInfoForDriver(){
        let http = Http.init()
        http.brand({ (brands) -> Void in
            if brands != nil{
                for brand in brands!{
                    self.optionsMenu2.append(brand)
                }
            }
        })
    }
    
    func getBrandModel(brand:BrandEntity){
        brandSelected = brand
        let http = Http.init()
        http.byidBrand(brand.idVehicleBrand!, completion: {(models) -> Void in
            if models != nil{
                for model in models!{
                    self.optionsMenu3.append(model)
                }
            }
        })
    }
    
    func getFleetType(){
        let http = Http.init()
        http.fleetType({(fleets) -> Void in
            if fleets != nil{
                for fleet in fleets!{
                    self.optionsMenu1.append(fleet)
                }
            }
        })
    }
}

//MARK: Methods for search Photo
extension CreateUserViewController{
    
    func photoFromLibrary() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }
    
    func shootPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "Sem câmera",
            message: "Desculpe, este dispositivo não tem uma câmera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "Aceitar",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
}

extension CreateUserViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: Table View data sources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexSelected != -1 && indexSelected == indexPath.row){
            let title = statusInfoArr[indexPath.row]["title"]
            if isDriver{
                if title == "Cadastro de motorista"{
                    return 850
                }
                if title == "Cadastro de veículos"{
                    return 1080
                }
                return 150
            }else{
                return 50
            }
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexSelected != -1 && indexSelected == indexPath.row){
            let title = statusInfoArr[indexPath.row]["title"]
            if isDriver{
                if title == "Cadastro de motorista"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MotoristaBRTableViewCell", for: indexPath) as! MotoristaBRTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.numberLbl.text = "\(indexPath.row+1)"
                    cell.titleLbl.text = statusInfoArr[indexPath.row]["title"]!
                    
                    cell.emailTxt.text = driverInfo.value(forKey: "dEmail") as? String
                    cell.passwordTxt.text = driverInfo.value(forKey: "dPass") as? String
                    cell.confirmPasswordTxt.text = driverInfo.value(forKey: "dPass") as? String
                    cell.nameTxt.text = driverInfo.value(forKey: "dName") as? String
                    cell.lastnameTxt.text = driverInfo.value(forKey: "dLastname") as? String
                    cell.phoneTxt.text = driverInfo.value(forKey: "dPhone") as? String
                    cell.profileImg.image = driverInfo.value(forKey: "dProfileImg") as? UIImage
                    cell.rgTxt.text = driverInfo.value(forKey: "dRG") as? String
                    cell.cpfTxt.text = driverInfo.value(forKey: "dCPF") as? String
                    cell.expirationTxt.setTitle(driverInfo.value(forKey: "dExpiration") as? String, for: UIControlState.normal)
                    cell.cnhImg.image = driverInfo.value(forKey: "dCNHImg") as? UIImage
                    
                    cell.delegate = self
                    return cell
                }
                if title == "Cadastro de veículos"{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "VehicleBRTableViewCell", for: indexPath) as! VehicleBRTableViewCell
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    cell.numberLbl.text = "\(indexPath.row+1)"
                    cell.titleLbl.text = statusInfoArr[indexPath.row]["title"]!
                    
                    cell.brandSelectorBtn.setTitle(driverInfo.value(forKey: "vBrand") as? String, for: UIControlState.normal)
                    cell.typeSelectorBtn.setTitle(driverInfo.value(forKey: "vType") as? String, for: UIControlState.normal)
                    cell.modelSelectorBtn.setTitle(driverInfo.value(forKey: "vModel") as? String, for: UIControlState.normal)
                    cell.corTxt.text = driverInfo.value(forKey: "vCor") as? String
                    cell.placaTxt.text = driverInfo.value(forKey: "vPlaca") as? String
                    cell.assureTxt.text = driverInfo.value(forKey: "vAssure") as? String
                    cell.policyTxt.text = driverInfo.value(forKey: "vPolicy") as? String
                    cell.expirationBtn.setTitle(driverInfo.value(forKey: "vExpiration") as? String, for: UIControlState.normal)
                    cell.plicyImg.image = driverInfo.value(forKey: "vPolicyImg") as? UIImage
                    cell.docBtn.setTitle(driverInfo.value(forKey: "vDoc") as? String, for: UIControlState.normal)
                    cell.docImg.image = driverInfo.value(forKey: "vDocImg") as? UIImage
                    cell.detailsTxt.text = driverInfo.value(forKey: "vResume") as? String
                    
                    cell.delegate = self
                    return cell
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: "CreateUserTableViewCell", for: indexPath) as! CreateUserTableViewCell
                cell.numberLbl.text = "\(indexPath.row+1)"
                cell.valueTxtField.text = statusInfoArr[indexPath.row]["information"]!
                cell.titleLbl.text = statusInfoArr[indexPath.row]["title"]!
                if(indexPath.row == statusInfoArr.count - 1){
                    cell.valueTxtField.isHidden = true
                }else{
                    cell.valueTxtField.isHidden = false
                }
                cell.delegate = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CreateUserTableViewCell", for: indexPath) as! CreateUserTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.numberLbl.text = "\(indexPath.row+1)"
                cell.valueTxtField.text = statusInfoArr[indexPath.row]["information"]!
                cell.titleLbl.text = statusInfoArr[indexPath.row]["title"]!
                if(cell.titleLbl.text == "Contraseña"){
                    cell.valueTxtField.isSecureTextEntry = true
                }else{
                    cell.valueTxtField.isSecureTextEntry = false
                }
                if(cell.titleLbl.text == "Telefono"){
                    cell.valueTxtField.keyboardType = .numberPad
                }else{
                    if(cell.titleLbl.text == "Email"){
                        cell.valueTxtField.keyboardType = .emailAddress
                    }else{
                        cell.valueTxtField.keyboardType = .default
                    }
                }
                
                if(indexPath.row == statusInfoArr.count - 1){
                    cell.valueTxtField.isHidden = true
                }else{
                    cell.valueTxtField.isHidden = false
                }
                cell.delegate = self
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisableCell", for: indexPath)
        let lblNumber = cell.viewWithTag(101) as! UILabel
        lblNumber.layer.cornerRadius = lblNumber.bounds.size.height/2
        lblNumber.clipsToBounds = true
        let lblTitle = cell.viewWithTag(102) as! UILabel
        
        lblTitle.text = statusInfoArr[indexPath.row]["title"]!
        lblNumber.text = "\(indexPath.row+1)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //tableView.cellForRow(at: indexPath).
        //let progress = Float(indexPath.row)/Float(statusInfoArr.count-1)
        //progressView.setProgress(progress, animated: true)
        //indexSelected = indexPath.row
        //userDetailsTV.reloadData()
    }
}

extension CreateUserViewController: VehicleBRTableViewCellDelegate{
    
    func continueActionType(_ type: String, brand: String, model: String, cor: String, placa: String, assure: String, policy: String, expiration: String, plicyImg: UIImage, doc: String, docImg: UIImage, resume: String, confirm: Bool, acceptEmail: Bool) {
        driverInfo.setValue(type, forKey: "vType")
        driverInfo.setValue(brand, forKey: "vBrand")
        driverInfo.setValue(model, forKey: "vModel")
        driverInfo.setValue(cor, forKey: "vCor")
        driverInfo.setValue(placa, forKey: "vPlaca")
        driverInfo.setValue(assure, forKey: "vAssure")
        driverInfo.setValue(policy, forKey: "vPolicy")
        driverInfo.setValue(expiration, forKey: "vExpiration")
        driverInfo.setValue(plicyImg, forKey: "vPolicyImg")
        driverInfo.setValue(doc, forKey: "vDoc")
        driverInfo.setValue(docImg, forKey: "vDocImg")
        driverInfo.setValue(resume, forKey: "vResume")
        driverInfo.setValue(confirm, forKey: "vConfirm")
        driverInfo.setValue(acceptEmail, forKey: "vAcceptEmail")
        
        indexSelected += 1
        let progress = Float(indexSelected)/Float(statusInfoArr.count-1)
        progressView.setProgress(progress, animated: true)
        userDetailsTV.reloadData()
        userDetailsTV.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func photoSelected(_ name: String, byCamera: Bool) {
        photoSelected = name
        if byCamera{
            photoFromLibrary()
        }else{
            shootPhoto()
        }
    }
    
    func dateSelectedInCell(_ dateS: String) {
        timeSelected = dateS
        let selector = SelectorViewController(nibName: "SelectorViewController", bundle: nil)
        selector.modalTransitionStyle = .crossDissolve
        selector.modalPresentationStyle = .overCurrentContext
        selector.delegate = self
        selector.selectorDate = true
        self.present(selector, animated: true, completion: nil)
    }
    
    func textChanged(_ currentTxt: String, withTxt: String) {
        driverInfo.setValue(withTxt, forKey: currentTxt)
    }
    
}

extension CreateUserViewController: MotoristaBRTableViewCellDelegate{
    
    func continueActionEmail(_ email: String, password: String, name: String, lastname: String, phone: String, profileImg: UIImage, rg: String, cpf: String, expiration: String, cnhImg: UIImage) {
        driverInfo.setValue(email, forKey: "dEmail")
        driverInfo.setValue(password, forKey: "dPass")
        driverInfo.setValue(name, forKey: "dName")
        driverInfo.setValue(lastname, forKey: "dLastname")
        driverInfo.setValue(phone, forKey: "dPhone")
        driverInfo.setValue(profileImg, forKey: "dProfileImg")
        driverInfo.setValue(rg, forKey: "dRG")
        driverInfo.setValue(cpf, forKey: "dCPF")
        driverInfo.setValue(expiration, forKey: "dExpiration")
        driverInfo.setValue(cnhImg, forKey: "dCNHImg")
        
        indexSelected += 1
        let progress = Float(indexSelected)/Float(statusInfoArr.count-1)
        progressView.setProgress(progress, animated: true)
        userDetailsTV.reloadData()
        userDetailsTV.setContentOffset(CGPoint.zero, animated: true)
    }
}

extension CreateUserViewController: CreateUserCellDelegate{
    func continueAction(_ valueTxt: String) {
        if indexSelected < statusInfoArr.count - 1{
            if !isDriver && indexSelected == 3{
                //Falta crear un loading
                statusInfoArr[indexSelected]["information"]! = valueTxt
                indexSelected += 1
                let progress = Float(indexSelected)/Float(statusInfoArr.count-1)
                progressView.setProgress(progress, animated: true)
                userDetailsTV.reloadData()
                validateMail()
            }else{
                statusInfoArr[indexSelected]["information"]! = valueTxt
                indexSelected += 1
                let progress = Float(indexSelected)/Float(statusInfoArr.count-1)
                progressView.setProgress(progress, animated: true)
                userDetailsTV.reloadData()
            }
        }else{
            createUser()
        }
    }
}

extension CreateUserViewController: CreateUserSubmenuCellDelegate{
    func continueAction(_ firstValue: String, secondValue: String, tirthValue: String) {
        submenuInfoArr[0]["information"]! = firstValue
        submenuInfoArr[1]["information"]! = secondValue
        submenuInfoArr[2]["information"]! = tirthValue
        indexSelected += 1
        let progress = Float(indexSelected)/Float(statusInfoArr.count-1)
        progressView.setProgress(progress, animated: true)
        userDetailsTV.reloadData()
    }
    
    func domainValue(_ domain: String) {
        domainSelected = domain
    }
    
    func actionSelected(_ index: Int) {
        let picker = AlertPickerSelectorViewController(nibName: "AlertPickerSelectorViewController", bundle: nil)
        picker.delegate = self
        picker.modalTransitionStyle = .crossDissolve
        picker.modalPresentationStyle = .overCurrentContext
        picker.tag = index
        if !isDriver{
            switch index {
            case 1:
                var arrTemp = [String]()
                for enterprice in optionsMenu4{
                    arrTemp.append(enterprice.nameClientCompany!)
                }
                picker.arrOptions = arrTemp
                break
            case 2:
                var arrTemp = [String]()
                for company in optionsMenu5{
                    arrTemp.append(company.nrAcount!)
                }
                picker.arrOptions = arrTemp
                break
            default:
                var arrTemp = [String]()
                for cost in optionsMenu6{
                    arrTemp.append(cost.costCenter!)
                }
                picker.arrOptions = arrTemp
            }
        }else{
            switch index {
            case 2:
                var arrTemp = [String]()
                for brand in optionsMenu2{
                    arrTemp.append(brand.nameVehicleBrand!)
                }
                picker.arrOptions = arrTemp
                break
            case 3:
                var arrTemp = [String]()
                for model in optionsMenu3{
                    arrTemp.append(model.nameVehicleModel!)
                }
                picker.arrOptions = arrTemp
                break
            default:
                var arrTemp = [String]()
                for fleet in optionsMenu1{
                    arrTemp.append(fleet.vehiclenType!)
                }
                picker.arrOptions = arrTemp
            }
        }
        self.present(picker, animated: true, completion: nil)
    }
}

extension CreateUserViewController: AlertPickerDelegate{
    
    func indexSelected(_ index: Int, andTag: Int) {
        if isDriver{
            switch andTag {
            case 1:
                fleetSelected = optionsMenu1[index]
                driverInfo.setValue(optionsMenu1[index].vehiclenType, forKey: "vType")
                submenuInfoArr[2]["information"] = optionsMenu1[index].vehiclenType
                break
            case 2:
                getBrandModel(brand: optionsMenu2[index])
                driverInfo.setValue(optionsMenu2[index].nameVehicleBrand, forKey: "vBrand")
                submenuInfoArr[0]["information"] = optionsMenu2[index].nameVehicleBrand
                break
            default:
                modelSelected = optionsMenu3[index]
                driverInfo.setValue(optionsMenu3[index].nameVehicleModel, forKey: "vModel")
                submenuInfoArr[1]["information"] = optionsMenu3[index].nameVehicleModel
            }
        }else{
            switch andTag {
            case 1:
                getCompaniesFor(enterprice: optionsMenu4[index])
                submenuInfoArr[0]["information"] = optionsMenu4[index].nameClientCompany
                break
            case 2:
                getCostFor(company: optionsMenu5[index])
                submenuInfoArr[1]["information"] = optionsMenu5[index].nrAcount
                break
            default:
                center = optionsMenu6[index]
                submenuInfoArr[2]["information"] = optionsMenu6[index].costCenter
            }
        }
        userDetailsTV.reloadData()
    }
}

extension CreateUserViewController: SelectorDateDelegate{
    func dateSelected(_ date: Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy/MM/dd"
        let timeString = dateformatter.string(from: date)
        driverInfo.setValue(timeString, forKey: timeSelected)
        userDetailsTV.reloadData()
    }
    func timeSelected(_ time: Date) {
    }
}

extension  CreateUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            driverInfo.setValue(pickedImage, forKey: photoSelected)
            userDetailsTV.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

