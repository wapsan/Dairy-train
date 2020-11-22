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
    private var currentExrciseDate: Date?
    private var todaysXValue: Double = 0
    
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
    func setupCell(for exerciseStatisticsType: ExerciseSatisticType, and currentExerciseDate: Date?) {
        titleLabel.text = exerciseStatisticsType.title
        self.currentExrciseDate = currentExerciseDate
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
        let lineChartDataSet = setupLineChartDataSet(with: entries)
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
    
    private func setupLineChartDataSet(with entries: [ChartDataEntry]) -> LineChartDataSet {
        let lineChartDataSet = LineChartDataSet(entries: entries, label: legendTitle)
        lineChartDataSet.axisDependency = .left
        lineChartDataSet.formSize = 20
        lineChartDataSet.form = .circle
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.lineWidth = 2
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.circleRadius = 5
        lineChartDataSet.circleHoleRadius = 2
        let entriesColors = createColorsFor(entries: entries)
        lineChartDataSet.circleColors =  entriesColors
        lineChartDataSet.fillColor = DTColors.controllSelectedColor
        lineChartDataSet.circleHoleColor = DTColors.backgroundColor
        lineChartDataSet.colors = .init(repeating: DTColors.controllSelectedColor, count: 1)
        lineChartDataSet.valueColors = .init(repeating: .white, count: entries.count)
        lineChartDataSet.valueFont = .systemFont(ofSize: 14)
        lineChartDataSet.highlightEnabled = false
        return lineChartDataSet
    }
    
    private func createColorsFor(entries: [ChartDataEntry]) -> [NSUIColor] {
        var colors: [NSUIColor] = []
        entries.enumerated().forEach({ index, value in
            guard let currentExerciseDate = currentExrciseDate else { return }
            if dates[index] == currentExerciseDate {
                todaysXValue = entries[index].x
                colors.append(.yellow)
            } else {
                colors.append(DTColors.controllSelectedColor)
            }
        })
        return colors
    }
    
    private func setUpChartView(with lineChartDataSet: LineChartDataSet) {
        setupChartViewLayout()
        setupChartViewXAxis()
        setupChartViewYAxis()
        setupChartViewAppereance()
        chartView.xAxis.labelCount =  lineChartDataSet.entries.count
        if lineChartDataSet.entries.map({$0.y}).max() == 0 {
            chartView.leftAxis.axisMaximum = 10
        } else {
            chartView.leftAxis.axisMaximum = (lineChartDataSet.entries.map({ $0.y}).max() ?? 0) * 1.2
        }
        chartView.data = LineChartData(dataSet: lineChartDataSet)
        chartView.setVisibleXRangeMaximum(5)
        chartView.moveViewToX(todaysXValue)
    }
    
    private func setupChartViewLayout() {
        chartView.minOffset = 0
        chartView.extraLeftOffset = 16
        chartView.extraRightOffset = 16
        chartView.extraBottomOffset = 8
        chartView.borderLineWidth = 0
    }
    
    private func setupChartViewXAxis() {
        chartView.scaleXEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawLimitLinesBehindDataEnabled = true
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.drawLabelsEnabled = true
        chartView.xAxis.granularity = 1
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(
            values: dates.map({ DateHelper.shared.getFormatedDateFrom($0,with: .dateForStatisticsFromat)}))
        chartView.xAxis.avoidFirstLastClippingEnabled = false
    }
    
    private func setupChartViewYAxis() {
        chartView.scaleYEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.extraRightOffset = 20
        chartView.extraLeftOffset = 20
    }
    
    private func setupChartViewAppereance() {
        chartView.backgroundColor = DTColors.backgroundColor
        chartView.legend.textColor = .white
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelFont = .systemFont(ofSize: 15)
        chartView.legend.font = .systemFont(ofSize: 17)
    }
}
