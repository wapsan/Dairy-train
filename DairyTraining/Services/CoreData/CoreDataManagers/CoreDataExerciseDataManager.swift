import Foundation
import CoreData

final class ExerciseDataBaseManager {
    
    private let dataModelName = "ExercisesDataModel"
    
    private lazy var persistantContainer: NSPersistentContainer = {
    
        let container = NSPersistentContainer(name: self.dataModelName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
   
    private lazy var context: NSManagedObjectContext = {
        return persistantContainer.viewContext
    }()
    
    func saveCSV() {
        guard let path = Bundle.main.path(forResource: "ExerciseDataBaseENG", ofType: "csv")
              else { return }
        let csvURL = URL(fileURLWithPath: path)
        guard let a = parseCSV(contentsOfURL: csvURL, encoding: .utf8) else { return }
        a.enumerated().forEach({ (index,exercise) in
            if index != 0 {
                print("Descriptopn: \(exercise.description)")
            } 
        })
    }
    
    func parseCSV (contentsOfURL: URL, encoding: String.Encoding) -> [(name:String, description: String)]? {
           // Load the CSV file and parse it
           let delimiter = ","
           
           var items:[(name:String, description: String)]?
           do {
               
               let content = try String(contentsOf:contentsOfURL as URL)
               items = []
               let lines:[String] = content.components(separatedBy: NSCharacterSet.newlines) as [String]
               
               for line in lines {
                   var values:[String] = []
                   if line != "" {
                       // For a line with double quotes
                       // we use NSScanner to perform the parsing
                       if line.range(of: "\"") != nil {
                           var textToScan:String = line
                           var value:NSString?
                           var textScanner:Scanner = Scanner(string: textToScan)
                           while textScanner.string != "" {
                               
                               if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                   textScanner.scanLocation += 1
                                   textScanner.scanUpTo("\"", into: &value)
                                   textScanner.scanLocation += 1
                               } else {
                                   textScanner.scanUpTo(delimiter, into: &value)
                               }
                               
                               // Store the value into the values array
                               values.append(value! as String)
                               
                               // Retrieve the unscanned remainder of the string
                               if textScanner.scanLocation < (textScanner.string.count) {
                                   textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                               } else {
                                   textToScan = ""
                               }
                               textScanner = Scanner(string: textToScan)
                           }
                           
                           // For a line without double quotes, we can simply separate the string
                           // by using the delimiter (e.g. comma)
                       } else  {
                           values = line.components(separatedBy:delimiter)
                       }
                       
                       // Put the values into the tuple and add it to the items array
                       let item = (name: values[0], description: values[1])
                       items?.append(item)
                   }
                   
               }
           } catch {
               print(error)
           }
           
           return items
       }
}
