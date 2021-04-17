import Foundation
import CoreData

protocol ApproachServiceProtocol {
    func fetchApproaches(for exercise: ExerciseMO) -> [ApproachMO]
    func deleteApproach(approach: ApproachMO)
    func addApproach(approach: Approach, to exercise: ExerciseMO) -> ApproachMO
    func updateApproach(oldApproach: ApproachMO, for newApproach: Approach) -> ApproachMO
}

final class ApproachService {
    
    //MARK: - Private
    private let storeType: PersistentStoreType
    
    private var context: NSManagedObjectContext {
        DataBase.shared.workoutContext(type: storeType)
    }
    
    //MARK: - Initialization
    init(storeType: PersistentStoreType = .prod) {
        self.storeType = storeType
    }
    
    //MARK: - Provate methods
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Cannot save context")
        }
    }
}

//MARK: - ApproachServiceProtocol
extension ApproachService: ApproachServiceProtocol {
    
    func fetchApproaches(for exercise: ExerciseMO) -> [ApproachMO] {
        let perdicate = NSPredicate(format: "exercise == % @", exercise)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(ApproachMO.index), ascending: true)
        let fetchRequest: NSFetchRequest<ApproachMO> = ApproachMO.fetchRequest()
        fetchRequest.predicate = perdicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        guard let approaches = try? context.fetch(fetchRequest) else { return [] }
        return approaches
    }
    
    func deleteApproach(approach: ApproachMO) {
        context.delete(approach)
        saveContext()
    }
    
    func addApproach(approach: Approach, to exercise: ExerciseMO) -> ApproachMO {
        let newApproach = ApproachMO(context: context)
        newApproach.weightValue = approach.weight
        newApproach.weightMode = UserDefaults.standard.weightMode.rawValue
        newApproach.index = exercise.aproachesArray.count.int64
        newApproach.reps = approach.reps.int64
        newApproach.exercise = exercise
        exercise.addToApproaches(newApproach)
        saveContext()
        return newApproach
    }
    
    func updateApproach(oldApproach: ApproachMO, for newApproach: Approach) -> ApproachMO {
        oldApproach.weightValue = newApproach.weight
        oldApproach.weightMode = UserDefaults.standard.weightMode.rawValue
        oldApproach.index = newApproach.index.int64
        oldApproach.reps = newApproach.reps.int64
        saveContext()
        return oldApproach
    }
}
