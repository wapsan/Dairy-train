import Foundation
import CoreData

protocol ExerciseServiceProtocol {
    func markExerciseAsDone(exercise: ExerciseMO) -> ExerciseMO
    func deleteExercise(exercise: ExerciseMO)
    func getAllExerciseForStatistics(with name: String) -> [ExerciseMO]
}


final class ExerciseService {
    
    //MARK: - Properies
    private let storeType: PersistentStoreType
    
    private var context: NSManagedObjectContext {
        DataBase.shared.workoutContext(type: storeType)
    }
    
    //MARK: - Initialization
    init(storeType: PersistentStoreType = .prod) {
        self.storeType = storeType
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Cannot save context")
        }
    }
}

//MARK: - ExerciseServiceProtocol
extension ExerciseService: ExerciseServiceProtocol {
    
    func markExerciseAsDone(exercise: ExerciseMO) -> ExerciseMO {
        exercise.isDone = true
        saveContext()
        return exercise
    }
    
    func deleteExercise(exercise: ExerciseMO) {
        context.delete(exercise)
        saveContext()
    }
    
    func getAllExerciseForStatistics(with name: String) -> [ExerciseMO] {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        
        let namePredicate = NSPredicate(format: "name == %@", name)
        let trainingExitingPredicate = NSPredicate(format: "workout != nil")
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [namePredicate, trainingExitingPredicate])
        
        let descriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.predicate = compoundPredicate
        fetchRequest.sortDescriptors = [descriptor]
        guard let exercisesWithName = try? context.fetch(fetchRequest) as? [ExerciseMO] else {
            return []
        }
        return exercisesWithName
    }
}
