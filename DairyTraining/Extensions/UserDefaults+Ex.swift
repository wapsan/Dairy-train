import Foundation

extension UserDefaults {
    
    //MARK: - Properies
    var token: String? {
        return UserDefaults.standard.value(forKey: "userToken") as? String
    }
    
    var isFirstSession: Bool {
        return UserDefaults.standard.value(forKey: "isFirstSession") as? Bool ?? false
    }
    
    var weightMode: UserInfo.WeightMode {
        guard let rawValue = UserDefaults.standard.value(forKey: "userWeightMode") as? String else {
            return UserInfo.WeightMode.lbs
        }
        return UserInfo.WeightMode(rawValue: rawValue) ?? UserInfo.WeightMode.lbs
    }
    
    var heightMode: UserInfo.HeightMode {
        guard let rawValue = UserDefaults.standard.value(forKey: "userHeightMode") as? String else {
            return UserInfo.HeightMode.ft
        }
        return UserInfo.HeightMode(rawValue: rawValue) ?? UserInfo.HeightMode.ft
    }
    
    var nutritionMode: UserInfo.NutritionMode {
        guard let rawValue = UserDefaults.standard.value(forKey: "userNutritionMode") as? String else {
            return UserInfo.NutritionMode.balanceWeight
        }
        return UserInfo.NutritionMode(rawValue: rawValue) ?? UserInfo.NutritionMode.balanceWeight
    }
    
  //  var customNutritionMode: CustomNutritionCodableModel
    
    //MARK: - Setters
    func setToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "userToken")
    }
    
    func deleteToken() {
        UserDefaults.standard.setValue(nil, forKey: "userToken")
    }
    
    func setFirstSession() {
        UserDefaults.standard.setValue(false, forKey: "isFirstSession")
    }
    
    func setWeightMode(weightMode: UserInfo.WeightMode) {
        UserDefaults.standard.setValue(weightMode.rawValue, forKey: "userWeightMode")
    }
    
    func setHegithMode(heightMode: UserInfo.HeightMode) {
        UserDefaults.standard.setValue(heightMode.rawValue, forKey: "userHeightMode")
    }
    
    func setNutritionMode(nutritionMode: UserInfo.NutritionMode) {
        UserDefaults.standard.setValue(nutritionMode.rawValue, forKey: "userNutritionMode")
    }
}
