import UIKit
import EFCountingLabel

final class NutritionMainCell: UITableViewCell {

    // MARK: - Cell properties
    static let cellID = "NutritionMainCell"
    static let xibName = "NutritionMainCell"
    
    // MARK: - @IBOutlets
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var caloriesProgressView: UIView!
    @IBOutlet private var proteinsProgressView: UIView!
    @IBOutlet private var carbohydratesProgressView: UIView!
    @IBOutlet private var fatsProgressView: UIView!
    
    @IBOutlet private var caloriesCountLabel: EFCountingLabel!
    @IBOutlet private var carbohydratesCrammsLabel: UILabel!
    @IBOutlet private var proteinsGrammsLabel: UILabel!
    @IBOutlet private var fatsGrammsLabel: UILabel!
    @IBOutlet private var caloriesLimitLabel: UILabel!
    
    @IBOutlet private var proteinProgressLabel: EFCountingLabel!
    @IBOutlet private var carbohydratesProgressLabel: EFCountingLabel!
    @IBOutlet private var fatsProgressLabel: EFCountingLabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Private methods
    func setCell(for recomendation: NutritionRecomendation?, and nutritionData: NutritionDataPresentable) {
        guard let recomendation = recomendation else {
            //FIXME: UPDATE IF USER INFO IS absent
            return }
        dateLabel.text = nutritionData.displayDate
        
        proteinsGrammsLabel.text = "\(nutritionData.displayProteins) / \(Int(recomendation.proteins))"
        carbohydratesCrammsLabel.text = "\(nutritionData.displayCarbohydrates) / \(Int(recomendation.carbohydtrates))"
        fatsGrammsLabel.text = "\(nutritionData.displayFats) / \(Int(recomendation.fats))"
   
        caloriesCountLabel.countFrom(0, to: CGFloat(nutritionData.calories), withDuration: 1)
        caloriesLimitLabel.text = "of \(Int(recomendation.calories))cal"
        
        let caloriesProgress = Float(nutritionData.calories/recomendation.calories)
        let proteinProgress = Float(nutritionData.proteins/recomendation.proteins)
        let carbohydratesProgress = Float(nutritionData.carbohydrates/recomendation.carbohydtrates)
        let fatsProgress = Float(nutritionData.fats/recomendation.fats)
        
        drawCaloriesProgress(for: caloriesProgress)
        drawProteinsProgress(for: proteinProgress)
        drawCarbohydratesProgress(for: carbohydratesProgress)
        drawFatsProgrees(for: fatsProgress)
        
        proteinProgressLabel.setUpdateBlock { (value, label) in
            label.text = String(format: "%.0f%%", value)
        }
        proteinProgressLabel.countFrom(0, to: CGFloat( Int(nutritionData.proteins / recomendation.proteins * 100)), withDuration: 1)
        
        carbohydratesProgressLabel.setUpdateBlock { (value, label) in
            label.text = String(format: "%.0f%%", value)
        }
        carbohydratesProgressLabel.countFrom(0, to: CGFloat( Int(nutritionData.carbohydrates / recomendation.carbohydtrates * 100)), withDuration: 1)
        
        fatsProgressLabel.setUpdateBlock { (value, label) in
            label.text = String(format: "%.0f%%", value)
        }
        fatsProgressLabel.countFrom(0, to: CGFloat( Int(nutritionData.fats / recomendation.fats * 100)), withDuration: 1)
    }

    // MARK: - Private methods
    private func setup() {
        selectionStyle = .none
    }
    
    private func drawCaloriesProgress(for value: Float) {
        let defaultLayer = CAShapeLayer()
        let progressLayer = CAShapeLayer()
        ProgressDrawer.drawProgress(progressLayer: progressLayer, defaultLayer: defaultLayer, for: caloriesProgressView, with: value)
    }
    
    private func drawProteinsProgress(for value: Float) {
        let defaultLayer = CAShapeLayer()
        let progressLayer = CAShapeLayer()
        ProgressDrawer.drawProgress(progressLayer: progressLayer, defaultLayer: defaultLayer, for: proteinsProgressView, with: value)
    }
    
    private func drawCarbohydratesProgress(for value: Float) {
        let defaultLayer = CAShapeLayer()
        let progressLayer = CAShapeLayer()
        ProgressDrawer.drawProgress(progressLayer: progressLayer, defaultLayer: defaultLayer, for: carbohydratesProgressView, with: value)
    }
    
    private func drawFatsProgrees(for value: Float) {
        let defaultLayer = CAShapeLayer()
        let progressLayer = CAShapeLayer()
        ProgressDrawer.drawProgress(progressLayer: progressLayer, defaultLayer: defaultLayer, for: fatsProgressView, with: value)
    }
}
