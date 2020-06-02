extension String {
    func getSeparatedName() -> (name: String, lastName: String) {
        let buffArray = self.split(separator: " ")
        let name = String(buffArray[0])
        let secondName = String(buffArray[1])
        return (name,secondName)
    }
    
}
