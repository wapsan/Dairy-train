import UIKit
import Charts

struct ExerciseStatisticsData {
    var date: Date
    var weight: Double?
    var reps: Double?
}

enum ExerciseSatisticType {
    case maxProjectileWeight(data: [ExerciseStatisticsData])
    case avarageProjectileWeight(data: [ExerciseStatisticsData])
    case summProjectileWeight(data: [ExerciseStatisticsData])
    
    var title: String {
        switch self {
        case .maxProjectileWeight:
            return "Max projectile weight"
        case .avarageProjectileWeight:
            return "Avarage projectile weight"
        case .summProjectileWeight:
            return "Sum projectile weight"
        }
    }
}

final class ExerciseStatisticsCell: UITableViewCell {

    //MARK: - Types
    
    
    //MARK: - Properties
    static let cellID = "ExerciseStatisticsCell"
    static let xibName = "ExerciseStatisticsCell"
    
    //MARK: - @IBOutlets
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var titleLabel: UILabel!
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    //MARK: - Setter
    private func configure() {
        contentView.backgroundColor = DTColors.backgroundColor
    }
    
    func setupCell(for exerciseStatisticsType: ExerciseSatisticType) {
        var a: [ChartDataEntry] = []
        switch exerciseStatisticsType {
        case .maxProjectileWeight(data: let data):
            guard !data.isEmpty else { return }
            data.enumerated().forEach({
                let dataEntry = ChartDataEntry(x: Double($0), y: $1.weight ??  Double(0))
                a.append(dataEntry)
            })
        case .avarageProjectileWeight(data: let data):
            guard !data.isEmpty else { return }
            data.enumerated().forEach({
                let dataEntry = ChartDataEntry(x: Double($0), y: $1.weight ??  Double(0))
                a.append(dataEntry)
            })
        case .summProjectileWeight(data: let data):
            guard !data.isEmpty else { return }
            data.enumerated().forEach({
                let dataEntry = ChartDataEntry(x: Double($0), y: $1.weight ??  Double(0))
                a.append(dataEntry)
            })
        }
        titleLabel.text = exerciseStatisticsType.title
        let b = LineChartDataSet(entries: a, label: "Weight, Kg")
       // b.entries.forEach({ entry })
    
        b.formSize = 20
        b.mode = .cubicBezier
        b.lineWidth = 2
        b.drawFilledEnabled = true
        b.circleRadius = 5
        b.circleHoleRadius = 2
        b.fillColor = DTColors.controllSelectedColor
        b.circleHoleColor = DTColors.backgroundColor
        b.circleColors = .init(repeating: DTColors.controllSelectedColor, count: a.count)
        b.colors = .init(repeating: DTColors.controllSelectedColor, count: 1)
        b.valueColors = .init(repeating: .white, count: a.count)
        b.valueFont = .systemFont(ofSize: 14)
        b.highlightEnabled = false
        let z = LineChartData(dataSet: b)
        //self.chartData = z
        //hartView.chartYMax += chartView.chartYMax * 1.1
        
        chartView.data = z
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false

        chartView.backgroundColor = DTColors.backgroundColor
        chartView.legend.textColor = .white
        chartView.setVisibleXRangeMaximum(7)
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        
        chartView.minOffset = 0
        
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
        chartView.extraLeftOffset = 16
        chartView.extraRightOffset = 16
        chartView.extraBottomOffset = 8
        chartView.borderLineWidth = 0
        
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelFont = .systemFont(ofSize: 15)
        chartView.xAxis.labelRotationAngle = -45
       // chartView.xAxis.valueFormatter =
        
        chartView.legend.font = .boldSystemFont(ofSize: 17)
        
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        
        
    }
    
    func setup(for data: LineChartData ) {
        chartView.data = data
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false

        chartView.backgroundColor = DTColors.backgroundColor
        chartView.legend.textColor = .white
        chartView.setVisibleXRangeMaximum(7)
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        
        chartView.extraBottomOffset = 8
        chartView.borderLineWidth = 0
        
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelFont = .systemFont(ofSize: 15)
        chartView.xAxis.labelRotationAngle = -45
       // chartView.xAxis.valueFormatter =
        
        chartView.legend.font = .boldSystemFont(ofSize: 17)
        
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
    }
}
