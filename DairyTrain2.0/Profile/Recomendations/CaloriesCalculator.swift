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
        self.caloriesRecomendation = "Calories: \(calories) ccal."
        self.proteinRecomendation = "Proteins: \(proteins) grams."
        self.carbohydratesRcomendation = "Carbohydrates: \(carbohydrates) grams."
        self.fatRecomandation = "Fats: \(fats) grams."
    }
}

struct CostumerInfo {
    var age: String
    var height: String
    var weight: String
    var gender: String
    var activityLevel: String
}

class CaloriesCalculator {
    
    //MARK: - Enums
    enum LevelOfActivity: Double {
        case low = 1.1
        case medium = 1.3
        case high = 1.5
    }
    
    //MARK: - Static var
    static var shared = CaloriesCalculator()

    //MARK: - Private roperties
    private var weight: Double?
    private var height: Double?
    private var age: Double?
    private var isMale: Bool?
    private var activityCoeficient: LevelOfActivity?
    
    private var gainWeightCalories: Int = 0
    private var loseWeightCalories: Int = 0
    private var neutralCalories: Int = 0
    
    //MARK: - Publick methods
    func getRecomendatinoInfo() -> [RecomendationInfo] {
        self.calculateCalories()
        let loseWeightInfo = self.getLoseWeightRecomendatins()
        let balanceInfo = self.getBalanceSupplyRecomendation()
        let gainWeightInfo = self.getWeighGainRecomendations()
        return [loseWeightInfo, balanceInfo, gainWeightInfo]
    }
   
    func setParametersBy(data: CostumerInfo) {
        guard Double(data.age) != nil else { return }
        guard Double(data.height) != nil else { return }
        guard Double(data.weight) != nil else { return }
        switch data.activityLevel {
        case "Low":
            self.activityCoeficient = .low
        case "High":
            self.activityCoeficient = .high
        default:
            self.activityCoeficient = .medium
        }
        self.isMale = data.gender == "Male" ? true : false
        self.age = Double(data.age)
        self.height = Double(data.height)
        self.weight = Double(data.weight)
        print("")
    }
    
    //MARK: - Private methods
    private func calculateCalories() {
        guard let isMale = self.isMale else { return }
        guard let age = self.age else { return }
        guard let height = self.height else { return }
        guard let weight = self.weight else { return }
        guard let activityCoeficient = self.activityCoeficient?.rawValue else { return }
        if isMale {
            let maleAge = age * 5.7
            let maleWeight = weight * 13.4
            let maleHeight = height * 4.8
            self.loseWeightCalories = Int((88.36 + maleWeight + maleHeight - maleAge) * activityCoeficient)
        } else {
            let femaleAge = age * 4.3
            let femaleWeight = weight * 9.2
            let femaleHeight = height * 3.1
            self.loseWeightCalories = Int((447.6 + femaleWeight + femaleHeight - femaleAge) * activityCoeficient )
        }
        self.neutralCalories = Int(Double(self.loseWeightCalories) * 1.2)
        self.gainWeightCalories = Int(Double(self.neutralCalories) * 1.2)
    }
    
    private func getBalanceSupplyRecomendation() -> RecomendationInfo {
        let neutralCalories = self.neutralCalories
        let balanceCalories = String(neutralCalories)
        let balanceProteins = String(Int(Double(neutralCalories) * 0.40) / 4)
        let balanceCarbohydrates = String(Int(Double(neutralCalories) * 0.40) / 4)
        let balanceFats = String(Int(Double(neutralCalories) * 0.2) / 9)
        let balanceSupply = RecomendationInfo(tittle: "Balance weigh supply",
                                              calories: balanceCalories,
                                              proteins: balanceProteins,
                                              carbohydrates: balanceCarbohydrates,
                                              fats: balanceFats)
        return balanceSupply
    }
    
    private func getLoseWeightRecomendatins() -> RecomendationInfo {
        let loseWeightCalories = String(self.loseWeightCalories)
        let loseWeightProteins = String(Int(Double(self.loseWeightCalories) * 0.35) / 4)
        let loseWeightCarbohydrates = String(Int(Double(self.loseWeightCalories) * 0.40) / 4)
        let loseWeightFats = String(Int(Double(self.loseWeightCalories) * 0.25) / 9)
        let loseWeightSupply = RecomendationInfo(tittle: "Lose weight supply",
                                                 calories: loseWeightCalories,
                                                 proteins: loseWeightProteins,
                                                 carbohydrates: loseWeightCarbohydrates,
                                                 fats: loseWeightFats)
        return loseWeightSupply
        
    }
    
    
    private func getWeighGainRecomendations() -> RecomendationInfo {
        let gainWeightCalories = String(self.gainWeightCalories)
        let gainWeightProteins = String(Int(Double(self.gainWeightCalories) * 0.3) / 4)
        let gainWeightCarbohydrates = String(Int(Double(self.gainWeightCalories) * 0.5) / 4)
        let gainWeightFats = String(Int(Double(self.gainWeightCalories) * 0.2) / 9)
        let gainWeightSupply = RecomendationInfo(tittle: "Muscle gain supply",
                                                 calories: gainWeightCalories,
                                                 proteins: gainWeightProteins,
                                                 carbohydrates: gainWeightCarbohydrates,
                                                 fats: gainWeightFats)
        return gainWeightSupply
    }
    
}



