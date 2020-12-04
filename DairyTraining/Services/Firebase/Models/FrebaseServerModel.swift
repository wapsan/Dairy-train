struct FrebaseServerModel: Encodable {
    
    let dateOfUpdate: String?
    let userMainInfo: UserMainInfoCodableModel?
    let trainingList: [TrainingCodableModel]
    let trainingPaternList: [TrainingPaternCodableModel]
    
    init(dateOfUpdate: String?,
         userMainInfoModel: UserMainInfoCodableModel?,
         trainingLis: [TrainingCodableModel],
         trainingPaternList: [TrainingPaternCodableModel]) {
        self.dateOfUpdate = dateOfUpdate
        self.userMainInfo = userMainInfoModel
        self.trainingList = trainingLis
        self.trainingPaternList = trainingPaternList
    }
}
