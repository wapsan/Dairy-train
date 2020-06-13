
import Foundation

class ProfileInfoFileManager {
    
    static let shared = ProfileInfoFileManager()
    
    //MARK: - Private properties
    private var directoryURL: URL
    private lazy var strinPath = "profileInfo"
    private var _profileInfo: ProfileInfoModel?
    
    //MARK: - Properties
    var profileInfo: ProfileInfoModel? {
        self.readData()
        return self._profileInfo
    }
    
    var encodedProfileInfo: Data?
    
    //MARK: - Initialization
    init() {
        self.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    //MARK: - Private methods
    private func writeData() {
        let localPath = self.directoryURL.appendingPathComponent(self.strinPath) as URL?
        if let filePath = localPath, let model = self._profileInfo,
            let encodeData = try? JSONEncoder().encode(model) {
            do {
                self.encodedProfileInfo = encodeData
                try encodeData.write(to: filePath)
                print("Data successfully saved.")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func readData() {
        let localPath = self.directoryURL.appendingPathComponent(self.strinPath) as URL?
        if let filePath = localPath,
            let data = FileManager.default.contents(atPath: filePath.path),
            let profileInfo = try? JSONDecoder().decode(ProfileInfoModel.self, from: data) {
            self._profileInfo = profileInfo
            print("Data successfully read.")
        } else {
            self._profileInfo = ProfileInfoModel()
        }
    }
    
    //MARK: - Public methods
    func writeAge(to age: Int) {
        self._profileInfo?.age = age
        self.writeData()
    }
    
    func writeHeight(to height: Double) {
        self._profileInfo?.height = height
        self.writeData()
    }
    
    func writeWeight(to weight: Double) {
        self._profileInfo?.weight = weight
        self.writeData()
    }
    
    func writeGender(to gender: ProfileInfoModel.Gender) {
        self._profileInfo?.gender = gender
        self.writeData()
    }
    
    func writeActivityLevel(to activityLevel: ProfileInfoModel.ActivityLevel) {
        self._profileInfo?.activityLevel = activityLevel
        self.writeData()
    }
}
