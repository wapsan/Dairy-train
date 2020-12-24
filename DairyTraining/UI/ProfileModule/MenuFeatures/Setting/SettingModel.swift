import UIKit

class SettingDepartament {
    
    static let shared = SettingDepartament
    
    let colorSetting = SettingDepartament(departamentTittle: "Style",name: "Color setting", parametrs: ["Dark", "Ligh"])
    let commonSetting = SettingDepartament(departamentTittle: "Common",name: "Weight metric", parametrs: ["Kilogramm", "Pounds"], aditionalParametrs: ["kg.","lbs"])

    private let departamentTittle: String
    private let settingTittle: String
    private let parametrs: [String]
    private let aditionalParametrs: [String]?
    
    init() {
        self.settingTittle = nil
        self.parametrs = self.settingTittle = name
        self.parametrs = parametrs
        self.aditionalParametrs = aditionalParametrs
        self.departamentTittle = departamentTittle
        self.aditionalParametrs = aditionalParametrs
        self.departamentTittle = departamentTittle
    }
    
    init(departamentTittle: String,name: String, parametrs: [String], aditionalParametrs: [String]?) {
        self.settingTittle = name
        self.parametrs = parametrs
        self.aditionalParametrs = aditionalParametrs
        self.departamentTittle = departamentTittle
    }
    
    init(departamentTittle: String,name: String, parametrs: [String]) {
        self.settingTittle = name
        self.parametrs = parametrs
        self.aditionalParametrs = nil
        self.departamentTittle = departamentTittle
    }
    
}

