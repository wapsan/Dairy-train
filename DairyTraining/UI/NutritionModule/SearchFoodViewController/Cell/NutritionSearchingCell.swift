import UIKit

protocol FoodPresentable {
    var foodName: String { get }
    var kkal: String { get }
    var displayProteins: String { get }
    var displayCarbohydrate: String { get }
    var displayFat: String { get }
    var foodWeight: String? { get }
}

extension Food: FoodPresentable {
    
    var foodWeight: String? {
        return nil
    }

    var proteins: Double {
        guard let protein = foodNutrients.first(where: {$0.nutrientId == 1003}) else { return 0 }
        return protein.value ?? 0
    }
    
    var carbohydrates: Double {
        guard let carbohydrates = foodNutrients.first(where: {$0.nutrientId == 1005}) else { return 0 }
        return carbohydrates.value ?? 0
    }
    
    var fats: Double {
        guard let fats = foodNutrients.first(where: {$0.nutrientId == 1004}) else { return 0 }
        return fats.value ?? 0
    }
    
    var calories: Double {
        guard let calories = foodNutrients.first(where: {$0.nutrientId == 1008}) else { return 0 }
        return calories.value ?? 0
    }
    
    
    var foodName: String {
        return lowercaseDescription?.capitalized ?? ""
    }
    
    var kkal: String {
        return String(format: "Kkal: %.02f", calories).capitalized
    }
    
    var displayProteins: String {
        return String(format: "Proteins: %.02f", proteins).capitalized
    }
    
    var displayCarbohydrate: String {
        return String(format: "Carbohydrates: %.02f", carbohydrates).capitalized
    }
    
    var displayFat: String {
        return String(format: "Fats: %.02f", fats).capitalized
    }
}

final class NutritionSearchingCell: UITableViewCell {

    // MARK: - Cell properties
    static let cellID = "NutritionSearchingCell"
    static let xibName = "NutritionSearchingCell"
    
    // MARK: - @IBOutlets
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var foodNameLabel: UILabel!
    @IBOutlet private var kkalLabel: UILabel!
    @IBOutlet private var proteinLabel: UILabel!
    @IBOutlet private var fatLabel: UILabel!
    @IBOutlet private var carbohydratesLabel: UILabel!
    @IBOutlet private var weightLabel: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
  
    // MARK: - Setup
    private func setup() {
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = DTColors.controllBorderColor.cgColor
        selectionStyle = .none
    }
    
    // MARK: - Setter
    func setupCell(for food: FoodPresentable) {
        weightLabel.isHidden = food.foodWeight == nil
        weightLabel.text = food.foodWeight
        foodNameLabel.text = food.foodName
        kkalLabel.text = food.kkal
        proteinLabel.text = food.displayProteins
        carbohydratesLabel.text = food.displayCarbohydrate
        fatLabel.text = food.displayFat
    }
}
