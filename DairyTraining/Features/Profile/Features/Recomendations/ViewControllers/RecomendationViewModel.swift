import Foundation

final class RecomendationViewModel {
    
    var model: RecomendationModelIteracting?
    
    private(set) var supplyModel: [RecomendationInfo] = []
    
    func calculateRecomendation() {
        self.model?.calculateRecomendation()
    }
}

//MARK: - RecomendationModelOutput
extension RecomendationViewModel: RecomendationModelOutput {
    
    func setRecomendationInfo(to info: [RecomendationInfo]) {
        self.supplyModel = info
    }
}
