//
//  CaloriesRecomendationCalculator.swift
//  Dairy Training
//
//  Created by cogniteq on 15.12.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import Foundation

struct NutritionRecomendation {
    let proteins: Float
    let calories: Float
    let fats: Float
    let carbohydtrates: Float
    
    private(set) var proteinsPercentage: Float
    private(set) var fatsPercentage: Float
    private(set) var carbohydratesPercentage: Float
    
    init(proteins: Float, calories: Float, fats: Float, carbohydtrates: Float) {
        self.calories = calories
        self.proteins = proteins
        self.fats = fats
        self.carbohydtrates = carbohydtrates
        guard carbohydtrates > 0, proteins > 0, fats > 0 else {
            self.carbohydratesPercentage = 0
            self.fatsPercentage = 0
            self.proteinsPercentage = 0
            return
        }
        
        self.carbohydratesPercentage = (carbohydtrates * 4 / calories) * 100 //(carbohydtrates / summ) * 100
        self.fatsPercentage = (fats * 9 / calories) * 100  //(fats / summ) * 100
        self.proteinsPercentage = (proteins * 4 / calories) * 100 //(proteins / summ) * 100
//        guard summ > 0 else {
//            self.carbohydratesPercentage = 0
//            self.fatsPercentage = 0
//            self.proteinsPercentage = 0
//            return
//        }
//
//        self.carbohydratesPercentage = (carbohydtrates / summ) * 100
//        self.fatsPercentage = (fats / summ) * 100
//        self.proteinsPercentage = (proteins / summ) * 100
    }
    
    init(calories: Float, proteinsPercentage: Float, carbohydratesPercentage: Float, fatsPercentage: Float) {
        self.calories = calories
        self.fatsPercentage = fatsPercentage
        self.proteinsPercentage = proteinsPercentage
        self.carbohydratesPercentage = carbohydratesPercentage

        self.proteins = (calories / 100) * proteinsPercentage
        self.carbohydtrates = (calories / 100) * carbohydratesPercentage
        self.fats = (calories / 100) * fatsPercentage
    }
    
    init(customNutritionRecomendation: CustomNutritionModeMO) {
        self.init(proteins: customNutritionRecomendation.proteins,
                  calories: customNutritionRecomendation.calories,
                  fats: customNutritionRecomendation.fats,
                  carbohydtrates: customNutritionRecomendation.carbohydrates)
//        self.calories = customNutritionRecomendation.calories
//        self.fats = customNutritionRecomendation.fats
//        self.proteins = customNutritionRecomendation.proteins
//        self.carbohydtrates = customNutritionRecomendation.carbohydrates
//        let summ = carbohydtrates + proteins + fats
//        guard summ > 0 else {
//            self.carbohydratesPercentage = 0
//            self.fatsPercentage = 0
//            self.proteinsPercentage = 0
//            return
//        }
//        self.carbohydratesPercentage = customNutritionRecomendation.carbohydrates * 4 / calories //(carbohydtrates / summ) * 100
//        self.fatsPercentage = customNutritionRecomendation.fats * 9 / calories  //(fats / summ) * 100
//        self.proteinsPercentage = customNutritionRecomendation.proteins * 4 / calories //(proteins / summ) * 100
    }
}

enum NutritionMode: String {
    case loseWeight = "Lose weight"
    case balanceWeight = "Balance Weight"
    case weightGain = "Weight Gain"
    case custom = "Custom"
    
    var presentationTitle: String {
        return "Meal plane: " + rawValue
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
    
    
    init?(userInfo: MainInfoManagedObject?) {
        self.weight = userInfo?.weight ?? 0
        self.height = userInfo?.height ?? 0
        self.age = Int(userInfo?.age ?? 0)
        if let gender = userInfo?.gender {
            self.gender = UserMainInfoCodableModel.Gender.init(rawValue: gender)
        } else {
            return nil
        }
        if let activityLevel = userInfo?.activitylevel {
            self.activityLevel = UserMainInfoCodableModel.ActivityLevel.init(rawValue: activityLevel)
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
            return nil
        }
    
    }
    
    mutating func getRecomendation(for type: NutritionMode) -> NutritionRecomendation {
        switch type {
        case .loseWeight:
            return getLoseWeightRecomendatins()
        case .balanceWeight:
            return getBalanceSupplyRecomendation()
        case .weightGain:
            return getWeighGainRecomendations()
        case .custom:
            return getWeighGainRecomendations()
          //  return nutritionRecomendation
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
                                                   carbohydtrates: balanceCarbohydrates)
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
                                                      carbohydtrates: loseWeightCarbohydrates)
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
                                                      carbohydtrates: gainWeightCarbohydrates)
        return gainWeightSupply
    }
    
    
}
