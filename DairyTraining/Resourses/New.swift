//
//  New.swift
//  Dairy Training
//
//  Created by cogniteq on 25.06.21.
//  Copyright © 2021 Вячеслав. All rights reserved.
//

import Foundation
struct ExerciseData: Codable {
    let muscularGroups: [MuscularGroup]
    
    enum CodingKeys: String, CodingKey {
        case muscularGroups = "muscular_groups"
    }
}

struct MuscularGroup: Codable {
    let name: String
    let muscularSubgroup: [MuscularSubgroup]
    
    enum CodingKeys: String, CodingKey {
        case muscularSubgroup = "muscular_subgroups"
        case name
    }
}

struct MuscularSubgroup: Codable {
    let name: String
    let exercise: [NewExercise]
}

struct NewExercise: Codable {
    let name: String
}

struct Parser {
    
    static func getData() {
        print("Start get Data")
        guard let url = Bundle.main.url(forResource: "SomeResourse", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(ExerciseData.self, from: data)
            print("End get Data")
        } catch let error {
            print(error)
        }
    }
    
}
