import UIKit

final class ChoosenExerciseStatisticsViewController: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    private let viewModel: ChoosenExerciseStatisticsViewModel
    private lazy var cellHeight: CGFloat = 300
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Initialization
    init(viewModel: ChoosenExerciseStatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private
private extension ChoosenExerciseStatisticsViewController {
    
    func setup() {
        view.backgroundColor = DTColors.backgroundColor
        tableView.register(UINib(nibName: ExerciseStatisticsCell.xibName, bundle: nil),
                           forCellReuseIdentifier: ExerciseStatisticsCell.cellID)
    }
}

//MARK: - UITableViewDataSource
extension ChoosenExerciseStatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfChartCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseStatisticsCell.cellID, for: indexPath)
        guard let data = viewModel.generateExerciseDataType(for: indexPath.row) else { return cell }
        (cell as? ExerciseStatisticsCell)?.setupCell(for: data, and: viewModel.currentExerciseDate)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ChoosenExerciseStatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TrainingPaternsHeaderView.view()
        view?.tittle.text = viewModel.exerciseTitle
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}
