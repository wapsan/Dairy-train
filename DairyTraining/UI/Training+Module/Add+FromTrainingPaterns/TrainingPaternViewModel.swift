import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct CellItem: Equatable ,IdentifiableType {
    
    //MARK: - Typealias
    typealias Identity = Date
    
    //MARK: - Properties
    var name: String
    var date: Date
    
    var identity: Date {
        return date
    }
    
    static func == (lhs: CellItem, rhs: CellItem) -> Bool {
        return lhs.date == rhs.date && lhs.name == rhs.name
    }
    
    //MARK: - Initialization
    init(patern: TrainingPaternManagedObject) {
        self.name = patern.name
        self.date = patern.date
    }
}

struct SectionItem: Equatable, SectionModelType, IdentifiableType, AnimatableSectionModelType  {
    
    init(original: SectionItem, items: [CellItem]) {
        self = original
        self.items = items
    }
    
    var section: Int
    var items: [CellItem]
    
    typealias Item = CellItem
    
    var identity: Int {
        return section
    }
    
    typealias Identity = Int
    
    init(data: [CellItem]) {
        self.items = data
        self.section = 0
    }
}

final class TrainingPaternViewModel {
    
    //MARK: - Private properties
    private var sectionItems: [CellItem] = []
    private var model: TrainingPaterModel
    private var disposeBag = DisposeBag()
    
    //MARK: - Properties
    var router: TrainingPaternRouter?
    var trainingPaterns: BehaviorRelay<[SectionItem]> = BehaviorRelay(value: [])
    
    //MARK: - Initialization
    init(model: TrainingPaterModel) {
        self.model = model
        self.model.trainingPaterns.asObserver()
            .subscribe(onNext: {
                self.sectionItems = []
                $0.forEach({ self.sectionItems.append(CellItem(patern: $0))})
                self.trainingPaterns.accept([SectionItem(data: self.sectionItems)])
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Public methods
    func goToChoosenTrainingPatern(with trainingPaternIndex: Int) {
        guard let choosenTrainingPatern = model.getTrainingPatern(at: trainingPaternIndex) else { return }
        MainCoordinator.shared.coordinateChild(
            to: TrainingModuleCoordinator.Target.choosenTrainingPatern(patern: choosenTrainingPatern))
    }
    
    func createTrainingPatern(with name: String) {
        sectionItems = []
        model.createTrainingPatern(with: name)
    }
    
    func removeTrainingPatern(at index: Int) {
        sectionItems = []
        model.removeTrainingPater(at: index)
    }
    
    func renameTrainingPatern(at index: Int, with name: String) {
        sectionItems = []
        model.renameTrainingPatern(at: index, with: name)
    }
}

//MARK: - PaternNamingAlertDelegate
extension TrainingPaternViewModel: PaternNamingAlertDelegate {
    
    func patrnNamingAlertOkPressedToRenamePatern(name: String) {
        return
    }
    
    func paternNamingAlertOkPressedToCreatePatern(name: String) {
        createTrainingPatern(with: name)
    }
}
