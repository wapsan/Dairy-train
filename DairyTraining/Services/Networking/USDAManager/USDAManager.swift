import Foundation
import Alamofire

fileprivate struct Value {
    static let apiKey = "EfeCDmy0q1mfdGdMCUr4CJew6qmbLGWN3POeAnl7"
    static let resultPerPage = "20"
}

fileprivate struct Key {
    static let apiKey = "api_key"
    static let searchignText = "query"
    static let resultPerPage = "pageSize"
    static let pageNumber = "pageNumber"
}

final class USDAManager {
    
    // MARK: - Error types
    enum NetWorkError: String, Error {
        case parseError = "Parse error" //Debug error type
        case noResponse = "Sorry, we could not find what you are looking for."
        case noInternetConnection = "Please, check your interntet connection."
        case unknownError = "Something went wrong."
        
        var message: String {
            return self.rawValue
        }
    }
    
    // MARK: - Private properties
    private let baseURL = "https://api.nal.usda.gov/fdc/v1/foods/search"
    private lazy var parameters = [Key.apiKey: Value.apiKey, Key.resultPerPage: Value.resultPerPage]
    private var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    // MARK: - Public methods
    func searchFoodWithName(_ foodName: String,
                            pageNumber: Int = 1,
                            completion: @escaping (Result<FoodResponseModel, NetWorkError>) -> Void) {
        parameters[Key.searchignText] = convertSearchingText(text: foodName)
        parameters[Key.pageNumber] = String(pageNumber)
        
        AF.request(baseURL, parameters: parameters).responseJSON { [weak self] (response) in
            guard let self = self else { return }
            
            do {
                let responseModel = try self.excludeErrors(for: response)
                completion(.success(responseModel))
            } catch {
                guard let error = error as? NetWorkError else { completion(.failure(.unknownError)); return }
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private helpers methods
    private func excludeErrors(for response: AFDataResponse<Any>) throws -> FoodResponseModel {
        guard self.isConnectedToInternet else { throw NetWorkError.noInternetConnection }
        
        guard let data = response.data else { throw NetWorkError.noResponse }
        
        guard let responseModel = try? JSONDecoder().decode(FoodResponseModel.self, from: data) else {
            throw NetWorkError.parseError
        }
        
        guard !responseModel.foods.isEmpty else { throw NetWorkError.noResponse }
        
        return responseModel
    }
    
    private func convertSearchingText(text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "%20")
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
