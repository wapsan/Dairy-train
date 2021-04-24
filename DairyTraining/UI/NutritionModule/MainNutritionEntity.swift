extension NutritionModel {
    
    //MARK: - Types
    enum MealTime: CaseIterable {
        case breakfast
        case lunch
        case dinner
        
        var title: String {
            switch self {
            case .breakfast:
                return "Breakfast"
            case .lunch:
                return "Lunch"
            case .dinner:
                return "Dinner"
            }
        }
    }
    
    struct NutritionSection {
        
        //MARK: - Types
        enum NutritionSectionType {
            case information
            case meals
        }
        
        //MARK: - Properies
        var meals: [MealMO]
        let title: String?
        let type: NutritionSectionType
        
        var numberOfItems: Int {
            switch self.type {
            case .information:
                return 1
            case .meals:
                return meals.count
            }
        }
    }
}
