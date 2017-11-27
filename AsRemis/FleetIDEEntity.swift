//
//  FleetIDEEntity.swift
//  AsRemis
//
//  Created by Luis Fernando Bustos Ramírez on 11/27/17.
//  Copyright © 2017 Apreciasoft. All rights reserved.
//

import UIKit

class FleetIDEEntity: NSObject {

    var _BR_COLOR : String?
    var _BR_PORTAS : String?
    var _BR_ano : String?
    var _BR_company_seguro : String?
    var _BR_dateNrDoc : String?
    var _BR_nrDoc : String?
    var _BR_txt : String?
    var dateExpiryInsurance : String?
    var domain : String?
    var idVehicleModelAsigned : String?
    var idVehiclenTypeAsigned : String?
    var idVeichleBrandAsigned: String?
    var policyNumber : String?
    
    override init(){
        super.init()
    }
    
    func toJSON() -> [String: Any]{
        return [
            "_BR_COLOR": _BR_COLOR as Any,
            "_BR_PORTAS": _BR_PORTAS as Any,
            "_BR_ano": _BR_ano as Any,
            "_BR_company_seguro": _BR_company_seguro as Any,
            "_BR_dateNrDoc": _BR_dateNrDoc as Any,
            "_BR_nrDoc": _BR_nrDoc as Any,
            "_BR_txt": _BR_txt as Any,
            "dateExpiryInsurance": dateExpiryInsurance as Any,
            "domain": domain as Any,
            "idVehicleModelAsigned": idVehicleModelAsigned as Any,
            "idVehiclenTypeAsigned": idVehiclenTypeAsigned as Any,
            "idVeichleBrandAsigned": idVeichleBrandAsigned as Any,
            "policyNumber": policyNumber as Any
        ]
    }
}
