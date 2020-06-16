
class CaloriesCalculator {
    
    //MARK: - Enums
    enum LevelOfActivity: Double {
        case low = 1.1
        case medium = 1.3
        case high = 1.5
    }
    
    //MARK: - Singletone propertie
    static var shared = CaloriesCalculator()

    //MARK: - Private roperties
    private var weight: Float?
    private var height: Float?
    private var age: Int?
    private var isMale: Bool?
    private var activityCoeficient: LevelOfActivity?
    private var weightMode: MeteringSetting.WeightMode?
    private var heightMode: MeteringSetting.HeightMode?
    
    private lazy var gainWeightCalories: Int = 0
    private lazy var loseWeightCalories: Int = 0
    private lazy var neutralCalories: Int = 0
    
    //MARK: - Initialization
    private init() { }
    
    //MARK: - Publick methods
    func getRecomendatinoInfo() -> [RecomendationInfo] {
        self.calculateCalories()
        let loseWeightInfo = self.getLoseWeightRecomendatins()
        let balanceInfo = self.getBalanceSupplyRecomendation()
        let gainWeightInfo = self.getWeighGainRecomendations()
        return [loseWeightInfo, balanceInfo, gainWeightInfo]
    }
    
    func getUserParameters(from userMainInfo: UserMainInfoModel) {
        guard let gender = userMainInfo.gender,
            let activityLevel = userMainInfo.activityLevel,
            let age = userMainInfo.age,
            let height = userMainInfo.height,
            let weight = userMainInfo.weight else { return }
        self.isMale = gender == .male ? true : false
        self.age = age
        self.weight = weight
        self.height = height
        switch activityLevel {
        case .low:
            self.activityCoeficient = .low
        case .mid:
            self.activityCoeficient = .medium
        case .high:
            self.activityCoeficient = .high
        case .notSet:
            break
        }
    }
    
    //MARK: - Private methods
    private func calculateCalories() {
        guard let isMale = self.isMale else { return }
        guard let age = self.age else { return }
        guard let height = self.height else { return }
        guard let weight = self.weight else { return }
        guard let activityCoeficient = self.activityCoeficient?.rawValue else { return }
        if isMale {
            let maleAge = Float(age) * Float(5.7)
            let maleWeight = weight * 13.4
            let maleHeight = height * 4.8
            let maleMainCalories = 88.36 + maleWeight + maleHeight - maleAge
            self.loseWeightCalories = Int(maleMainCalories * Float(activityCoeficient))
        } else {
            let femaleAge = Float(age) * Float(4.3)
            let femaleWeight = weight * 9.2
            let femaleHeight = height * 3.1
            let femaleMainCalories = 447.6 + femaleWeight + femaleHeight - femaleAge
            self.loseWeightCalories = Int(femaleMainCalories * Float(activityCoeficient))
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



