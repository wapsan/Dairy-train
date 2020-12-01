//
//  MapableProtocol.swift
//  Dairy Training
//
//  Created by cogniteq on 30.11.2020.
//  Copyright © 2020 Вячеслав. All rights reserved.
//

import Foundation

protocol Mapable: Codable {
     func mapToJSON() -> String?
}

extension Mapable {
    
    func mapToJSON() -> String? {
        do {
            let data = try JSONEncoder().encode(self)
            let JSONString = String(data: data, encoding: .utf8)
            return JSONString
        } catch {
            return nil
        }
    }
}
