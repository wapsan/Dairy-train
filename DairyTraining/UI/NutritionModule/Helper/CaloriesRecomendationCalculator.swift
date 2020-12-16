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
}

struct CaloriesRecomendationCalculator {
    
    enum RecomendationType {
        case loseWeight
        case balanceWeight
        case weightGain
    }
    
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
    
    
    init(userInfo: MainInfoManagedObject) {
        self.weight = userInfo.weight 
        self.height = userInfo.height 
        self.age = Int(userInfo.age)
        if let gender = userInfo.gender {
            self.gender = UserMainInfoCodableModel.Gender.init(rawValue: gender)
        }
        if let activityLevel = userInfo.activitylevel {
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
        }
    
    }
    
    mutating func getRecomendation(for type: RecomendationType) -> NutritionRecomendation {
        switch type {
        case .loseWeight:
            return getLoseWeightRecomendatins()
        case .balanceWeight:
            return getBalanceSupplyRecomendation()
        case .weightGain:
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
        let balanceProteins = Float(self.neutralCalories) / Float(self.balanceProteinsMultiplier)
        let balanceCarbohydrates = Float(self.neutralCalories) / Float(self.balanceCarbohydratesMultiplier)
        let balanceFats = Float(self.neutralCalories) / Float(self.balanceFatsMultiplier)
        let balanceSupply = NutritionRecomendation(proteins: balanceProteins,
                                                   calories: balanceCalories,
                                                   fats: balanceFats,
                                                   carbohydtrates: balanceCarbohydrates)
        return balanceSupply
    }
    
    private mutating func getLoseWeightRecomendatins() -> NutritionRecomendation {
        calculateCalories()
        let loseWeightCalories = Float(self.loseWeightCalories)
        let loseWeightProteins = Float(self.loseWeightCalories) / Float(self.loseWeightProteinsMultiplier)
        let loseWeightCarbohydrates = Float(self.loseWeightCalories) / Float(self.loseWeightCarbohydratesMultiplier)
        let loseWeightFats = Float(self.loseWeightCalories) / Float(self.loseWeightFatsMultiplier)
        let loseWeightSupply = NutritionRecomendation(proteins: loseWeightProteins,
                                                      calories: loseWeightCalories,
                                                      fats: loseWeightFats,
                                                      carbohydtrates: loseWeightCarbohydrates)
        return loseWeightSupply
        
    }
    
    
    private mutating func getWeighGainRecomendations() -> NutritionRecomendation {
        calculateCalories()
        let gainWeightCalories = Float(self.gainWeightCalories)
        let gainWeightProteins = Float(self.gainWeightCalories) / Float(self.gainWeightProteinsMultiplier)
        let gainWeightCarbohydrates = Float(self.gainWeightCalories) / Float(self.gainWeightCarbohydratesMultiplier)
        let gainWeightFats = Float(self.gainWeightCalories) / Float(self.gainWeightFatsMultipliers)
        let gainWeightSupply = NutritionRecomendation(proteins: gainWeightProteins,
                                                      calories: gainWeightCalories,
                                                      fats: gainWeightFats,
                                                      carbohydtrates: gainWeightCarbohydrates)
        return gainWeightSupply
    }
    
    
}
