import Foundation

extension String {
    
    func isBlank() -> Bool {
        let newString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if newString.isEmpty {
            return true
        } else {
            return false
        }
    }
}
