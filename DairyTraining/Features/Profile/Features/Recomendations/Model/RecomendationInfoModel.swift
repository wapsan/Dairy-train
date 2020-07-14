import Foundation

struct RecomendationInfo {
    
    //MARK: - Properties
    var tittle: String
    var caloriesRecomendation: String
    var proteinRecomendation: String
    var carbohydratesRcomendation: String
    var fatRecomandation: String

    //MARK: - Initialization
    init(tittle: String, calories: String, proteins: String, carbohydrates: String, fats: String) {
        self.tittle = tittle
        self.caloriesRecomendation = String(format: NSLocalizedString("Calories: number ccal.",
                                                                      comment: ""), calories)
        self.proteinRecomendation = String(format: NSLocalizedString("Proteins: number grams.",
                                                                     comment: ""), proteins)
        self.carbohydratesRcomendation = String(format: NSLocalizedString("Carbohydrates: number grams.",
                                                                          comment: ""), carbohydrates)
        self.fatRecomandation = String(format: NSLocalizedString("Fats: number grams.",
                                                                 comment: ""), fats)
    }
}
