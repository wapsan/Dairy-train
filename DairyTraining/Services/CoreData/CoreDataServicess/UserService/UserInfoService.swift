import Foundation
import CoreData
  
final class UserInfoService {
    
    //MARK: - Types
    enum UserInfoType {
        case age(age: String)
        case weight(weight: String)
        case gender(gender: UserInfo.Gender?)
        case activityLevel(activityLevel: UserInfo.ActivityLevel?)
        case height(height: String)
        case user(user: UserInfo)
        case updateDate(date: String?)
        case nutritionMode(nutritionMode: UserInfo.NutritionMode)

    }

    //MARK: - Private properties
    private let dataModelName: String = "UserInfo"
    
    private lazy var context: NSManagedObjectContext = {
        DataBase.shared.userInfoContext(type: storeType)
    }()
    
    private let storeType: PersistentStoreType
    
    //MARK: - Initialization
    init(storeType: PersistentStoreType = .prod) {
        self.storeType = storeType
    }

    //MARK: - Private methods
    private func updateContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            fatalError("UserInfo Context don't update")
        }
    }
    
    private var isUserDataExist: Bool{
        let fetchRequset: NSFetchRequest<UserInfoMO> = UserInfoMO.fetchRequest()
        guard let userData = try? self.context.fetch(fetchRequset) else { return false }
        return !userData.isEmpty
    }
    
    private func createUserInfo() -> UserInfoMO {
        let newUserData = UserInfoMO(context: context)
        updateContext()
        return newUserData
    }
    
    //MARK: - Public methods
    func getUserInfo() -> UserInfoMO {
        let fetchRequest: NSFetchRequest<UserInfoMO> = UserInfoMO.fetchRequest()
        guard let userInfo = try? context.fetch(fetchRequest).first else { return createUserInfo() }
        return userInfo
    }
    
    func updateDateOfLastUpdateTo(_ date: String?) {
        let userInfo = getUserInfo()
        userInfo.dateOfLastUpdate = date
        updateContext()
    }
    
    func updateAge(to age: Int) {
        let userInfo = getUserInfo()
        userInfo.age = age.int64
        updateContext()
    }
    
    func updateWeight(to weight: Float) {
        let userInfo = getUserInfo()
        userInfo.weightMode = UserDefaults.standard.weightMode.rawValue
        userInfo.weightValue = weight
        updateContext()
    }
    
    func updateHeight(to heigth: Float) {
        let userInfo = getUserInfo()
        userInfo.heightMode = UserDefaults.standard.heightMode.rawValue
        userInfo.heightValue = heigth
        updateContext()
    }
    
    func updateGender(to gender: UserInfo.Gender?) {
        let userInfo = getUserInfo()
        userInfo.gender = gender?.rawValue
        updateContext()
    }
    
    func updateActivityLevel(to activitylevel: UserInfo.ActivityLevel?) {
        let userInfo = getUserInfo()
        userInfo.activityLevel = activitylevel?.rawValue
        updateContext()
    }
    
    func updateNutritionMode(to nutritionMode: UserInfo.NutritionMode) {
        let userInfo = getUserInfo()
        userInfo.nutritionMode = nutritionMode.rawValue
        updateContext()
    }
    
    func updateUserMainInfo(to userMainInfo: UserInfo) {
        let mainUserInfo = getUserInfo()
        mainUserInfo.age = Int64(userMainInfo.age ?? 0)
        mainUserInfo.weightValue = userMainInfo.weightValue ?? 0
        mainUserInfo.heightValue = userMainInfo.heightValue ?? 0
        mainUserInfo.gender = userMainInfo.gender
        mainUserInfo.activityLevel = userMainInfo.activityLevel
        mainUserInfo.heightMode = userMainInfo.heightMode
        mainUserInfo.weightMode = userMainInfo.weightMode
        mainUserInfo.nutritionMode = userMainInfo.nutritionMode
        updateContext()
    }
    
    func deleteUserMainInfoData() -> Bool {
        let userInfoObject = getUserInfo()
        context.delete(userInfoObject)
        updateContext()
        return !isUserDataExist
    }
}
