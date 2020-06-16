
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
        self.caloriesRecomendation = "Calories: \(calories) ccal."
        self.proteinRecomendation = "Proteins: \(proteins) grams."
        self.carbohydratesRcomendation = "Carbohydrates: \(carbohydrates) grams."
        self.fatRecomandation = "Fats: \(fats) grams."
    }
}
