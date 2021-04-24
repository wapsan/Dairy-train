import Foundation

struct NutritionRecomendation {
    private(set) var proteins: Float
    private(set) var calories: Float
    private(set) var fats: Float
    private(set) var carbohydtrates: Float
    private(set) var mealPlaneName: String
    
    private(set) var proteinsPercentage: Float
    private(set) var fatsPercentage: Float
    private(set) var carbohydratesPercentage: Float
    
    init(proteins: Float, calories: Float, fats: Float, carbohydtrates: Float, mealPlaneName: String) {
        self.calories = calories
        self.proteins = proteins
        self.fats = fats
        self.carbohydtrates = carbohydtrates
        self.mealPlaneName = mealPlaneName
        guard carbohydtrates > 0, proteins > 0, fats > 0 else {
            self.carbohydratesPercentage = 0
            self.fatsPercentage = 0
            self.proteinsPercentage = 0
            return
        }
        
        self.carbohydratesPercentage = (carbohydtrates * 4 / calories) * 100
        self.fatsPercentage = (fats * 9 / calories) * 100
        self.proteinsPercentage = (proteins * 4 / calories) * 100
    }
    
    init(calories: Float, proteinsPercentage: Float, carbohydratesPercentage: Float, fatsPercentage: Float, mealPlaneName: String) {
        self.calories = calories
        self.fatsPercentage = fatsPercentage
        self.proteinsPercentage = proteinsPercentage
        self.carbohydratesPercentage = carbohydratesPercentage

        self.proteins = (calories / 100) * proteinsPercentage
        self.carbohydtrates = (calories / 100) * carbohydratesPercentage
        self.fats = (calories / 100) * fatsPercentage
        self.mealPlaneName = mealPlaneName
    }
    
    init(customNutritionRecomendation: CustomNutritionModeMO) {
        self.init(proteins: customNutritionRecomendation.proteins,
                  calories: customNutritionRecomendation.calories,
                  fats: customNutritionRecomendation.fats,
                  carbohydtrates: customNutritionRecomendation.carbohydrates, mealPlaneName: "Custom")
    }
 
    init(userInfo: UserInfoMO, nutrtitonMode: UserInfo.NutritionMode, customNutritionMode: CustomNutritionModeMO) {
        var calculator = CaloriesRecomendationCalculator(userInfo: userInfo)
        switch nutrtitonMode {
        case .loseWeight, .weightGain, .balanceWeight:
            let nutrtitionRecomendation = calculator.getRecomendation(for: nutrtitonMode)
            self.init(proteins: nutrtitionRecomendation.proteins,
                      calories: nutrtitionRecomendation.calories,
                      fats: nutrtitionRecomendation.fats,
                      carbohydtrates: nutrtitionRecomendation.carbohydtrates,
                      mealPlaneName: nutrtitionRecomendation.mealPlaneName)
            
        case .custom:
            self.init(customNutritionRecomendation: customNutritionMode)
            
        }
    }
}



struct CaloriesRecomendationCalculator {
    
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
    
    private lazy var balanceProteinsMultiplier: Float = 0.4
    private lazy var balanceCarbohydratesMultiplier: Float = 0.3
    private lazy var balanceFatsMultiplier: Float = 0.3
    
    private lazy var loseWeightProteinsMultiplier: Float = 0.45
    private lazy var loseWeightCarbohydratesMultiplier: Float = 0.2
    private lazy var loseWeightFatsMultiplier: Float = 0.35
    
    private lazy var gainWeightProteinsMultiplier: Float = 0.40
    private lazy var gainWeightCarbohydratesMultiplier: Float = 0.35
    private lazy var gainWeightFatsMultipliers: Float = 0.25
    
    private lazy var gainWeightCalories: Int = 0
    private lazy var loseWeightCalories: Int = 0
    private lazy var neutralCalories: Int = 0
    
    private var weight: Float
    private var height: Float
    private var age: Int
    private var activityCoeficient: Float = 0
    
    private var weightMode: UserInfo.WeightMode?
    private var heightMode: UserInfo.HeightMode?
    
    private var gender: UserInfo.Gender?
    
    private var activityLevel: UserInfo.ActivityLevel? {
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
        return UserDefaults.standard.heightMode.multiplier
    }
    
    private var weightMultiplier: Float {
        return UserDefaults.standard.weightMode.multiplier
    }
    
    init(userInfo: UserInfoMO) {
        self.weight = userInfo.weightValue
        self.height = userInfo.heightValue
        self.age = userInfo.age.int
        if let gender = userInfo.gender {
            self.gender = UserInfo.Gender.init(rawValue: gender)
        } else {
            self.gender = nil
        }
        if let activityLevel = userInfo.activityLevel {
            self.activityLevel = UserInfo.ActivityLevel.init(rawValue: activityLevel)
            if let activityleve = self.activityLevel {
                switch activityleve {
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
        } else {
            self.activityLevel = nil
        }
    }
    
    mutating func getRecomendation(for type: UserInfo.NutritionMode) -> NutritionRecomendation {
        switch type {
        case .loseWeight:
            return getLoseWeightRecomendatins()
        case .balanceWeight:
            return getBalanceSupplyRecomendation()
        case .weightGain:
            return getWeighGainRecomendations()
        case .custom:
            return getWeighGainRecomendations()
        }
    }
    
    private mutating func calculateCalories() {
        guard let gender = self.gender else { return }
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
    
    
    private mutating func getBalanceSupplyRecomendation() -> NutritionRecomendation {
        calculateCalories()
        let balanceCalories = Float(self.neutralCalories)
        let balanceProteins = (Float(self.neutralCalories) * Float(self.balanceProteinsMultiplier)) / 4
        let balanceCarbohydrates = (Float(self.neutralCalories) * Float(self.balanceCarbohydratesMultiplier) ) / 4
        let balanceFats = (Float(self.neutralCalories) * Float(self.balanceFatsMultiplier)) / 9
        let balanceSupply = NutritionRecomendation(proteins: balanceProteins,
                                                   calories: balanceCalories,
                                                   fats: balanceFats,
                                                   carbohydtrates: balanceCarbohydrates, mealPlaneName: "Balance weight")
        return balanceSupply
    }
    
    private mutating func getLoseWeightRecomendatins() -> NutritionRecomendation {
        calculateCalories()
        let loseWeightCalories = Float(self.loseWeightCalories)
        let loseWeightProteins = (Float(self.loseWeightCalories) * Float(self.loseWeightProteinsMultiplier)) / 4
        let loseWeightCarbohydrates = (Float(self.loseWeightCalories) * Float(self.loseWeightCarbohydratesMultiplier)) / 4
        let loseWeightFats = (Float(self.loseWeightCalories) * Float(self.loseWeightFatsMultiplier)) / 9
        let loseWeightSupply = NutritionRecomendation(proteins: loseWeightProteins,
                                                      calories: loseWeightCalories,
                                                      fats: loseWeightFats,
                                                      carbohydtrates: loseWeightCarbohydrates, mealPlaneName: "Lose weight")
        return loseWeightSupply
        
    }
    
    
    private mutating func getWeighGainRecomendations() -> NutritionRecomendation {
        calculateCalories()
        let gainWeightCalories = Float(self.gainWeightCalories)
        let gainWeightProteins = (Float(self.gainWeightCalories) * Float(self.gainWeightProteinsMultiplier)) / 4
        let gainWeightCarbohydrates = (Float(self.gainWeightCalories) * Float(self.gainWeightCarbohydratesMultiplier)) / 4
        let gainWeightFats = (Float(self.gainWeightCalories) * Float(self.gainWeightFatsMultipliers)) / 9
        let gainWeightSupply = NutritionRecomendation(proteins: gainWeightProteins,
                                                      calories: gainWeightCalories,
                                                      fats: gainWeightFats,
                                                      carbohydtrates: gainWeightCarbohydrates, mealPlaneName: "Weight gain")
        return gainWeightSupply
    }
    
    
}
