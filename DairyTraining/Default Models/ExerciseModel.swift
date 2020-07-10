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
            self.listOfExercices = [Exercise(name: "Close-grip Bench Press", subgroup: muscleSubgroup),
                                    Exercise(name: "Skullcrusher", subgroup: muscleSubgroup),
                                    Exercise(name: "Tricep Dips", subgroup: muscleSubgroup),
                                    Exercise(name: "Triceps Dip Machine", subgroup: muscleSubgroup),
                                    Exercise(name: "Overhead Triceps Extension", subgroup: muscleSubgroup),
                                    Exercise(name: "Cable Push-Down", subgroup: muscleSubgroup),
                                    Exercise(name: "Kickbacks", subgroup: muscleSubgroup),
                                    Exercise(name: "Bar Push-Down", subgroup: muscleSubgroup),
                                    Exercise(name: "Diamond Push-Ups", subgroup: muscleSubgroup),
                                    Exercise(name: "Bench Dip", subgroup: muscleSubgroup),
                                    Exercise(name: "One-Arm Overhead Extension", subgroup: muscleSubgroup)]
        case .frontSideHip:
            self.listOfExercices = [Exercise(name: "Barbell Squat", subgroup: muscleSubgroup),
                                    Exercise(name: "Front Squat", subgroup: muscleSubgroup),
                                    Exercise(name: "Leg press", subgroup: muscleSubgroup),
                                    Exercise(name: "Walking Lunge", subgroup: muscleSubgroup),
                                    Exercise(name: "Hack Squat", subgroup: muscleSubgroup),
                                    Exercise(name: "Leg Extension", subgroup: muscleSubgroup),
                                    Exercise(name: "One Leg Extension", subgroup: muscleSubgroup),
                                    Exercise(name: "Bulgarian Split Squat", subgroup: muscleSubgroup),
                                    Exercise(name: "Pistol Squat", subgroup: muscleSubgroup)]
        case .backSideHip:
            self.listOfExercices = [Exercise(name: "Deadlift", subgroup: muscleSubgroup),
                                    Exercise(name: "Romanian Deadlift", subgroup: muscleSubgroup),
                                    Exercise(name: "Single Leg Deadlift", subgroup: muscleSubgroup),
                                    Exercise(name: "Leg Curl", subgroup: muscleSubgroup),
                                    Exercise(name: "Single Leg Curl", subgroup: muscleSubgroup),
                                    Exercise(name: "Hip Thruster", subgroup: muscleSubgroup),
                                    Exercise(name: "Sumo Squat", subgroup: muscleSubgroup)]
        case .calves:
            self.listOfExercices = [Exercise(name: "Machine Standing Calf Raise", subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Calf Raise", subgroup: muscleSubgroup),
                                    Exercise(name: "Barbell Calf Raises", subgroup: muscleSubgroup),
                                    Exercise(name: "Single Leg Calf Raise", subgroup: muscleSubgroup),
                                    Exercise(name: "Donkey Calf Raises", subgroup: muscleSubgroup),
                                    Exercise(name: "Seated Calf Raise Machine", subgroup: muscleSubgroup),
                                    Exercise(name: "Calf Press", subgroup: muscleSubgroup)]
        case .abs:
            self.listOfExercices = [Exercise(name: "High Crunches", subgroup: muscleSubgroup),
                                    Exercise(name: "Bicycle Crunches", subgroup: muscleSubgroup),
                                    Exercise(name: "Leg Rises", subgroup: muscleSubgroup),
                                    Exercise(name: "Rised Legs Hold", subgroup: muscleSubgroup),
                                    Exercise(name: "Flutter Kicks", subgroup: muscleSubgroup),
                                    Exercise(name: "Scissors", subgroup: muscleSubgroup),
                                    Exercise(name: "Plank", subgroup: muscleSubgroup),
                                    Exercise(name: "Hanging Leg Raise", subgroup: muscleSubgroup),
                                    Exercise(name: "Hanging Knee Raise Twist", subgroup: muscleSubgroup),
                                    Exercise(name: "Hanging Knee Raise", subgroup: muscleSubgroup)]
        case .lowBack:
            self.listOfExercices = [Exercise(name: "Hyperextensions", subgroup: muscleSubgroup),
                                    Exercise(name: "Good Morning", subgroup: muscleSubgroup),
                                    Exercise(name: "Deficit Deadlift", subgroup: muscleSubgroup),
                                    Exercise(name: "Bridges", subgroup: muscleSubgroup)]
        case .latissimusDorsi:
            self.listOfExercices = [Exercise(name: "Pull-ups", subgroup: muscleSubgroup),
                                    Exercise(name: "Barbell Row", subgroup: muscleSubgroup),
                                    Exercise(name: "Reverse-Grip Barbell Row", subgroup: muscleSubgroup),
                                    Exercise(name: "Single-Arm Dumbbell Row", subgroup: muscleSubgroup),
                                    Exercise(name: "Landmine Row", subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Pullover", subgroup: muscleSubgroup),
                                    Exercise(name: "Single-Arm Cable Row", subgroup: muscleSubgroup),
                                    Exercise(name: "Seated Low-Cable Row", subgroup: muscleSubgroup),
                                    Exercise(name: "Lat Pull-down", subgroup: muscleSubgroup),
                                    Exercise(name: "Reverse-Grip Lat Pull-Down", subgroup: muscleSubgroup),
                                    Exercise(name: "Close-Grip Lat Pull-Down", subgroup: muscleSubgroup)]
        case .trapezoid:
            self.listOfExercices = [Exercise(name: "Barbell Shrug", subgroup: muscleSubgroup),
                                    Exercise(name: "Barbell Behind-the-Back Shrug", subgroup: muscleSubgroup),
                                    Exercise(name: "Dumbbell Shrug", subgroup: muscleSubgroup),
                                    Exercise(name: "Incline Dumbbell Shrug", subgroup: muscleSubgroup),
                                    Exercise(name: "Snatch-Grip Barbell High Pull", subgroup: muscleSubgroup),
                                    Exercise(name: "Upright Row", subgroup: muscleSubgroup),
                                    Exercise(name: "Farmer's Carry", subgroup: muscleSubgroup)]
        }
    }
    
    //MARK: - Initialization
    init(for group: MuscleSubgroup.Subgroup) {
        self.setUpExercices(for: group)
    }
}
