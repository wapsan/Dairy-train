import UIKit
import Charts

struct ExerciseStatisticsData {
    var date: Date
    var value: Double
}

enum ExerciseSatisticType {
    case maxProjectileWeight(data: [ExerciseStatisticsData])
    case avarageProjectileWeight(data: [ExerciseStatisticsData])
    case summProjectileWeight(data: [ExerciseStatisticsData])
    case avarageReps(data: [ExerciseStatisticsData])
    
    var title: String {
        switch self {
        case .maxProjectileWeight:
            return "Max projectile weight"
        case .avarageProjectileWeight:
            return "Avarage projectile weight"
        case .summProjectileWeight:
            return "Sum projectile weight"
        case .avarageReps:
            return "Avarage reps"
        }
    }
}

final class ExerciseStatisticsCell: UITableViewCell {

    //MARK: - Properties
    static let cellID = "ExerciseStatisticsCell"
    static let xibName = "ExerciseStatisticsCell"
    private lazy var dates: [Date] = []
    private lazy var legendTitle = ""
    
    //MARK: - @IBOutlets
    @IBOutlet private var chartView: LineChartView!
    @IBOutlet private var titleLabel: UILabel!
    
    //MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    //MARK: - Configure cell
    private func configure() {
        titleLabel.font = .boldSystemFont(ofSize: 17)
        selectionStyle = .none
        contentView.backgroundColor = DTColors.backgroundColor
    }
    
    // MARK: - Setter
    func setupCell(for exerciseStatisticsType: ExerciseSatisticType) {
        titleLabel.text = exerciseStatisticsType.title
        var entries: [ChartDataEntry] = []
        dates = []
        legendTitle = "Weight, kg"
        switch exerciseStatisticsType {
        case .avarageReps(let data):
            guard !data.isEmpty else { return }
            fillDataEntries(&entries, with: data)
            legendTitle = "Reps, count"
        case .maxProjectileWeight(data: let data):
            guard !data.isEmpty else { return }
            fillDataEntries(&entries, with: data)
        case .avarageProjectileWeight(data: let data):
            guard !data.isEmpty else { return }
            fillDataEntries(&entries, with: data)
        case .summProjectileWeight(data: let data):
            guard !data.isEmpty else { return }
            fillDataEntries(&entries, with: data)
        }
        guard !entries.isEmpty else { return }
        let lineChartDataSet = createLineChartDataSet(with: entries)
        setUpChartView(with: lineChartDataSet)
    }
    
    // MARK: - Private methods
    private func fillDataEntries(_ dataEnties: inout [ChartDataEntry], with data: [ExerciseStatisticsData]) {
        data.enumerated().forEach({
            dates.append($1.date)
            let dataEntry = ChartDataEntry(x: Double($0), y: $1.value)
            dataEnties.append(dataEntry)
        })
    }
    
    private func createLineChartDataSet(with entries: [ChartDataEntry]) -> LineChartDataSet {
        let lineChartDataSet = LineChartDataSet(entries: entries, label: legendTitle)
        lineChartDataSet.axisDependency = .left
        lineChartDataSet.formSize = 20
        lineChartDataSet.form = .circle
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.lineWidth = 2
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.circleRadius = 5
        lineChartDataSet.circleHoleRadius = 2
        lineChartDataSet.fillColor = DTColors.controllSelectedColor
        lineChartDataSet.circleHoleColor = DTColors.backgroundColor
        lineChartDataSet.circleColors = .init(repeating: DTColors.controllSelectedColor, count: entries.count)
        lineChartDataSet.colors = .init(repeating: DTColors.controllSelectedColor, count: 1)
        lineChartDataSet.valueColors = .init(repeating: .white, count: entries.count)
        lineChartDataSet.valueFont = .systemFont(ofSize: 14)
        lineChartDataSet.highlightEnabled = false
        return lineChartDataSet
    }
    
    private func createLineChartData(with lineChartDataSet: LineChartDataSet) -> LineChartData {
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        return lineChartData
    }
    
    private func setUpChartView(with lineChartDataSet: LineChartDataSet) {
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false

        chartView.backgroundColor = DTColors.backgroundColor
        chartView.legend.textColor = .white
        
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
        
        chartView.legend.font = .systemFont(ofSize: 17)
        
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false

        chartView.extraRightOffset = 20
        chartView.extraLeftOffset = 20
        chartView.xAxis.labelCount =  lineChartDataSet.entries.count
        
        chartView.xAxis.drawLimitLinesBehindDataEnabled = true
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.drawLabelsEnabled = true
        chartView.xAxis.granularity = 1
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates.map({ DateHelper.shared.getFormatedDateFrom($0,with: .dateForStatisticsFromat)}))
        
        chartView.leftAxis.axisMaximum = (lineChartDataSet.entries.map({ $0.y}).max() ?? 0) * 1.2
        chartView.xAxis.avoidFirstLastClippingEnabled = false
        chartView.data = createLineChartData(with: lineChartDataSet)
        chartView.setVisibleXRangeMaximum(5)
    }
}
