import Foundation

struct NutritionDataPresentable {
    let date: Date?
    let calories: Float
    let proteins: Float
    let carbohydrates: Float
    let fats: Float
    
    var displayCalories: Int {
        return Int(calories.rounded())
    }
    
    var displayFats: Int {
        return Int(fats.rounded())
    }
    
    var displayProteins: Int {
        return Int(proteins.rounded())
    }
    
    var displayCarbohydrates: Int {
        return Int(carbohydrates.rounded())
    }
    
    var displayDate: String? {
        guard let date = self.date else { return nil }
        return DateHelper.shared.getFormatedDateFrom(date, with: .dateForDailyCaloriessIntakeFormat)
    }
 
    init(nutritionDataMO: NutritionDataMO) {
        self.date = nutritionDataMO.date
        var summCalories: Float = 0
        nutritionDataMO.mealsArray.forEach({
            summCalories += $0.calories
        })
        self.calories = summCalories
        var sumProteins: Float = 0
        nutritionDataMO.mealsArray.forEach({
            sumProteins += $0.proteins
        })
        self.proteins = sumProteins
        var sunCarbohydrates: Float = 0
        nutritionDataMO.mealsArray.forEach({
            sunCarbohydrates += $0.carbohydrates
        })
        self.carbohydrates = sunCarbohydrates
        var sumFats: Float = 0
        nutritionDataMO.mealsArray.forEach({
            sumFats += $0.fats
        })
        self.fats = sumFats
    }
}

protocol NutritionViewModelProtocol {
    var nutritionRecomendation: NutritionRecomendation? { get }
    var todayMealNutitionModel: [TodayMealNutritionModel] { get }
    var USERnutritionData: NutritionDataPresentable { get }
}

protocol NutritionViewModelInput: AnyObject {
    
}

final class NutritionViewModel {
    
    // MARK: - Module properties
    weak var view: MainNutritionView?
    
    // MARK: - Private Properties
    private let model: NutritionModelProtocol
    private var _nutritionRecomendation: NutritionRecomendation?
    // MARK: - Initialization
    init(model: NutritionModelProtocol) {
        self.model = model
    }
}

// MARK: - NutritionViewModelProtocol
extension NutritionViewModel: NutritionViewModelProtocol {
    
    var USERnutritionData: NutritionDataPresentable {
        return NutritionDataPresentable(nutritionDataMO: model.nutritionData)
    }

    var todayMealNutitionModel: [TodayMealNutritionModel] {
        return TodayMealNutritionModel.allCases
    }

    var nutritionRecomendation: NutritionRecomendation? {
        return model.recomendation
    }
}

// MARK: - NutritionViewModelInput
extension NutritionViewModel: NutritionViewModelInput {
    
  
}
