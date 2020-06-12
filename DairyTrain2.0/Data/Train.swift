import UIKit




class Train {

    //MARK: - Properties
    var exercises: [Exercise] = []
    var exercicesSet = Set<String>()
    var dateTittle: String
    var subgroupInCurrentTrain: [MuscleSubgroup.Subgroup] {
        var subgroups: [MuscleSubgroup.Subgroup] = []
        var subgroupsSet = Set<MuscleSubgroup.Subgroup>()
        for exercice in self.exercises {
            let subgroup = exercice.subgroub
            if subgroupsSet.insert(subgroup).inserted {
                subgroups.append(subgroup)
            }
        }
        return subgroups
    }
    var groupsInCurrentTrain: [MuscleGroup.Group] {
        var groups: [MuscleGroup.Group] = []
        var gropSet = Set<MuscleGroup.Group>()
        for exercise in self.exercises {
            let group = exercise.group
            if gropSet.insert(group).inserted {
                groups.append(group)
            }
        }
        return groups
    }
    
    
    

    //MARK: - Publick methods
    func addExercises(_ exercices: [Exercise]) {
        var newExercices: [Exercise] = []
        for execrice in exercices {
            if self.exercicesSet.insert(execrice.name).inserted {
                newExercices.append(execrice)
            }
        }
        self.exercises += newExercices
    }
    
    func addExercise(_ exercice: Exercise) {
        if self.exercicesSet.insert(exercice.name).inserted {
            self.exercises.append(exercice)
        }
    }
    
    func removeExercice() {
        self.exercises.removeLast()
    }
    
    func removeExerciceFrom(_ index: Int) {
        self.exercises.remove(at: index)
    }
    
    func moveExerciceFrom(_ firstIndex: Int, to secondIndex: Int) {
        let arrayRange = (0..<self.exercises.count)
        guard arrayRange.contains(firstIndex) && arrayRange.contains(secondIndex) else { return }
        
        let secondElement = self.exercises[secondIndex]
        let firstElement = self.exercises[firstIndex]
        
        self.exercises.remove(at: secondIndex)
        self.exercises.insert(firstElement, at: secondIndex)

        self.exercises.remove(at: firstIndex)
        self.exercises.insert(secondElement, at: firstIndex)
    }
    
    
    //MARK: - Private methods
    func initializationWit(date: String, and exercices: [Exercise]) {
        if date == DateHelper.shared.currnetDate {
            
        }
    }
    
    init(with exercices: [Exercise]) {
        self.exercises += exercices
        self.dateTittle = DateHelper.shared.currnetDate
        for exercice in exercices {
            self.exercicesSet.insert(exercice.name)
        }
    }
        
}
