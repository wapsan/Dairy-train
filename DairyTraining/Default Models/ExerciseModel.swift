import UIKit

class ExersiceModel {
    
    //MARK: - Properties
    private(set) var listOfExercices: [Exercise] = []
    
    //MARK: - Private methods
//    private func setUpExercices(for muscleSubgroup: MuscleSubgroup.Subgroup) {
//        switch muscleSubgroup {
//        case .frontDelts:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Barbell press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Military press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Dumbbell front raise", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Arnold press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Cable front raise", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Cable lateral Raise", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .middleDelts:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Barbell overhead press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Dumbbell Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Seated dumbbell press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Dumbbell lateral raise", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Barbell upright row", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Cable upright row", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Machine Shoulder Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Machine Rear-Delt Fly", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .rearDelts:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Dumbbell back raise", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Reverse pec deck fly", comment: ""),
//                                             subgroup: muscleSubgroup),]
//        case .upperChest:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Incline Barbell Bench Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Incline Dumbbell Bench Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Incline Dumbbell Flye", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Smith Machine Incline Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Machine Incline Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Dumbbell Pull-Over", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Low-Cable Crossover", comment: ""),
//                                             subgroup: muscleSubgroup),]
//        case .middleChest:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Barbell Bench Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Dumbbell Bench Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Dumbbell Flye", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Smith Machine Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Machine Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Pec-Deck Machine", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Pec-Deck Machine", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .lowerChest:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Decline Barbell Bench Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Decline Dumbell Bench Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Decline Dumbbell Flye", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Smith Machine Decline Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Machine Decline Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Dips For Chest", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Cable Crossover", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .biceps:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Barbell Biceps Curl", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Standing Dumbbell Biceps Curl", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Standing Hummer curl", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Seating Hummer curl", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("EZ-Bar Biceps Curl", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Incline Dumbbell Curl", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Decline Dumbbell Curl", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Concentration Biceps Curl", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Overhead Cable Curl", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .triceps:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Close-grip Bench Press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Skullcrusher", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Tricep Dips", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Triceps Dip Machine", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Overhead Triceps Extension", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Cable Push-Down", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Kickbacks", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Bar Push-Down", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Diamond Push-Ups", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Bench Dip", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("One-Arm Overhead Extension", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .frontSideHip:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Barbell Squat", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Front Squat", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Leg press", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Walking Lunge", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Hack Squat", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Leg Extension", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("One Leg Extension", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Bulgarian Split Squat", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Bulgarian Split Squat", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .backSideHip:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Deadlift", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Romanian Deadlift", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Single Leg Deadlift", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Leg Curl", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Single Leg Curl", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Hip Thruster", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Sumo Squat", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .calves:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Machine Standing Calf Raise", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Dumbbell Calf Raise", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Barbell Calf Raises", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Single Leg Calf Raise", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Donkey Calf Raises", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Seated Calf Raise Machine", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Calf Press", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .abs:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("High Crunches", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Bicycle Crunches", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Leg Rises", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Rised Legs Hold", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Flutter Kicks", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Scissors", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Plank", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Hanging Leg Raise", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Hanging Knee Raise Twist", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Hanging Knee Raise", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .lowBack:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Hyperextensions", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Good Morning", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Deficit Deadlift", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Bridges", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .latissimusDorsi:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Pull-ups", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Barbell Row", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Reverse-Grip Barbell Row", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Single-Arm Dumbbell Row", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Landmine Row", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Dumbbell Pullover", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Single-Arm Cable Row", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Seated Low-Cable Row", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Lat Pull-down", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Reverse-Grip Lat Pull-Down", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Close-Grip Lat Pull-Down", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        case .trapezoid:
//            self.listOfExercices = [Exercise(name: NSLocalizedString("Barbell Shrug", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Barbell Behind-the-Back Shrug", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Dumbbell Shrug", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Incline Dumbbell Shrug", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Snatch-Grip Barbell High Pull", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Upright Row", comment: ""),
//                                             subgroup: muscleSubgroup),
//                                    Exercise(name: NSLocalizedString("Farmer's Carry", comment: ""),
//                                             subgroup: muscleSubgroup)]
//        }
//    }
    
    private func setUpExercices(for muscleSubgroup: MuscleSubgroup.Subgroup) {
        switch muscleSubgroup {
        case .frontDelts:
            self.listOfExercices = [Exercise(name: "Barbell press", subgroup: muscleSubgroup),
                                    Exercise(name: "Military press", subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell front raise", subgroup: muscleSubgroup),
                                    Exercise(name: "Arnold press", subgroup: muscleSubgroup),
                                    Exercise(name: "Cable front raise",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Cable lateral Raise",
                                             subgroup: muscleSubgroup)]
        case .middleDelts:
            self.listOfExercices = [Exercise(name: "Barbell overhead press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Seated dumbbell press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell lateral raise",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Barbell upright row",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Cable upright row",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Machine Shoulder Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Machine Rear-Delt Fly",
                                             subgroup: muscleSubgroup)]
        case .rearDelts:
            self.listOfExercices = [Exercise(name: "Dumbbell back raise",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Reverse pec deck fly",
                                             subgroup: muscleSubgroup),]
        case .upperChest:
            self.listOfExercices = [Exercise(name: "Incline Barbell Bench Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Incline Dumbbell Bench Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Incline Dumbbell Flye",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Smith Machine Incline Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Machine Incline Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Pull-Over",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Low-Cable Crossover",
                                             subgroup: muscleSubgroup),]
        case .middleChest:
            self.listOfExercices = [Exercise(name: "Barbell Bench Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Bench Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Flye",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Smith Machine Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Machine Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Pec-Deck Machine",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Pec-Deck Machine",
                                             subgroup: muscleSubgroup)]
        case .lowerChest:
            self.listOfExercices = [Exercise(name: "Decline Barbell Bench Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Decline Dumbell Bench Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Decline Dumbbell Flye",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Smith Machine Decline Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Machine Decline Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Dips For Chest",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Cable Crossover",
                                             subgroup: muscleSubgroup)]
        case .biceps:
            self.listOfExercices = [Exercise(name: "Barbell Biceps Curl",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Standing Dumbbell Biceps Curl",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Standing Hummer curl",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Seating Hummer curl",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "EZ-Bar Biceps Curl",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Incline Dumbbell Curl",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Decline Dumbbell Curl",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Concentration Biceps Curl",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Overhead Cable Curl",
                                             subgroup: muscleSubgroup)]
        case .triceps:
            self.listOfExercices = [Exercise(name: "Close-grip Bench Press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Skullcrusher",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Tricep Dips",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Triceps Dip Machine",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Overhead Triceps Extension",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Cable Push-Down",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Kickbacks",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Bar Push-Down",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Diamond Push-Ups",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Bench Dip",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "One-Arm Overhead Extension",
                                             subgroup: muscleSubgroup)]
        case .frontSideHip:
            self.listOfExercices = [Exercise(name: "Barbell Squat",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Front Squat",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Leg press",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Walking Lunge",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Hack Squat",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Leg Extension",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "One Leg Extension",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Bulgarian Split Squat",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Bulgarian Split Squat",
                                             subgroup: muscleSubgroup)]
        case .backSideHip:
            self.listOfExercices = [Exercise(name: "Deadlift",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Romanian Deadlift",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Single Leg Deadlift",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Leg Curl",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Single Leg Curl",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Hip Thruster",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Sumo Squat",
                                             subgroup: muscleSubgroup)]
        case .calves:
            self.listOfExercices = [Exercise(name: "Machine Standing Calf Raise",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Calf Raise",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Barbell Calf Raises",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Single Leg Calf Raise",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Donkey Calf Raises",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Seated Calf Raise Machine",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Calf Press",
                                             subgroup: muscleSubgroup)]
        case .abs:
            self.listOfExercices = [Exercise(name: "High Crunches",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Bicycle Crunches",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Leg Rises",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Rised Legs Hold",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Flutter Kicks",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Scissors",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Plank",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Hanging Leg Raise",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Hanging Knee Raise Twist",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Hanging Knee Raise",
                                             subgroup: muscleSubgroup)]
        case .lowBack:
            self.listOfExercices = [Exercise(name: "Hyperextensions",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Good Morning",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Deficit Deadlift",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Bridges",
                                             subgroup: muscleSubgroup)]
        case .latissimusDorsi:
            self.listOfExercices = [Exercise(name: "Pull-ups",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Barbell Row",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Reverse-Grip Barbell Row",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Single-Arm Dumbbell Row",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Landmine Row",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Pullover",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Single-Arm Cable Row",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Seated Low-Cable Row",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Lat Pull-down",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Reverse-Grip Lat Pull-Down",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Close-Grip Lat Pull-Down",
                                             subgroup: muscleSubgroup)]
        case .trapezoid:
            self.listOfExercices = [Exercise(name: "Barbell Shrug",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Barbell Behind-the-Back Shrug",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Shrug",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Incline Dumbbell Shrug",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Snatch-Grip Barbell High Pull",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Upright Row",
                                             subgroup: muscleSubgroup),
                                    Exercise(name: "Farmer's Carry",
                                             subgroup: muscleSubgroup)]
        }
    }
    
    //MARK: - Initialization
    init(for group: MuscleSubgroup.Subgroup) {
        self.setUpExercices(for: group)
    }
}
