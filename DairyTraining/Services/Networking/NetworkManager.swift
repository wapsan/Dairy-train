import Foundation
import Alamofire

fileprivate struct ParameterValue {
    static let appID = "10ae56e1"
    static let appKey = "d5a44b1e39809c184c29397c53a1a4af"
}

fileprivate struct ParameterKey {
    static let appID = "app_id"
    static let appKey = "app_key"
    static let ingridients = "ingr"
}
 
final class NetworkManager {
    
    // MARK: - Singletone fields
    static let shared = NetworkManager()
    private init() { }
    
    // MARK: - Private Properties
    private let baseURL = "https://api.edamam.com/api/food-database/v2/parser"
    private lazy var parameters = [ParameterKey.appID: ParameterValue.appID,
                                   ParameterKey.appKey: ParameterValue.appKey]
    
    // MARK: - Public methods
    func requestNutritionInfo(for ingridiend: String, comletion: @escaping  ((Result<NutritionResponseModel, Error>)-> Void)) {
        parameters[ParameterKey.ingridients] = convertSearchingText(text: ingridiend)
        AF.request(baseURL, parameters: parameters).responseJSON { (response) in
            print(response)
            guard let responseData = response.data else {
                print("No data in response")
                  return
            }
            guard let responseModle = try? JSONDecoder().decode(NutritionResponseModel.self, from: responseData) else {
                print("Parsing error")
                return
            }
            comletion(.success(responseModle))
        }
    }
    
    // MARK: - Private methods
    private func convertSearchingText(text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "%20")
    }
}
