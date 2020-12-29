protocol CellRegistrable {
    static var cellID: String { get }
    static var xibName: String { get }
}

extension CellRegistrable {
    
    static var cellID: String {
        return String(describing: self)
    }
    
    static var xibName: String {
        return String(describing: self)
    }
}
