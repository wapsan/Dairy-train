import UIKit

class ChoosenExerciseStatisticsViewController: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    private let viewModel: ChoosenExerciseStatisticsViewModel
    
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
       return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseStatisticsCell.cellID, for: indexPath)
        
        if let data = viewModel.generateExerciseDataType(for: indexPath.row) {
            (cell as? ExerciseStatisticsCell)?.setupCell(for: data)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension ChoosenExerciseStatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 2.5
    }
}
