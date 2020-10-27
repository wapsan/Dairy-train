import Foundation
import RxSwift

final class TrainingPaterModel {
    
    typealias CDM = CoreDataManager
    
    private var disposeBag = DisposeBag()
    
    var trainingPaterns: BehaviorSubject<[TrainingPaternManagedObject]> = BehaviorSubject(value: [])
    
    init() {
        CDM.shared.trainingPatern
            .asObservable()
            .bind(to: self.trainingPaterns.asObserver())
            .disposed(by: disposeBag)
        CDM.shared.updateTrainingPaterns()
    }

    func getTrainingPatern(at index: Int) -> TrainingPaternManagedObject? {
        do {
            return try trainingPaterns.value()[index]
        } catch  {
            return nil
        }
    }
    
    func createTrainingPatern(with name: String) {
        CDM.shared.creteTrainingPatern(with: name)
    }
    
    func removeTrainingPater(at index: Int) {
        CDM.shared.removeTrainingPatern(at: index)
    }
    
    func renameTrainingPatern(at index: Int, with name: String) {
        CDM.shared.renameTrainingPatern(at: index, with: name)
    }
}
