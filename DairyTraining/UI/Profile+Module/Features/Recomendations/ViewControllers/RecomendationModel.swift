import Foundation

protocol RecomendationModelOutput: AnyObject {
    func setRecomendationInfo(to info: [RecomendationInfo])
}

protocol RecomendationModelIteracting: AnyObject {
    func calculateRecomendation()
}

final class RecomendationModel {
    
    weak var ouptup: RecomendationModelOutput?
    private var caloriesCalculator: CaloriesCalculator
    
    init(_ caloriesCalculator: CaloriesCalculator = CaloriesCalculator()) {
        self.caloriesCalculator = caloriesCalculator
    }
}

extension RecomendationModel: RecomendationModelIteracting {
    func calculateRecomendation() {
        guard let mainInfo = UserDataManager.shared.readUserMainInfo(),
        let mainInfoCodableModel = UserMainInfoCodableModel(from: mainInfo) else { return }
        let recomendationInfo  = self.caloriesCalculator.getUserParameters(from: mainInfoCodableModel)
        self.ouptup?.setRecomendationInfo(to: recomendationInfo)
    }
}
