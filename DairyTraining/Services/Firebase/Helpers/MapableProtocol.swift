import Foundation

protocol Mapable: Codable {
     func mapToJSON() -> String?
}

extension Mapable {
    
    func mapToJSON() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
