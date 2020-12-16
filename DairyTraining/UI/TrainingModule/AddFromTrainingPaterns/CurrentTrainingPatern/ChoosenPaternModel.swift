import Foundation
import RxSwift

final class ChoosenPaternModel {
    
    typealias CDM = TrainingDataManager
    
    private(set) var trainingPatern: TrainingPaternManagedObject
    private(set) var paternName: String
    private var disposeBag = DisposeBag()
    
    var paternNameo: BehaviorSubject<String> = BehaviorSubject(value: "")
    var paternExercises: BehaviorSubject<[ExerciseManagedObject]> = BehaviorSubject(value: [])
    
    init(patern: TrainingPaternManagedObject) {
        self.trainingPatern = patern
        self.paternName = patern.name
        CDM.shared.loadPatern(with: patern.date)
        CDM.shared.curentPatern
            .asObservable()
            .map({ $0?.exerciseArray ?? [] })
            .bind(to: paternExercises.asObserver())
            .disposed(by: disposeBag)
        paternNameo.onNext(patern.name)
    }
    
    func createTrainingWithCurrentpatern(exercise: [Exercise]) {
        if TrainingDataManager.shared.addExercisesToTrain(exercise) {
            NotificationCenter.default.post(name: .trainingListWasChanged, object: nil)
        } else {
            NotificationCenter.default.post(name: .trainingWasChanged, object: nil)
        }
    }
    
    func renameTrainingPaternAlert(for name: String) {
        paternNameo.onNext(name)
        CDM.shared.renameTrainingPatern(with: trainingPatern.date, with: name)
    }
}
