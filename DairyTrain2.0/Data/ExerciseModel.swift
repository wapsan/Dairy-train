import UIKit

class ExersiceModel {
    
    //MARK: - Properties
    var listOfExercices: [Exercise] = []
    
    //MARK: - Private methods
    private func setUpExercices(for muscleSubgroup: MuscleSubgroup.Subgroup) {
        switch muscleSubgroup {
        case .frontDelts:
            self.listOfExercices = [Exercise(name: "Barbell press", subgroup: muscleSubgroup),
                                    Exercise(name: "Military press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell front raise",  subgroup: muscleSubgroup),
                                    Exercise(name: "Arnold press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Cable front raise",  subgroup: muscleSubgroup),
                                    Exercise(name: "Cable lateral Raise",  subgroup: muscleSubgroup)]
        case .middleDelts:
            self.listOfExercices = [Exercise(name: "Barbell overhead press", subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Press", subgroup: muscleSubgroup),
                                    Exercise(name: "Seated dumbbell press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell lateral raise",  subgroup: muscleSubgroup),
                                    Exercise(name: "Barbell upright row",  subgroup: muscleSubgroup),
                                    Exercise(name: "Cable upright row",  subgroup: muscleSubgroup),
                                    Exercise(name: "Machine Shoulder Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Machine Rear-Delt Fly",  subgroup: muscleSubgroup)]
        case .rearDelts:
            self.listOfExercices = [Exercise(name: "Dumbbell back raise",  subgroup: muscleSubgroup),
                                    Exercise(name: "Reverse pec deck fly",  subgroup: muscleSubgroup),]
        case .upperChest:
            self.listOfExercices = [Exercise(name: "Incline Barbell Bench Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Incline Dumbbell Bench Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Incline Dumbbell Flye",  subgroup: muscleSubgroup),
                                    Exercise(name: "Smith Machine Incline Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Machine Incline Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Pull-Over",  subgroup: muscleSubgroup),
                                    Exercise(name: "Low-Cable Crossover",  subgroup: muscleSubgroup),
            ]
        case .middleChest:
            self.listOfExercices = [Exercise(name: "Barbell Bench Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Bench Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Flye",  subgroup: muscleSubgroup),
                                    Exercise(name: "Smith Machine Press", subgroup: muscleSubgroup),
                                    Exercise(name: "Machine Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Pec-Deck Machine", subgroup: muscleSubgroup),
                                    Exercise(name: "Pushups",  subgroup: muscleSubgroup)
            ]
        case .lowerChest:
            self.listOfExercices = [Exercise(name: "Decline Barbell Bench Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Decline Dumbell Bench Press", subgroup: muscleSubgroup),
                                    Exercise(name: "Decline Dumbbell Flye",  subgroup: muscleSubgroup),
                                    Exercise(name: "Smith Machine Decline Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Machine Decline Press",  subgroup: muscleSubgroup),
                                    Exercise(name: "Dips For Chest",  subgroup: muscleSubgroup),
                                    Exercise(name: "Cable Crossover",  subgroup: muscleSubgroup)
                
            ]
        case .biceps:
            self.listOfExercices = [Exercise(name: "Barbell Biceps Curl",  subgroup: muscleSubgroup),
                                    Exercise(name: "Standing Dumbbell Biceps Curl",  subgroup: muscleSubgroup),
                                    Exercise(name: "Standing Hummer curl",  subgroup: muscleSubgroup),
                                    Exercise(name: "Seating Hummer curl",  subgroup: muscleSubgroup),
                                    Exercise(name: "EZ-Bar Biceps Curl",  subgroup: muscleSubgroup),
                                    Exercise(name: "Incline Dumbbell Curl",  subgroup: muscleSubgroup),
                                    Exercise(name: "Decline Dumbbell Curl",  subgroup: muscleSubgroup),
                                    Exercise(name: "Concentration Biceps Curl",  subgroup: muscleSubgroup),
                                    Exercise(name: "Overhead Cable Curl", subgroup: muscleSubgroup)]
        case .triceps:
            break
        case .frontSideHip:
            break
        case .backSideHip:
            break
        case .calves:
            break
        case .abs:
            break
        case .lowBack:
            break
        case .latissimusDorsi:
            break
        case .trapezoid:
            break
        }
    }
    
    //MARK: - Initialization
    init(for group: MuscleSubgroup.Subgroup) {
        self.setUpExercices(for: group)
    }
    
    deinit {
        print("exercice model destroyde")
    }
    
}



