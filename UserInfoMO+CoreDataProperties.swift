import Foundation
import CoreData


extension UserInfoMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfoMO> {
        return NSFetchRequest<UserInfoMO>(entityName: "UserInfoMO")
    }

    @NSManaged public var activityLevel: String?
    @NSManaged public var age: Int64
    @NSManaged public var dateOfLastUpdate: String?
    @NSManaged public var gender: String?
    @NSManaged public var heightMode: String
    @NSManaged public var nutritionMode: String
    @NSManaged public var weightMode: String
    @NSManaged public var heightValue: Float
    @NSManaged public var weightValue: Float

}

extension UserInfoMO : Identifiable {

}

extension UserInfoMO {

    var height: MeasurementUnit.Height {
        let heightMode = UserInfo.HeightMode(rawValue: self.heightMode)
        let height = MeasurementUnit.Height(heightValue: heightValue,
                                            heightMode: heightMode ?? UserInfo.HeightMode.defaultHeightMode)
        return height
    }
    
    var weight: MeasurementUnit.Weight {
        let weightMode = UserInfo.WeightMode(rawValue: self.weightMode)
        let weight = MeasurementUnit.Weight(weightValue: weightValue,
                                            weightMode: weightMode ?? UserInfo.WeightMode.defaultWeightMode)
        return weight
    }
    
    var userNutritionMode: UserInfo.NutritionMode {
        return UserInfo.NutritionMode(rawValue: nutritionMode) ?? UserInfo.NutritionMode.defaultNutritioonMode
    }
}
