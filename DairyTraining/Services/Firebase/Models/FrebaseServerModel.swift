struct FrebaseServerModel: Encodable {
    
    let dateOfUpdate: String?
    let userMainInfo: UserInfo?
    let trainingList: [TrainingCodableModel]
    let trainingPaternList: [TrainingPaternCodableModel]
    let customnutritionMode: CustomNutritionCodableModel?
    let dayNutritionCodableModel: [DayNutritionCodableModel]
    
    init(dateOfUpdate: String?,
         userMainInfoModel: UserInfo?,
         trainingLis: [TrainingCodableModel],
         trainingPaternList: [TrainingPaternCodableModel],
         customNutritonData: CustomNutritionCodableModel?,
         dayNutritionCodableModel: [DayNutritionCodableModel]) {
        self.dateOfUpdate = dateOfUpdate
        self.userMainInfo = userMainInfoModel
        self.trainingList = trainingLis
        self.trainingPaternList = trainingPaternList
        self.customnutritionMode = customNutritonData
        self.dayNutritionCodableModel = dayNutritionCodableModel
    }
}
