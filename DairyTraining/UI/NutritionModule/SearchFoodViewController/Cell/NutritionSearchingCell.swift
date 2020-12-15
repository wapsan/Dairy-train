import UIKit

protocol FoodPresentable {
    var foodName: String { get }
    var kkal: String { get }
    var proteins: String { get }
    var carbohydrate: String { get }
    var fat: String { get }
}

extension Food: FoodPresentable {
    var foodName: String {
        return label.capitalized
    }
    
    var kkal: String {
        return String(format: "Kkal: %.02f", nutrients.kkal).capitalized
    }
    
    var proteins: String {
        return String(format: "Proteins: %.02f", nutrients.proteins).capitalized
    }
    
    var carbohydrate: String {
        return String(format: "Carbohydrates: %.02f", nutrients.carbohydrates).capitalized
    }
    
    var fat: String {
        return String(format: "Fats: %.02f", nutrients.fat).capitalized
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
        foodNameLabel.text = food.foodName
        kkalLabel.text = food.kkal
        proteinLabel.text = food.proteins
        carbohydratesLabel.text = food.carbohydrate
        fatLabel.text = food.fat
    }
}
