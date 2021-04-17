import Foundation
import CoreData

protocol WorkoutTemplateServiceProtocol {
    func getWorkoutsTemplates() -> [WorkoutTemplateMO]
    
    func addWorkoutTemplate(title: String, exercise: [Exercise])
    
    func addWorkoutTemplate(title: String) -> WorkoutTemplateMO
    
    func renameWorkoutTemplae(workoutTemplate: WorkoutTemplateMO, for name: String) -> WorkoutTemplateMO
    
    func updateWorkoutTemplatesList(from workoutTemplates: [TrainingPaternCodableModel])
    
    func deleteWorkoutTemplate(workoutTemplate: WorkoutTemplateMO)
    
    func fetchExercise(for workoutTemplate: WorkoutTemplateMO) -> [ExerciseMO]
    
    func addExercises(exercises: [Exercise], to workoutTemplate: WorkoutTemplateMO)
}

final class WorkoutTemplateService {
    
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

//MARK: - WorkoutTemplateServiceProtocol
extension WorkoutTemplateService: WorkoutTemplateServiceProtocol {
    
    func addExercises(exercises: [Exercise], to workoutTemplate: WorkoutTemplateMO) {
        let a = workoutTemplate.exerciseArray.map({ $0.name })
        let newExercises = exercises.filter({ !a.contains($0.name) })
        var managedExercises: [ExerciseMO] = []
        newExercises.forEach({ exercise in
            let newExercise = ExerciseMO(context: context)
            newExercise.name = exercise.name
            newExercise.groupName = exercise.group.rawValue
            newExercise.subgroupName = exercise.subgroub.rawValue
            newExercise.date = Date()
            newExercise.workoutTemplate = workoutTemplate
            newExercise.isDone = false
            managedExercises.append(newExercise)
        })
        workoutTemplate.addToExercises(NSSet(array: managedExercises))
        saveContext()
    }
    
    func fetchExercise(for workoutTemplate: WorkoutTemplateMO) -> [ExerciseMO] {
        let perdicate = NSPredicate(format: "workoutTemplate == % @", workoutTemplate)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(ExerciseMO.name), ascending: true)
        let fetchRequest: NSFetchRequest<ExerciseMO> = ExerciseMO.fetchRequest()
        fetchRequest.predicate = perdicate
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        guard let exericses = try? context.fetch(fetchRequest) else { return [] }
        return exericses
    }
    
    func getWorkoutsTemplates() -> [WorkoutTemplateMO] {
        let fetchRequest: NSFetchRequest<WorkoutTemplateMO> = WorkoutTemplateMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            let trainingPaterns = try self.context.fetch(fetchRequest)
            return trainingPaterns
        } catch {
            return []
        }
    }
    
    func addWorkoutTemplate(title: String, exercise: [Exercise]) {
        let newTrainingPatern = WorkoutTemplateMO(context: context)
        newTrainingPatern.name = title
        newTrainingPatern.date = Date()
        var exercises: [ExerciseMO] = []
        exercise.forEach({ exercise in
            let newexercise = ExerciseMO.init(context: context)
            newexercise.date = Date()
            newexercise.groupName = exercise.group.name
            newexercise.id = exercises.count.int64
            newexercise.name = exercise.name
            newexercise.workoutTemplate = newTrainingPatern
            exercises.append(newexercise)
        })
        newTrainingPatern.addToExercises(NSSet(array: exercises))
        saveContext()
    }
    
    func addWorkoutTemplate(title: String) -> WorkoutTemplateMO {
        let newTrainingPatern = WorkoutTemplateMO(context: context)
        newTrainingPatern.name = title
        newTrainingPatern.date = Date()
        saveContext()
        return newTrainingPatern
    }
    
    func renameWorkoutTemplae(workoutTemplate: WorkoutTemplateMO, for name: String) -> WorkoutTemplateMO {
        workoutTemplate.name = name
        saveContext()
        return workoutTemplate
    }
    
    func updateWorkoutTemplatesList(from workoutTemplates: [TrainingPaternCodableModel]) {
        workoutTemplates.forEach({ template in
            let newPatern = WorkoutTemplateMO(context: self.context)
            newPatern.name = template.name
            newPatern.date = template.date
            template.exerciseArray.forEach({ exercise in
                let newExercise = ExerciseMO(context: self.context)
                newExercise.name = exercise.name
                newExercise.subgroupName = exercise.subgroupName
                newExercise.groupName = exercise.groupName
                newExercise.id = exercise.id.int64
                newExercise.workoutTemplate = newPatern
                newExercise.date = newPatern.date
                newPatern.addToExercises(newExercise)
            })
        })
        saveContext()
    }
    
    func deleteWorkoutTemplate(workoutTemplate: WorkoutTemplateMO) {
        context.delete(workoutTemplate)
        saveContext()
    }
}
