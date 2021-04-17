import Foundation

protocol UserServiceProtocol {

    var userInfo: UserInfoMO { get }
    
    func updateUserInfo(_ userInfoType: UserInfoService.UserInfoType)
    func cleanUserData() -> Bool
}

extension UserInfoService: UserServiceProtocol {
    
    var userInfo: UserInfoMO {
        getUserInfo()
    }
    
    func updateUserInfo(_ userInfoType: UserInfoType) {
        switch userInfoType {
        case .age(let value):
            guard let age = Int(value) else { return }
            updateAge(to: age)
            
        case .weight(let value):
            guard let weight = Float(value) else { return }
            updateWeight(to: weight)
            
        case .gender(let value):
            updateGender(to: value)
            
        case .activityLevel(let value):
            updateActivityLevel(to: value)
            
        case .height(let value):
            guard let height = Float(value) else { return }
            updateHeight(to: height)
            
        case .user(user: let user):
            updateUserMainInfo(to: user)
            
        case .updateDate(date: let date):
            updateDateOfLastUpdateTo(date)
            
        case .nutritionMode(nutritionMode: let nutritionMode):
            updateNutritionMode(to: nutritionMode)
 
        }
    }
    
    @discardableResult func cleanUserData() -> Bool {
        deleteUserMainInfoData()
    }
}
