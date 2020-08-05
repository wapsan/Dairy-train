class CaloriesCalculator {
    
    //MARK: - Singletone propertie
    static var shared = CaloriesCalculator()
    
    //MARK: - Private roperties
    private lazy var maleAgeMultiplier: Float = 5.7
    private lazy var maleWeightMultiplier: Float = 13.4
    private lazy var maleHeightMultiplier: Float = 4.8
    private lazy var maleBaseCaloriesNumber: Float = 88.36
    
    private lazy var femaleAgeMultiplier: Float = 4.3
    private lazy var femaleWeightMultiplier: Float = 9.2
    private lazy var femaleHeightMultiplier: Float = 3.1
    private lazy var femaleBaseCaloriesNumber: Float = 447.6
    
    private lazy var neutralCaloriesMultiplier: Float = 1.2
    
    private lazy var balanceProteinsMultiplier: Float = 10
    private lazy var balanceCarbohydratesMultiplier: Float = 10
    private lazy var balanceFatsMultiplier: Float = 22.2
    
    private lazy var loseWeightProteinsMultiplier: Float = 8.75
    private lazy var loseWeightCarbohydratesMultiplier: Float = 10
    private lazy var loseWeightFatsMultiplier: Float = 27.7
    
    private lazy var gainWeightProteinsMultiplier: Float = 7.5
    private lazy var gainWeightCarbohydratesMultiplier: Float = 12.5
    private lazy var gainWeightFatsMultipliers: Float = 22.2
    
    private lazy var gainWeightCalories: Int = 0
    private lazy var loseWeightCalories: Int = 0
    private lazy var neutralCalories: Int = 0
    
    private var weight: Float?
    private var height: Float?
    private var age: Int?
    private var activityCoeficient: Float = 0
    
    private var weightMode: MeteringSetting.WeightMode?
    private var heightMode: MeteringSetting.HeightMode?
    private var gender: UserMainInfoCodableModel.Gender?
    
    private var activityLevel: UserMainInfoCodableModel.ActivityLevel? {
        willSet {
            switch newValue {
            case .low:
                self.activityCoeficient = 1.1
            case .mid:
                self.activityCoeficient = 1.3
            case .high:
                self.activityCoeficient = 1.5
            default:
                break
            }
        }
    }
    
    private var heightMultiplier: Float {
        switch MeteringSetting.shared.heightMode {
        case .cm:
            return 1
        case .ft:
            return 1 / 0.032
        }
    }
    
    private var weightMultiplier: Float {
        switch MeteringSetting.shared.weightMode {
        case .kg:
            return 1
        case .lbs:
            return 1 / 2.2
        }
    }
    
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
    
    func getUserParameters(from userMainInfo: UserMainInfoCodableModel) -> [RecomendationInfo] {
        guard let gender = userMainInfo.gender,
            let activityLevel = userMainInfo.activityLevel,
            let age = userMainInfo.age,
            let height = userMainInfo.height,
            let weight = userMainInfo.weight,
            let weightMode = userMainInfo.weightMode,
            let heightMode = userMainInfo.heightMode else { return  [] }
        self.gender = gender
        self.age = age
        self.weight = weight * self.weightMultiplier
        self.height = height * self.heightMultiplier
        self.activityLevel = activityLevel
        self.heightMode = heightMode
        self.weightMode = weightMode
        return self.getRecomendatinoInfo()
    }
    
    //MARK: - Private methods
    private func calculateCalories() {
        guard let age = self.age,
            let height = self.height,
            let weight = self.weight,
            let gender = self.gender else { return }
        switch gender {
        case .male:
            let maleAge = Float(age) * self.maleAgeMultiplier
            let maleWeight = weight * self.maleWeightMultiplier
            let maleHeight = height * self.maleHeightMultiplier
            let maleMainCalories = self.maleBaseCaloriesNumber + maleWeight + maleHeight - maleAge
            self.loseWeightCalories = Int(maleMainCalories * Float(self.activityCoeficient))
        case .female:
            let femaleAge = Float(age) * self.femaleAgeMultiplier
            let femaleWeight = weight * self.femaleWeightMultiplier
            let femaleHeight = height * self.femaleHeightMultiplier
            let femaleMainCalories = self.femaleBaseCaloriesNumber + femaleWeight + femaleHeight - femaleAge
            self.loseWeightCalories = Int(femaleMainCalories * Float(self.activityCoeficient))
        case .notSet:
            break
        }
        self.neutralCalories = Int(Float(self.loseWeightCalories) * self.neutralCaloriesMultiplier)
        self.gainWeightCalories = Int(Float(self.neutralCalories) * self.neutralCaloriesMultiplier)
    }
    
    private func getBalanceSupplyRecomendation() -> RecomendationInfo {
        let balanceCalories = String(self.neutralCalories)
        let balanceProteins = String(Int(Float(self.neutralCalories) / self.balanceProteinsMultiplier))
        let balanceCarbohydrates = String(Int(Float(self.neutralCalories) / self.balanceCarbohydratesMultiplier))
        let balanceFats = String(Int(Float(self.neutralCalories) / self.balanceFatsMultiplier))
        let balanceSupply = RecomendationInfo(tittle: LocalizedString.balanceWeightSupply,
                                              calories: balanceCalories,
                                              proteins: balanceProteins,
                                              carbohydrates: balanceCarbohydrates,
                                              fats: balanceFats)
        return balanceSupply
    }
    
    private func getLoseWeightRecomendatins() -> RecomendationInfo {
        let loseWeightCalories = String(self.loseWeightCalories)
        let loseWeightProteins = String(Int(Float(self.loseWeightCalories) / self.loseWeightProteinsMultiplier))
        let loseWeightCarbohydrates = String(Int(Float(self.loseWeightCalories) / self.loseWeightCarbohydratesMultiplier))
        let loseWeightFats = String(Int(Float(self.loseWeightCalories) / self.loseWeightFatsMultiplier))
        let loseWeightSupply = RecomendationInfo(tittle: LocalizedString.loseWeightSupply,
                                                 calories: loseWeightCalories,
                                                 proteins: loseWeightProteins,
                                                 carbohydrates: loseWeightCarbohydrates,
                                                 fats: loseWeightFats)
        return loseWeightSupply
        
    }
    
    
    private func getWeighGainRecomendations() -> RecomendationInfo {
        let gainWeightCalories = String(self.gainWeightCalories)
        let gainWeightProteins = String(Int(Float(self.gainWeightCalories) / self.gainWeightProteinsMultiplier))
        let gainWeightCarbohydrates = String(Int(Float(self.gainWeightCalories) / self.gainWeightCarbohydratesMultiplier))
        let gainWeightFats = String(Int(Float(self.gainWeightCalories) / self.gainWeightFatsMultipliers))
        let gainWeightSupply = RecomendationInfo(tittle: LocalizedString.muscleGainSupply,
                                                 calories: gainWeightCalories,
                                                 proteins: gainWeightProteins,
                                                 carbohydrates: gainWeightCarbohydrates,
                                                 fats: gainWeightFats)
        return gainWeightSupply
    }
}
